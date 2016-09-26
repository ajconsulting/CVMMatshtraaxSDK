//
//  SCAudioBuffer.h
//  SyncablesPrototype
//
//  Created by Nigel Grange on 24/11/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>

struct SCSampleRange {
    NSInteger startSample;
    NSInteger numberOfSamples;
};

typedef struct SCSampleRange SCSampleRange;

@class SCSliceComponent;

@interface SCAudioBuffer : NSObject

@property (nonatomic, assign) SCSampleRange sampleRange;
@property (nonatomic, assign) NSInteger sampleSize;

@property (nonatomic, strong) SCSliceComponent* originalComponent;


- (instancetype)initWithSampleData:(NSData*)data;

-(void)crossFadeBeginningWithBuffer:(SCAudioBuffer*)buffer withCrossFadeDuration:(NSUInteger)duration;
-(void)crossFadeEndWithBuffer:(SCAudioBuffer*)buffer withCrossFadeDuration:(NSUInteger)duration;

-(NSData*)sampleDataAtPosition:(NSInteger)position samples:(NSInteger)samples;

-(void)overwriteBeginningWithBuffer:(SCAudioBuffer*)buffer crossfadingSamples:(NSInteger)crossfadeSamples;
-(void)overwriteEndWithBuffer:(SCAudioBuffer*)buffer crossfadingSamples:(NSInteger)crossfadeSamples;

-(NSData*)getSampleData;

@end

typedef SCAudioBuffer* (^GetSCAudioBufferFnBlock)();
