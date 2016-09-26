//
//  SCSliceCatalog.h
//  SyncablesPrototype
//
//  Created by Nigel Grange on 27/11/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCSlice;
@class SCSliceDescriptor;
@class SCSliceSequence;
@class SCSliceGroup;
@class SCExitPoint;
@class SCAnacrusis;
@class SCRange;

@interface SCSliceEntryOrExitOption : NSObject

@property (nonatomic, strong) SCSlice* slice;
@property (nonatomic, strong) SCExitPoint* exit;
@property (nonatomic, strong) SCAnacrusis* anacrusis;
@property (nonatomic) BOOL isNaturalProgressionToNextSlice;
@property (nonatomic) BOOL isNaturalProgressionFromPreviousSlice;

@property (nonatomic, strong) SCSliceEntryOrExitOption* previousExitOption;

@end


@interface SCSliceCatalog : NSObject <NSCoding>

@property (atomic, strong) NSMutableArray* slices;
@property (nonatomic, strong) NSMutableArray* sliceGroups;
@property (nonatomic, strong) NSMutableArray* ranges;
@property (nonatomic, assign) NSInteger crossfadeDuration;

-(void)addSlice:(SCSlice*)slice;
-(void)removeSlice:(SCSlice*)slice;
-(SCSlice*)sliceByName:(NSString*)name;

-(void)addRange:(SCRange*)range;
-(void)removeRange:(SCRange*)range;


-(void)prepare;
-(BOOL)validateSlicesWithEndOfTrackAudio:(NSInteger)samples;
-(BOOL)validateGroups;
-(void)removeDeadEnds;
-(void)fixUnexitableSlices;

-(NSArray*)sliceDescriptionsCompatibleWithDescription:(SCSliceDescriptor*)descriptor;

-(NSArray*)expandedExitPointsForDescriptor:(SCSliceDescriptor*)descriptor;
-(SCSliceGroup*)groupForSliceIdentifier:(NSInteger)slideID;


-(NSArray*)matchingEntriesForExitOption:(SCSliceEntryOrExitOption*)exitOption;
-(NSArray*)matchingExitsForEntryOption:(SCSliceEntryOrExitOption*)entryOption;

-(SCSlice*)firstSlice;
-(SCSlice*)lastSlice;
-(SCSlice*)nextSliceAfter:(SCSlice*)slice;
-(SCSlice*)previousSliceBefore:(SCSlice*)slice;


@end
