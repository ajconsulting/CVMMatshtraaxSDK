//
//  SCSliceComponent.h
//  SyncablesPrototype
//
//  Created by Nigel Grange on 27/11/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAudioBuffer.h"

@class SCBriefSection;
@class SCAudioBuffer;
@class SCSliceDescriptor;

@interface SCSliceComponent : NSObject

@property (nonatomic, assign) NSUInteger sliceStart;
@property (nonatomic, assign) NSUInteger sliceDuration;

@property (nonatomic, assign) NSInteger sliceBeginAnacrusisSamples;
@property (nonatomic, assign) NSInteger sliceBeginAnacrusisSampleOffset;
@property (nonatomic, assign) NSInteger sliceBeginAnacrusisCrossfadeDuration;
@property (nonatomic, assign) NSInteger exitAnacrusisCrossfadeDuration;

@property (nonatomic, assign) NSInteger crossfadeDuration;

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* briefDescription;
@property (nonatomic, strong) SCBriefSection* briefSection;
@property (nonatomic, assign) NSInteger sliceIndex;

@property (nonatomic, strong) SCSliceDescriptor* descriptor;

//@property (nonatomic, assign) NSInteger entryCrossfadeDuration;
//@property (nonatomic, assign) NSInteger exitCrossfadeDuration;

//-(instancetype)initWithSampleStart:(NSUInteger)start withDuration:(NSUInteger)duration;
//-(instancetype)initWithSampleStart:(NSUInteger)start withEnd:(NSUInteger)end;

//-(instancetype)initWithLoopableSampleStart:(NSUInteger)start withDuration:(NSUInteger)duration;
//-(instancetype)initWithLoopableSampleStart:(NSUInteger)start withEnd:(NSUInteger)end;


-(SCSampleRange)rangeFromStartToEnd;
-(SCSampleRange)exitAnnacrusisRange;
-(SCSampleRange)forwardAnnacrusisRangeFromSliceComponent:(SCSliceComponent*)prev;
-(BOOL)isForwardAnacrusis;

//-(SCSampleRange)rangeWithLoopCrossfadeDuration:(NSInteger)loopCrossfadeDuration atStart:(BOOL)start atEnd:(BOOL)end;


@end


typedef void (^SliceComponentFnBlock)(SCSliceComponent*);
