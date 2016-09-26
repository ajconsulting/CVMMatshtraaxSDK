:- use_module(library(clpfd)).
:- use_module(library(pairs)).
:- use_module(library(lists)).
:- use_module(library(debug)).

:- debug(arrange).

minimum_hitpoint_interval(528000). %705600

first([Head|_], Head).

second([_,Second|_], Second).

third([_,_,Third|_], Third).

slice_start(Slice, Start) :- 
    Slice = slice(_,_,_,slice_start(Start)).

all_slices(Slices) :-
    findall(slice(A,B,C,D), slice(A,B,C,D), All),
    map_list_to_pairs(slice_start, All, Pairs),
    keysort(Pairs, Sorted),
    pairs_values(Sorted, Slices).

intro(SliceName) :- 
    all_slices([Intro|_]),
    Intro = slice(SliceName,_,_,_).

outro(SliceName) :-
    all_slices(Slices),
    last(Slices, Outro),
    Outro = slice(SliceName,_,_,_).

shortest_exit_length(ExitSample) :-
    findall(ES, exit(_, exit_sample(ES), _), ExitLengths),
    sort(ExitLengths, [ExitSample|_]).

longest_exit_length(Slice, ExitSample) :-
    findall(ES, exit(Slice, exit_sample(ES), _), ESS),
    max_list(ESS, ExitSample).

longest_bar_length(Slice, BarLength) :-
    findall(BL, exit(Slice, _, exit_bars(BL)), BLS),
    max_list(BLS, BarLength).

% N.B. check that the sample lengths and offsets are interpreted properly wrt their signs.
connection(Slice1, Slice2, ExitSample, PulseOffset, sample_offset(EarliestSampleOffset)) :-
    exit_anacrusis(Slice1, ExitSample, PulseOffset, sample_length(ExitSampleLength), sample_offset(ExitSampleOffset)),
    entry_anacrusis(Slice2, PulseOffset, sample_length(EntrySampleLength), sample_offset(EntrySampleOffset)),
    EarliestSampleOffset = min(EntrySampleOffset+EntrySampleLength, ExitSampleOffset+ExitSampleLength).

connection(Slice1, Slice2) :-
    findall(connection(S1, S2), connection(S1, S2, _, _, _), R),
    sort(R, RS),
    member(connection(Slice1, Slice2), RS).

connection(Slice1, Slice2, ExitSample) :-
    findall(connection(S1, S2, ES), connection(S1, S2, ES, _, _), R),
    sort(R, RS),
    member(connection(Slice1, Slice2, ExitSample), RS).

loop(Slice) :-
    connection(Slice, Slice).

connection_to_intensity(Slice, ExitSample, Intensity, Slice2) :-
    slice(Slice2, group(Intensity), _, _),
    connection(Slice, Slice2, ExitSample).

connection_to_intensity(Slice, ExitSample, Intensity) :-
    connection_to_intensity(Slice, ExitSample, Intensity, _), !.

next_slice(Slice1, Slice2) :-
    all_slices(Slices),
    nth1(Index1, Slices, slice(Slice1,_,_,_)),
    Index2 is Index1 + 1,
    nth1(Index2, Slices, slice(Slice2,_,_,_)).      

progression_type(Slice1, Slice2, type_natural) :-
    next_slice(Slice1, Slice2), !.

progression_type(Slice1, Slice2, type_group) :-
    not(progression_type(Slice1, Slice2, type_loop)),
    not(progression_type(Slice1, Slice2, type_natural)),
    slice(Slice1, Group, _, _),
    slice(Slice2, Group, _, _), !.
    
progression_type(Slice1, Slice1, type_loop) :- !.

progression_type(Slice1, Slice2, type_other) :-
    not(progression_type(Slice1, Slice2, type_natural)),
    not(progression_type(Slice1, Slice2, type_loop)),
    not(progression_type(Slice1, Slice2, type_group)), !.

exit_type(Slice1, ExitSample, ExitType) :-
    exit(Slice1, ExitSample, exit_bars(Bars)),
    Options = [8, 4, 2, 1],
    member(ExitType, Options),
    0 is mod(Bars, ExitType), 
    !.
    
progression_score(Slice1, Slice2, ExitSample, Score) :-
    progression_type(Slice1, Slice2, ProgressionType),
    exit_type(Slice1, ExitSample, ExitType),
    progression_score(ProgressionType, ExitType, Score).

