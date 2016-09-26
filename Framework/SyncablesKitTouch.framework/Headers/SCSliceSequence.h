//
//  SCSliceSequence.h
//  SyncablesPrototype
//
//  Created by Nigel Grange on 03/12/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCSlice;

@interface SCSliceFillCriteria : NSObject

@property (nonatomic, assign) BOOL groupIntensityAscending;
@property (nonatomic, assign) BOOL preferContiguousGroups;
@property (nonatomic, strong) SCSlice* previousSlice;
@property (nonatomic, assign) double timeVariation;
@property (nonatomic, assign) BOOL preferCompatibleSlices;

@end

@interface SCSliceSequence : NSObject

@property (nonatomic, strong) NSArray* slices;
@property (nonatomic, strong) NSMutableArray * anacrusisList;
@property (nonatomic, strong) NSMutableArray * exitPointList;

@property (nonatomic, strong) NSMutableArray* descriptors;

-(BOOL)validateSequence;
-(NSArray*)potentialSliceListFromContiguousSliceArray:(NSArray*)contiguous;

-(void)fillSequenceWithCriteria:(SCSliceFillCriteria*)criteria forDuration:(double)duration usingSlices:(NSArray*)potentialSlices;

@end
