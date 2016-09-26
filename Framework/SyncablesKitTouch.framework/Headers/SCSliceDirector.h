//
//  SCSliceDirector.h
//  SyncablesPrototype
//
//  Created by Nigel Grange on 27/11/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCSliceCatalog.h"
#import "SCSliceProvider.h"
#import "SyncablesBlockFn.h"
#import "SCBriefSection.h"

@class SCSliceDescriptor;
@class SCBriefSection;

@interface SCSliceDirector : NSObject <SCSliceProvider>

@property (nonatomic, strong) SCSliceCatalog* sliceCatalog;
@property (nonatomic, assign) double duration;
@property (nonatomic, strong) NSMutableArray* briefSections;
@property (nonatomic, strong) NSMutableArray* descriptors;

-(void)addSlice:(SCSlice*)slice;
-(void)addSliceDescriptor:(SCSliceDescriptor*)descriptor;
-(double)addSliceDescriptorWithAnacrusisMatching:(SCSliceDescriptor*)descriptor;
-(double)addBriefSection:(SCBriefSection*)briefSection;
-(double)appendBriefSection:(SCBriefSection*)briefSection;

-(void)reset;
-(void)returnToBeginning;
-(NSInteger) skipToNearestSlice:(NSInteger) sample;
-(void) skipToSlice:(NSInteger) index;

-(void)replaceLastDescriptor:(SCSliceDescriptor*)descriptor;
-(void)removeLastDescriptor;
-(void)removeDescriptorsFromEnd:(NSInteger) amount;
-(void)rewindNextSliceByCount:(NSInteger)count;

-(BOOL) isPlayingLastDescriptor;
-(BOOL) isPlayingPenultimateDescriptor;
-(void)dump;

-(void)skipToNextBriefSection;

BLOCK_PROPERTY BriefSectionFnBlock didBeginBriefingSection;
BLOCK_PROPERTY SliceComponentFnBlock didBeginNewSlice;
BLOCK_PROPERTY VoidFnBlock didEndBriefing;
BLOCK_PROPERTY VoidFnBlock nextSliceDescriptorRequired;

-(NSInteger)intensityForSliceDescriptor:(SCSliceDescriptor*)descriptor;
-(NSInteger)groupIntensityForSliceDescriptor:(SCSliceDescriptor*)descriptor;
-(double)durationForSliceDescriptor:(SCSliceDescriptor*)descriptor;
//-(double)durationForBriefSection:(SCBriefSection*)section;

-(SCSlice*)lastScheduledSlice;

@end