progression_score(type_natural, 8, 16).
progression_score(type_group,   8, 15).
progression_score(type_natural, 4, 14).
progression_score(type_group,   4, 13).
progression_score(type_natural, 2, 12).
progression_score(type_group,   2, 11).
progression_score(type_other,   8, 10).
progression_score(type_other,   4,  9).
progression_score(type_other,   2,  8).
progression_score(type_natural, 1,  7).
progression_score(type_group,   1,  6).
progression_score(type_other,   1,  5).
progression_score(type_loop,    8,  4).
progression_score(type_loop,    4,  3).
progression_score(type_loop,    2,  2).
progression_score(type_loop,    1,  1).

connection_rank(connection(Slice1, Slice2, ExitSample), R) :-
    progression_score(Slice1, Slice2, ExitSample, R), !.

sort_connections_by_rank(ConnectionsIn, ConnectionsOut) :-
    map_list_to_pairs(connection_rank, ConnectionsIn, Pairs),
    keysort(Pairs, Sorted),
    pairs_values(Sorted, Reversed),
    reverse(Reversed, ConnectionsOut).

ranked_connections(FromSlice, Connections) :-
    findall(connection(FromSlice, ToSlice, ExitSample), connection(FromSlice, ToSlice, ExitSample), All),
    sort_connections_by_rank(All, Connections).

connection_exit_sample(connection(_,_,exit_sample(ES)), ES).

ranked_exits(FromSlice, PossibleExitSamples) :-
    ranked_connections(FromSlice, Connections),
    maplist(connection_exit_sample, Connections, ExitSamples),
    set(ExitSamples, PossibleExitSamples).
       
ranked_connections_reverse(ToSlice, Connections) :-
    findall(connection(FromSlice, ToSlice, ExitSample),
            connection(FromSlice, ToSlice, ExitSample),
            All),
    sort_connections_by_rank(All, Connections).

all_group_intensities(Groups) :- findall(GI, slice(_,group(GI),_,_), GIS), sort(GIS, Groups).

highest_group(Group) :- all_group_intensities(Groups), max_list(Groups, Group).
lowest_group(Group) :- all_group_intensities(Groups), min_list(Groups, Group).

total_group_bar_lengths(Intensity, LengthInBars) :-
    aggregate_all(sum(BL), (slice(Slice,group(Intensity),_,_), longest_bar_length(Slice, BL)), LengthInBars).

most_popular_group(Intensity) :-
    all_group_intensities(GIS),
    findall([BL, GI], (member(GI, GIS), total_group_bar_lengths(GI, BL)), BLGIS),
    sort(0, @>=, BLGIS, [[_,Intensity]|_]).

all_slice_intensities(GroupIntensity, SliceIntensities) :-
    all_group_intensities(GIS),
    member(GroupIntensity, GIS),
    findall(SI, slice(_, group(GroupIntensity), intensity(SI), _), SIS),
    sort(SIS, SliceIntensities).

highest_slice(Group, SliceIntensity) :- all_slice_intensities(Group, SIS), max_list(SIS, SliceIntensity).
lowest_slice(Group, SliceIntensity) :- all_slice_intensities(Group, SIS), min_list(SIS, SliceIntensity).

maximise(Possible) :-
    % N.B. Inversion is an optimisation
    Inverted #= -1 * Possible,
    labeling([min(Inverted)], [Inverted]), 
    Possible #= -1 * Inverted,
    !.

best_shift(Shift, BestShift) :-
    Inverted #= -1 * Shift,
    labeling([min(Inverted)], [Inverted]),
    BestShift = Inverted, !.

minimise(Possible) :-
    labeling([min(Possible)], [Possible]), !.

hitpoint_time_onset(hitpoint(time_onset(TO),_,_,_), TO).
hitpoint_tolerance(hitpoint(_,tolerance(Before,After),_,_), Before, After).
hitpoint_intensity(hitpoint(_,_,intensity(Intensity),_), Intensity).
hitpoint_importance(hitpoint(_,_,_,importance(Importance)), Importance).

slice_matches_hitpoint(SliceName, HP) :-
    hitpoint_intensity(HP, Intensity),
    Slice = slice(SliceName,_,_,_),
    slice_group_intensity(Slice, Intensity).

