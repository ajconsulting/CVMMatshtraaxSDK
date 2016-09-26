//
//  MXVideoTimeline.h
//  Mashtraxx
//
//  Created by Nigel Grange on 26/05/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;
@import CoreMedia;

@class MXAsset;
@class MXTransition;
@class MXTake;


typedef NS_ENUM(NSInteger, MXTimelineEntryOverlap) {
    MXTimelineEntryOverlapNone,
    MXTimelineEntryOverlapEndOverStart,
    MXTimelineEntryOverlapStartOverEnd,
    MXTimelineEntryOverlapWithin,
    MXTimelineEntryOverlapCovers,
};



@interface MXVideoTimelineEntry : NSObject<NSCoding>

@property (nonatomic, strong) MXAsset* _Nonnull asset;

- (instancetype _Nullable)initWithAsset:(MXAsset* _Nonnull)asset withDuration:(NSTimeInterval)duration;
-(NSTimeInterval)startTime;
-(NSTimeInterval)duration;
-(NSDictionary* _Nullable)properties;
-(void)setValue:(id _Nullable)value forKey:(const NSString* _Nonnull)key;

// Asset modifiers
-(void)lockVideoStartTimeToTimelineStartingFrom:(NSTimeInterval)startTime;
-(void)setAssetStartTime:(NSTimeInterval)startTime;

-(MXVideoTimelineEntry* _Nullable)entryWithStartTimeShiftedTo:(NSTimeInterval)startTime;
-(MXVideoTimelineEntry* _Nonnull)duplicate;
@property(nonatomic, strong) MXTake *_Nullable fromTake;
@property (nonatomic, assign) CMTime quantisedStartTime;
@property (nonatomic, assign) CMTime quantisedDuration;

@property (nonatomic, strong) NSDictionary* _Nullable customProperties;

@end

@interface MXVideoTimeline : NSObject

-(MXVideoTimelineEntry* _Nonnull)appendAsset:(MXAsset* _Nonnull)asset forDuration:(NSTimeInterval)duration;
-(MXVideoTimelineEntry* _Nonnull)appendAsset:(MXAsset* _Nonnull)asset forDuration:(NSTimeInterval)duration withTransition:(MXTransition* _Nonnull)transition withTransitionDuration:(NSTimeInterval)transitionDuration;
-(void)trimTimelineToLength:(NSTimeInterval)length;
-(void)appendTimelineEntry:(MXVideoTimelineEntry* _Nonnull)timelineEntry;

-(NSTimeInterval)duration;
-(NSArray* _Nonnull)allEntries;
-(NSArray* _Nonnull)allEntriesBetweenStartTime:(NSTimeInterval)startTime andEndTime:(NSTimeInterval)endTime;

-(MXTimelineEntryOverlap) does:(MXVideoTimelineEntry *_Nonnull) entry1
                       overlap:(MXVideoTimelineEntry *_Nonnull) entry2;
-(void) updateEntry:(MXVideoTimelineEntry* _Nonnull)entry
       withDuration:(NSTimeInterval)duration
      correctOverlaps:(BOOL) correctOverlaps;
-(MXVideoTimelineEntry* _Nonnull) beginEntryWithAsset:(MXAsset* _Nonnull)asset
                                               atTime:(NSTimeInterval)startTime
                                        correctOverlaps:(BOOL) correctOverlaps;
-(MXVideoTimelineEntry *_Nullable) lastUpdatedEntry;

-(BOOL) isEntryAtTime:(NSTimeInterval) time;

-(MXVideoTimeline* _Nonnull)duplicate;

-(void)quantiseEntriesToMatchFps:(CGFloat)fps;
@end
