//
//  MXAudioTimeline.h
//  Mashtraxx
//
//  Created by Nigel Grange on 23/05/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXAudioTimelineDelegate.h"
#import "MXAudioTimelineProvider.h"

@class SCSlice;
@class SCSliceDirector;
@class SCSliceCatalog;
@class SCSlicePosition;
@class MXAudioDiskBuffer;
@class SCSliceEntryOrExitOption;

@protocol SSAudioTrackProvider;

typedef NS_ENUM(NSInteger, MXAudioFeatureSnapType) {
    MXAudioFeatureSnapTypeClosest,
    MXAudioFeatureSnapTypePrevious,
    MXAudioFeatureSnapTypeNext,
};

typedef enum : NSUInteger {
    MXAudioFeatureBar   = 0x01,
    MXAudioFeatureBeat  = 0x02,
    MXAudioFeatureSliceStart  = 0x04,
} MXAudioFeatureType;

@interface MXAudioFeature : NSObject

@property (nonatomic, assign) MXAudioFeatureType feature;
@property (nonatomic, assign) NSInteger featureIndex;
@property (nonatomic, assign) NSInteger positionInSamples;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@end

@interface MXAudioTimelineEntry : NSObject

@property (nonatomic, strong) SCSlice* slice;
@property (nonatomic, assign) NSTimeInterval startTimeInSeconds;
@property (nonatomic, assign) NSTimeInterval durationInSeconds;
@property (nonatomic, assign) NSInteger selectedExitIndex;
@property (nonatomic, assign) NSInteger startPositionInSamples;

-(NSArray*)audioFeatures;
-(NSArray*)audioFeatures:(MXAudioFeatureType)filter;

-(NSArray*)audioFeaturesWithStartTime:(NSTimeInterval)startTime withSampleRate:(NSInteger)sampleRate;
-(NSArray*)filteredAudioFeatures:(MXAudioFeatureType)filter withStartTime:(NSTimeInterval)startTime withSampleRate:(NSInteger)sampleRate;

-(NSInteger)exitCount;
-(NSArray*)availableExitPositions;

-(NSInteger)durationInSamples;

@end

@interface MXAudioTimeline : NSObject <MXAudioTimelineProvider,NSCoding>

@property (nonatomic, weak) id<MXAudioTimelineDelegate> delegate;

- (instancetype)initWithSliceCatalog:(SCSliceCatalog*)catalog withSampleRate:(NSInteger)sampleRate;

-(void)configureDiskBufferWithAudioTrack:(id<SSAudioTrackProvider>)audioTrack;

-(void)clear;
-(NSArray*)allEntries;
-(void)updateDiskBufferFromEntry:(MXAudioTimelineEntry*)entry;
// Slice adding / replacement. Exists are matched automatically
-(BOOL)addSlice:(SCSlice*)slice;
-(BOOL)addSliceOption:(SCSliceEntryOrExitOption*)option;

-(BOOL)replaceLastSliceWithSlice:(SCSlice*)slice;
-(BOOL)removeLastSlice;
-(BOOL)selectExitIndex:(NSInteger)exitIndex forEntry:(MXAudioTimelineEntry*)entry;
-(NSUInteger)removeSlicesAfterSamples:(NSUInteger) samples;
-(void) trimTimelineToSamples:(NSUInteger) samples;
-(MXAudioTimelineEntry*)lastEntry;

-(void)restoreFromSliceDescriptions:(NSArray*)sliceDescriptions;

-(NSTimeInterval)duration;


// Search slice entries which are compatible with given slice
-(NSArray*)slicesCompatibleWithAllExitsForSlice:(SCSlice*)slice;
-(NSArray*)slicesCompatibleWithExitIndex:(NSInteger)exitIndex forSlice:(SCSlice*)slice;

-(NSArray*)audioFeaturesForStartTime:(NSTimeInterval)startTime duration:(NSTimeInterval)duration;
-(NSArray*)audioFeaturesForStartTime:(NSTimeInterval)startTime duration:(NSTimeInterval)duration filterBy:(MXAudioFeatureType)audioFeature;
-(NSArray*)allAudioFeaturesFilteredBy:(MXAudioFeatureType)audioFeature;

-(MXAudioFeature*)snappedFeatureToTime:(NSTimeInterval)time forSnap:(MXAudioFeatureSnapType) snap;
-(NSTimeInterval) getBeatLengthAtTime:(NSTimeInterval) time;
@end