hitpoint_intrinsically_correct(HP) :-
    hitpoint_intensity(HP, Intensity),
    hitpoint_importance(HP, Importance),
    hitpoint_tolerance(HP, Before, After),
    hitpoint_time_onset(HP, Onset),
    nonvar(Intensity), number(Intensity),
    nonvar(Importance), number(Importance),
    nonvar(Before), number(Before),
    nonvar(After), number(After),
    nonvar(Onset), number(Onset),
    Before =< After,
    Before =< 0,
    After >= 0,
    Onset >= 0.

hitpoint_has_matching_slice(HitPoint) :-
    slice(Slice,_,_,_), 
    slice_matches_hitpoint(Slice, HitPoint), !.

valid_hitpoint(HitPoint) :-
    hitpoint_has_matching_slice(HitPoint),
    hitpoint_intrinsically_correct(HitPoint).

hitpoints_have_increasing_onset_times([],_).
hitpoints_have_increasing_onset_times([HP|HPTail], LastOnset) :-
    hitpoint_time_onset(HP, Onset),
    Onset > LastOnset,
    hitpoints_have_increasing_onset_times(HPTail, Onset).
    
valid_brief(Brief) :-
    Brief = brief(min_duration(MinDuration), hitpoints(HitPoints)),
    nonvar(MinDuration), nonvar(HitPoints),
    maplist(valid_hitpoint, HitPoints),
    hitpoints_have_increasing_onset_times(HitPoints, -1).

sanitized_brief(Original, Sanitized, ShortestInterval) :-
    Original = brief(min_duration(MinDuration), hitpoints(HPS1)),
    only_increasing_hitpoints(HPS1, HPS2),
    without_invalid_intervals(HPS2, HPS3, ShortestInterval),
    only_valid_hitpoints(HPS3, HPS4),
    Sanitized = brief(min_duration(MinDuration), hitpoints(HPS4)).

only_valid_hitpoints(HitPointsIn, HitPointsOut) :-
    include(valid_hitpoint, HitPointsIn, HitPointsOut).

only_increasing_hitpoints(HitPointsIn, HitPointsOut) :-
    only_increasing_hitpoints_h(HitPointsIn, HitPointsOut, -1).

only_increasing_hitpoints_h([], [], _).

only_increasing_hitpoints_h([HP|HPTail], Hole, LastOnset) :-
    hitpoint_time_onset(HP, Onset),
    (
        Onset > LastOnset ->
        (
            Hole = [HP|NewHole],
            only_increasing_hitpoints_h(HPTail, NewHole, Onset)
        );
        (
            only_increasing_hitpoints_h(HPTail, Hole, LastOnset)
        )
    ).

most_important_hitpoint(HitPoint1, HitPoint2, MostImportant) :-
    hitpoint_importance(HitPoint1, Importance1),
    hitpoint_importance(HitPoint2, Importance2),
    (
        Importance1 > Importance2 ->
        (
            MostImportant = HitPoint1
        );
        (
            MostImportant = HitPoint2
        )
    ).

without_invalid_intervals(HitPoints, NewHitPoints, Shortest) :-
    invalid_intervals_indices_sorted_by_importance(HitPoints, Indices, Shortest),
    (
        Indices = [] ->
        (
            NewHitPoints = HitPoints
        );
        (
            first(Indices, FirstIndexToGo),
            nth0(FirstIndexToGo, HitPoints, _, HitPointsWithoutFirstToGo),
            without_invalid_intervals(HitPointsWithoutFirstToGo, NewHitPoints, Shortest)
        )
    ).

invalid_intervals_indices_sorted_by_importance(HitPoints, Indices, Shortest) :-
    HitPoints = [First|Tail],
    invalid_intervals_neighbour_importances_indices(Tail, Pairs, First, 0, Shortest),
    sort(0, @>, Pairs, PairsSorted),
    maplist(second, PairsSorted, Indices).
    
invalid_intervals_neighbour_importances_indices([], [], _, _, _).
invalid_intervals_neighbour_importances_indices([NextHitPoint|Tail], Hole, LastHitPoint, LastIndex, Shortest) :-
    NextIndex is LastIndex + 1,
    hitpoint_time_onset(LastHitPoint, LastOnset),
    hitpoint_time_onset(NextHitPoint, NextOnset),
    hitpoint_importance(LastHitPoint, LastImportance),
    hitpoint_importance(NextHitPoint, NextImportance),
    Diff is NextOnset - LastOnset,
    ((Diff < Shortest) -> Hole = [[NextImportance,LastIndex], [LastImportance,NextIndex] | NewHole] ; NewHole = Hole),
    invalid_intervals_neighbour_importances_indices(Tail, NewHole, NextHitPoint, NextIndex, Shortest).

