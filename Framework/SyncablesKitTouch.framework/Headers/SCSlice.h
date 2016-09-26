//
//  SCSlice.h
//  SyncablesPrototype
//
//  Created by Nigel Grange on 25/11/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAudioBuffer.h"
#import "SCPosition.h"
#import "SCLength.h"
#import "SCAnacrusis.h"
#import "SCExitPoint.h"
#import "SCSliceGroup.h"

extern const NSString* SCSliceKeySliceIntensity;
//extern const NSString* SCSliceKeyGroupIntensity;
extern const NSString* SCSliceKeyMusicalFunctions;
extern const NSString *SCSliceKeyTags;
extern const NSString* SCSliceKeyMusicalFunctionClimax;
extern const NSString* SCSliceKeyMusicalFunctionDramaticDropOut;
extern const NSString* SCSliceKeyMusicalFunctionIntensityDecrease;
extern const NSString* SCSliceKeyMusicalFunctionIntensityBuild;
extern const NSString* SCSliceKeyMusicalFunctionStaticSection;
extern const NSString* SCSliceKeyMusicalFunctionUnderscore;
extern const NSString* SCSliceKeyMusicalFunctionRiff;

extern const NSString* SCSliceKeyInstrumentationAcoustic;
extern const NSString* SCSliceKeyInstrumentationMaleVocal;
extern const NSString* SCSliceKeyInstrumentationFemaleVocal;
extern const NSString* SCSliceKeyInstrumentationBrass;
extern const NSString* SCSliceKeyInstrumentationGuitar;
extern const NSString* SCSliceKeyInstrumentationEmotional;
extern const NSString* SCSliceKeyInstrumentationStrings;

@class SCSliceDescriptor;

@interface SCSlice : NSObject <NSCoding,NSCopying>

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) NSUInteger sampleStart;
@property (nonatomic, assign) NSUInteger sampleDuration;

@property (nonatomic, assign) NSInteger loopStart;
@property (nonatomic, assign) NSInteger loopEnd;

@property (nonatomic, strong) SCSliceGroup* group;

@property (nonatomic, strong) SCPosition *position;
@property (nonatomic, strong) SCLength *length;
@property (nonatomic, strong) NSMutableArray * anacrusisList;
@property (nonatomic, strong) NSMutableArray * exitPointList;

-(instancetype)initWithSampleStart:(NSUInteger)start withDuration:(NSUInteger)duration;
-(instancetype)initWithSampleStart:(NSUInteger)start withEnd:(NSUInteger)end;

-(instancetype)initWithLoopableSampleStart:(NSUInteger)start withDuration:(NSUInteger)duration;
-(instancetype)initWithLoopableSampleStart:(NSUInteger)start withEnd:(NSUInteger)end;
-(instancetype)initWithSlice:(SCSlice *) sliceToCopy;

-(instancetype)initWithResource:(NSString*)resourceName;
-(instancetype)initWithPath:(NSString*)resourcePath;

- (NSCoder*) getArchive;
- (void) setFromArchive:(NSCoder *)coder;

-(SCSampleRange)range;
-(SCSampleRange)rangeWithLoopCrossfadeDuration:(NSInteger)loopCrossfadeDuration atStart:(BOOL)start atEnd:(BOOL)end;

-(SCSampleRange)rangefromEntryAnacrusis:(SCAnacrusis*)entryAnacrusis withExitPoint:(SCExitPoint*)point usingAnacrusis:(SCAnacrusis*)anacrusis;


- (void) setFromPlist:(NSString *) sliceName;

-(NSArray*)durations;
-(double)longestDuration;

-(SCSliceDescriptor*)canExitToSlice:(SCSlice*)slice;

-(id)propertyForKey:(const NSString*)key;
-(void)setProperty:(NSObject*)property forKey:(const NSString*)key;

// Property accessors

-(void)setSliceIntensity:(NSInteger)sliceIntensity;
-(void)setMusicalFunctions:(NSArray*)musicalFunctions;
-(void)setInstrumentation:(NSArray*)instrumentation;
-(NSInteger)sliceIntensity;
-(NSArray*)musicalFunctions;
-(NSArray*)instrumentation;

-(BOOL)validateSliceAndFixErrors:(BOOL)fix withEndOfSlice:(NSInteger)endSample;

-(BOOL)isLastExit:(NSUInteger)exitIndex;

@end

typedef void (^SliceFnBlock)(SCSlice*);

