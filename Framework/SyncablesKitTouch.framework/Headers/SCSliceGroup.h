//
//  SCSliceGroup.h
//  SyncablesPrototype
//
//  Created by Nigel Grange on 04/12/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif
@class SCSliceSequence;
@class SCSliceFillCriteria;

@interface SCSliceGroup : NSObject <NSCoding>

@property (nonatomic, strong) NSString* webcolor;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) NSInteger intensity;
@property (nonatomic, strong) NSMutableArray* slices;
@property (nonatomic, strong) NSMutableArray* possiblePreviousIntensities;

@property (nonatomic, strong) NSMutableArray* contiguousSlices;

@property (nonatomic, strong) NSMutableArray* timedSliceGroups;


//-(NSArray*)groupDurations;
-(NSArray*)timedSlices;
-(NSArray*)searchDurations;
-(void) syncSliceIntensities:(BOOL) sortFirst;
-(NSArray*)previousIntensitySet;
-(NSArray*)previousAndCurrentIntensitySet;

-(void)prepare;
-(void)addPreviousPossibleItensity:(NSInteger)previous;

-(SCSliceSequence*)prepareSequenceForDuration:(double)duration criteria:(SCSliceFillCriteria*)criteria;

#if TARGET_OS_IPHONE
-(UIColor*)color;
-(void)setColor:(UIColor*)color;
#else
-(NSColor*)color;
-(void)setColor:(NSColor*)color;
#endif
@end