hitpoint_intervals([], []).
hitpoint_intervals([_], []).
hitpoint_intervals([HP1,HP2|Tail], Intervals) :-
    hitpoint_time_onset(HP1, TO1),
    hitpoint_time_onset(HP2, TO2),
    Diff is TO2-TO1,
    Intervals = [Diff|Hole],
    hitpoint_intervals([HP2|Tail], Hole).
    
hitpoint_intervals_long_enough(HitPoints, MinInterval) :-
    hitpoint_intervals(HitPoints, Intervals),
    forall(member(I, Intervals), I >= MinInterval).

hitpoint_importances(HitPoints, Importances) :-
    maplist(hitpoint_importance, HitPoints, Importances).

list_with_index(In, Out) :- list_with_index(In, Out, 0).
list_with_index([],[], _).
list_with_index([Head|Tail], Out, Index) :-
    NextIndex is Index + 1,
    Out = [[Index, Head]|Rest],
    list_with_index(Tail, Rest, NextIndex).

hitpoint_indices_sorted_by_importance(HitPoints, Indices) :-
    hitpoint_importances(HitPoints, Importances),
    list_with_index(Importances, ImportancesWithIndices),
    map_list_to_pairs(last, ImportancesWithIndices, Pairs),
    keysort(Pairs, Sorted),
    pairs_values(Sorted, ImportancesWithIndicesSorted),
    maplist(first, ImportancesWithIndicesSorted, Indices), !.

brief_hitpoints(Brief, HitPoints) :- Brief = brief(_, hitpoints(HitPoints)).
    
original_brief(Brief) :-
    brief(MinDuration, HitPoints),
    Brief = brief(MinDuration, HitPoints).

brief_by_deletion(Original, NewBrief) :-
    Original = brief(MinDuration, hitpoints(OriginalHitPoints)),
    NewBrief = brief(MinDuration, hitpoints(NewHitPoints)),
    delete_next_hitpoint(OriginalHitPoints, NewHitPoints).
    
delete_next_hitpoint(OriginalHitPoints, NewHitPoints) :-
    OriginalHitPoints = [_,_|_],
    hitpoint_indices_sorted_by_importance(OriginalHitPoints, [Index|_]),
    nth0(Index, OriginalHitPoints, _, HitPointsMinusOne),
    (
        NewHitPoints = HitPointsMinusOne ; 
        delete_next_hitpoint(HitPointsMinusOne, NewHitPoints)
    ).

without_last([_], []).
without_last([X|Xs], [X|WithoutLast]) :- without_last(Xs, WithoutLast), !.

brief_by_loosening(Original, NewBrief, MaxTolerance) :-
    debug(arrange, 'Loosening brief with ~w', [MaxTolerance]),
    Original = brief(MinDuration, hitpoints(OriginalHitPoints)),
    NewBrief = brief(MinDuration, hitpoints(NewHitPoints)),
    hitpoint_indices_sorted_by_importance(OriginalHitPoints, Indices),
    last(Indices, MostImportantIndex),
    without_last(Indices, IndicesButMostImportant),
    loosen_next_hitpoint(IndicesButMostImportant, OriginalHitPoints, NewHitPoints, MaxTolerance),
    nth0(MostImportantIndex, OriginalHitPoints, MostImportantHitPoint, _),
    nth0(MostImportantIndex, NewHitPoints, MostImportantHitPoint, _),
    length(OriginalHitPoints, Length), length(NewHitPoints, Length).

loosen_next_hitpoint([], _, _, _).
loosen_next_hitpoint([Index|Tail], HitPoints, Loosened, MaxTolerance) :-
    nth0(Index, HitPoints, HitPoint, _),
    nth0(Index, Loosened, Loose, _),
    loosened_hitpoint(HitPoint, Loose, MaxTolerance),
    loosen_next_hitpoint(Tail, HitPoints, Loosened, MaxTolerance).

loosened_hitpoint(HitPoint, Loosened, tolerance(NewMin, NewMax)) :-
    HitPoint = hitpoint(A,tolerance(OldMin,OldMax),B,C),
    MinMin is min(NewMin, OldMin),
    MaxMax is max(NewMax, OldMax),
    Loosened = hitpoint(A,tolerance(MinMin,MaxMax),B,C).
    
get_brief(Original, Brief, MaxTolerance, ShortestInterval) :-
    sanitized_brief(Original, Escalation0, ShortestInterval), !,
    ( Escalation1 = Escalation0 ; brief_by_deletion(Escalation0, Escalation1) ),
    ( Escalation2 = Escalation1 ; brief_by_loosening(Escalation1, Escalation2, MaxTolerance)),
    Brief = Escalation2,
    valid_brief(Brief).

original_sequence(FromIntensity, ToIntensity, FromSlice, ToSlice, Duration) :-
    slice(FromSlice, group(FromIntensity), _, slice_start(Start1)),
    slice(ToSlice, group(ToIntensity), _, slice_start(Start2)),
    Start2 > Start1,
    Duration is Start2 - Start1.
    
original_sequence_with_closest_duration(FromIntensity, ToIntensity, FromSlice, ToSlice, TargetDuration) :-
    findall([Duration, Slice1, Slice2], original_sequence(FromIntensity, ToIntensity, Slice1, Slice2, Duration), AllSequences),
    sort(0, @=<, AllSequences, AllSequencesSorted),
    original_sequence_with_closest_duration_h(AllSequencesSorted, TargetDuration, FromSlice, ToSlice).

original_sequence_with_closest_duration_h([], _, _, _) :- fail.
original_sequence_with_closest_duration_h([[Duration, Slice1, Slice2]|T], TargetDuration, FromSlice, ToSlice) :-
    (Duration #>= TargetDuration) -> 
        (FromSlice = Slice1, ToSlice = Slice2) ; 
        original_sequence_with_closest_duration_h(T, TargetDuration, FromSlice, ToSlice).

sublist_from_to(OriginalList, FromElement, ToElement, SubList) :-
    sublist_from_to_h1(FromElement, ToElement, OriginalList, SubList).

sublist_from_to_h1(_, _, [], []).
sublist_from_to_h1(FromElement, ToElement, [H|T], Hole) :-
    (FromElement = H) ->
        sublist_from_to_h2(ToElement, [H|T], Hole) ;
        sublist_from_to_h1(FromElement, ToElement, T, Hole).

sublist_from_to_h2(_, [], []).
sublist_from_to_h2(ToElement, [H|T], Hole) :-
    (ToElement = H) ->
        Hole = [H] ;
        Hole = [H|NewHole], 
        sublist_from_to_h2(ToElement, T, NewHole).
        
original_sequence_between(Slice1, Slice2, Sequence) :-
    all_slices(Slices),
    FromSlice = slice(Slice1,_,_,_),
    ToSlice = slice(Slice2,_,_,_),
    sublist_from_to(Slices, FromSlice, ToSlice, Sequence).

slice_group_intensity(slice(_,group(I),_,_), I).

original_intensities_between(Slice1, Slice2, Intensities) :-
    original_sequence_between(Slice1, Slice2, Sequence),
    maplist(slice_group_intensity, Sequence, Intensities).

intensity_sequence_for_duration(Intensity1, Intensity2, TargetDuration, Intensities) :-
    original_sequence_with_closest_duration(Intensity1, Intensity2, FromSlice, ToSlice, TargetDuration), !,
    original_intensities_between(FromSlice, ToSlice, Intensities).

sequence_for_intensities([], _, Shift, MinTO, MaxTO, [], SequenceDurationSoFar) :-
    SequenceDurationSoFar + Shift #>= MinTO,
    SequenceDurationSoFar + Shift #=< MaxTO.

sequence_for_intensities([NextIntensity|T], PrevFitPoint, Shift, MinTO, MaxTO, Sequence, SequenceDurationSoFar) :-
    SequenceDurationSoFar + Shift #=< MaxTO,
    PrevFitPoint = fitpoint(PrevSlice, exit_sample(PrevExitSample), start_sample(PrevStartSample)),
    SequenceDurationSoFar is PrevExitSample + PrevStartSample,
    ranked_connections(PrevSlice, Connections),
    member(connection(PrevSlice, NextSlice, exit_sample(PrevExitSample)), Connections),
    slice(NextSlice, group(NextIntensity), _, _),
    exit(NextSlice, exit_sample(NextExitSample), _),
    FitPoint = fitpoint(NextSlice, exit_sample(NextExitSample), start_sample(SequenceDurationSoFar)),
    Sequence = [FitPoint|NewHole],
    NewDuration is SequenceDurationSoFar + NextExitSample,
    sequence_for_intensities(T, FitPoint, Shift, MinTO, MaxTO, NewHole, NewDuration).
    
middle_deleted(ListIn, ListOut) :-
    length(ListIn, Length),
    Length >= 3,
    Center is floor((Length - 1) / 2),
    nth0(Center, ListIn, _, ListOut).

middle_deleted_recursive(ListIn, ListOut) :-
    middle_deleted(ListIn, ListDeleted),
    ( 
        ListOut = ListDeleted ;
        middle_deleted_recursive(ListDeleted, ListOut)
    ).
    
set([], []).
set([H|T], [H|T1]) :- subtract(T, [H], T2), set(T2, T1).

without_repeated([],[]).
without_repeated([H|T], ListOut) :- ListOut = [H|Hole], without_repeated(T, Hole, H).
without_repeated([], [], _).
without_repeated([Last|T], ListOut, Last) :- without_repeated(T, ListOut, Last), !.
without_repeated([H|T], ListOut, Last) :- Last \= H, ListOut = [H|NewHole], without_repeated(T, NewHole, H).

intensities_to_try(IntensitiesIn, IntensitiesOut) :-
    without_repeated(IntensitiesIn, IntensitiesNoRepeats),
    findall(MiddleDeleted, middle_deleted_recursive(IntensitiesIn, MiddleDeleted), IntensitiesNoMiddles), 
    AllIntensities = [IntensitiesIn,IntensitiesNoRepeats|IntensitiesNoMiddles],
    set(AllIntensities, AllIntensitiesS), !,
    member(IntensitiesOut, AllIntensitiesS).

sequence_to_final_intensity([], fitpoint(_,_,start_sample(LastStartSample)), TargetMin, TargetMax, Shift, []) :-
    LastStartSample + Shift #>= TargetMin,
    LastStartSample + Shift #=< TargetMax.

sequence_to_final_intensity([NextI|ITail], LastFP, TargetMin, TargetMax, Shift, Sequence) :-
    LastFP = fitpoint(LastSlice, exit_sample(LastExitSample), start_sample(LastStartSample)),
    ranked_connections(LastSlice, Connections),
    member(connection(LastSlice, NextSlice, exit_sample(LastExitSample)), Connections),
    SequenceDurationSoFar is LastExitSample + LastStartSample,
    SequenceDurationSoFar + Shift #=< TargetMax,
    slice(NextSlice, group(NextI), _, _),
    FitPoint = fitpoint(NextSlice, exit_sample(_), start_sample(SequenceDurationSoFar)),
    Sequence = [FitPoint|NewHole],
    sequence_to_final_intensity(ITail, FitPoint, TargetMin, TargetMax, Shift, NewHole).

partial_solutions_timings(HP1, HP2, TargetMin, TargetMax, MaxDuration) :-
    HP1 = hitpoint(time_onset(TO1), tolerance(Before1, _), _, _),
    HP2 = hitpoint(time_onset(TO2), tolerance(Before2, After2), _, _),
    TargetDiff is TO2 - TO1,
    TargetMin is TargetDiff + Before2,
    TargetMax is TargetDiff + After2,
    MaxDuration is ((TargetDiff + After2) - Before1).

partial_solutions_like_original(HP1, HP2, PS) :-
    partial_solutions_timings(HP1, HP2, TargetMin, TargetMax, MaxDuration),
    hitpoint_intensity(HP1, I1),
    hitpoint_tolerance(HP1, Before1, After1),
    hitpoint_intensity(HP2, I2),
    intensity_sequence_for_duration(I1, I2, MaxDuration, IntensitySequence),
    findall(TailIntensities, intensities_to_try(IntensitySequence, [I1|TailIntensities]), AllIntensities),
    once(findnsols(50,
                   [Shift, S],
                   (member(IS, AllIntensities), 
                    slice(FirstSlice, group(I1), _, _),
                    FirstFP = fitpoint(FirstSlice, _, start_sample(0)),
                    S = [FirstFP|NewHole],
                    ShiftRange = Before1..After1,
                    Shift in ShiftRange,
                    sequence_to_final_intensity(IS, FirstFP, TargetMin, TargetMax, Shift, NewHole)),
                   PS)),
    PS \= [].

sequence_to_final_intensity_freeform_h(LastFP, I2, TargetMin, TargetMax, Shift, Sequence) :-
    LastFP = fitpoint(LastSlice, exit_sample(LastExitSample), start_sample(LastStartSample)),
    (
        LastStartSample + Shift #=< TargetMin ->
        (
            % add another slice
            ranked_connections(LastSlice, Connections),
            member(connection(LastSlice, NextSlice, exit_sample(LastExitSample)), Connections),
            SequenceDurationSoFar is LastExitSample + LastStartSample,
            FP = fitpoint(NextSlice, exit_sample(_), start_sample(SequenceDurationSoFar)),
            Sequence = [FP|NewSequence],
            sequence_to_final_intensity_freeform_h(FP, I2, TargetMin, TargetMax, Shift, NewSequence)
        );
        (
            LastStartSample + Shift #=< TargetMax ->
            (
                slice(LastSlice, group(I2), _, _),
                Sequence = []
            )
        )
    ).

sequence_to_final_intensity_freeform(I1, I2, TargetMin, TargetMax, Shift, Sequence) :-
    slice(Slice1,group(I1),_,_),
    FirstFP = fitpoint(Slice1, exit_sample(_), start_sample(0)),
    Sequence = [FirstFP|NextSequence],
    sequence_to_final_intensity_freeform_h(FirstFP, I2, TargetMin, TargetMax, Shift, NextSequence).
    
partial_solutions_freeform(HP1, HP2, PS) :-
    partial_solutions_timings(HP1, HP2, TargetMin, TargetMax, _),
    hitpoint_intensity(HP1, I1),
    hitpoint_tolerance(HP1, Before1, After1),
    hitpoint_intensity(HP2, I2),
    once(findnsols(50,
                   [Shift, Sequence],
                   (ShiftRange = Before1..After1,
                    Shift in ShiftRange,
                    sequence_to_final_intensity_freeform(I1, I2, TargetMin, TargetMax, Shift, Sequence)),
                   PS)).

partial_solutions_for_pairs([], []).
partial_solutions_for_pairs([_], []).
partial_solutions_for_pairs([HP1,HP2|T], Solutions) :-
    (
        (debug(arrange, 'Trying to fit to original path', []),
         partial_solutions_like_original(HP1, HP2, PS), !) ;
        (debug(arrange, 'Falling back to freeform', []),
         partial_solutions_freeform(HP1, HP2, PS))
    ),
    Solutions = [PS|NewSolutions],
    partial_solutions_for_pairs([HP2|T], NewSolutions), !.
    
connect_partials(_, [], [], _).

connect_partials(LastP, [NextPS|PSTail], Arrangement, Shift) :-
    member(NextP, NextPS),
    NextP = [NextPShift, NextPList],
    LastP = [LastPShift, LastPList],
    Shift = NextPShift, 
    Shift = LastPShift,
    last(LastPList, fitpoint(ConnectingSlice,ES,_)),
    NextPList = [fitpoint(ConnectingSlice,ES,_)|NextPTail],
    append(NextPTail, NextArrangement, Arrangement),
    connect_partials(NextP, PSTail, NextArrangement, Shift).

connect_partials([NextPS|PSTail], Arrangement, Shift) :-
    member(NextP, NextPS),
    NextP = [NextPShift, NextPList],
    Shift = NextPShift,
    append(NextPList, NextArrangement, Arrangement),
    connect_partials(NextP, PSTail, NextArrangement, Shift).

fix_fps_start_samples([], [], _).
fix_fps_start_samples([FP|FPTail], NewFPs, Duration) :-
    FP = fitpoint(Slice, exit_sample(ES), _),
    NewFP = fitpoint(Slice, exit_sample(ES), start_sample(Duration)),
    % N.B. won't need this if we pad the end first
    (
        nonvar(ES) -> 
        (
            NewDuration is Duration + ES,
            NewFPs = [NewFP|NewHole],
            fix_fps_start_samples(FPTail, NewHole, NewDuration)
        ) ;
        (
            NewFPs = [NewFP]
        )
    ).

solution4(Arrangement, FulfilledBrief) :-
    original_brief(Original),
    %shortest_exit_length(Shortest),
    %MaxTol is Shortest,
    %MinTol is (-1 * MaxTol),
    MaxTol = 132300,
    MinTol = -22050,
    minimum_hitpoint_interval(MinimumInterval),
    get_brief(Original, Brief, tolerance(MinTol, MaxTol), MinimumInterval),
    Brief = brief(min_duration(MinDuration), hitpoints(HPs)),
    
    
    length(HPs, HPsLength),
    debug(arrange, 'Solver: trying brief with length ~d brief:~N    ~w', 
          [HPsLength, Brief]),

    solution4_h(HPs, MinDuration, Arrangement),
    FulfilledBrief = Brief,

    length(Arrangement, ArrangementLength),
    debug(arrange, 'Solver: found solution with length ~d for brief with length ~d', 
          [ArrangementLength, HPsLength]).

solution4_h(HPs, MinDuration, Arrangement) :-
    HPs = [HP,_|_],
    partial_solutions_for_pairs(HPs, PSS),
    maplist(length, PSS, PSSL),
    debug(arrange, 'Nr. solutions per partial: ~w', [PSSL]),
    debug(arrange, 'Solver: found all partials, will attempt to connect.', []),
    connect_partials(PSS, FPsUnfixed, Shift),
    best_shift(Shift, BestShift), % TODO: make sure we optimise this for the most important hitpoint.
    hitpoint_time_onset(HP, HPOnset),
    FPOnset is HPOnset + BestShift,
    fix_fps_start_samples(FPsUnfixed, FPs, FPOnset),
    partial_solution_pad_front(FPs, FPsWithFront),
    last(FPsWithFront, LastFP),
    partial_solution_pad_back(LastFP, MinDuration, FinalFPs),
    append(FPsWithFront, FinalFPs, FPsWithBack),
    Arrangement = FPsWithBack.

solution4_h([HP], MinDuration, Arrangement) :-
    hitpoint_intensity(HP, I),
    hitpoint_time_onset(HP, Onset),
    slice(Slice, group(I), _, _),
    FP = fitpoint(Slice, exit_sample(_), start_sample(Onset)),
    partial_solution_pad_front([FP], FPsWithFront),
    last(FPsWithFront, LastFP),
    partial_solution_pad_back(LastFP, MinDuration, FinalFPs),
    append(FPsWithFront, FinalFPs, Arrangement).

solution4_h([], MinDuration, Arrangement) :-
    most_popular_group(HI),
    Onset is floor(MinDuration / 2),
    HP = hitpoint(time_onset(Onset),tolerance(-1,1),intensity(HI),importance(1)),
    solution4_h([HP], MinDuration, Arrangement).
 
% TODO: try alternative method of going from HP to HP, by ignoring the original sequence

partial_solution_pad_front(FPs, FPsOut) :-
    FPs = [FP|_],
    FP = fitpoint(ToSlice, _, start_sample(StartSample)),
    (
        StartSample =< 0 ->
        (
            FPsOut = FPs
        );
        (
            ranked_connections_reverse(ToSlice, Connections), !,
            member(connection(FromSlice, ToSlice, exit_sample(ExitSample)), Connections),
            NewStartSample is StartSample - ExitSample,
            NewFP = fitpoint(FromSlice, exit_sample(ExitSample), start_sample(NewStartSample)),
            NewFPs = [NewFP|FPs],
            partial_solution_pad_front(NewFPs, FPsOut)
        )
    ).

partial_solution_pad_back(LastFP, MinDuration, Sequence) :-
    LastFP = fitpoint(LastSlice, exit_sample(ES), start_sample(SS)),
    ranked_connections(LastSlice, Connections),
    member(connection(LastSlice, NextSlice, exit_sample(ES)), Connections),
    NewDuration is SS + ES,
    (
        (NewDuration >= MinDuration) ->
        (
            Sequence = []
        );
        (
            NewFP = fitpoint(NextSlice, _, start_sample(NewDuration)),
            Sequence = [NewFP|NewHole],
            partial_solution_pad_back(NewFP, MinDuration, NewHole)
        )
    ).
