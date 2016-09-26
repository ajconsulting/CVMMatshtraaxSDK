//
//  SCBriefingSearchTree.h
//  SyncablesPrototype
//
//  Created by Nigel Grange on 05/12/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCTimedSliceGroup;
@class SCSliceCatalog;

@interface SCBriefingSearchTree : NSObject

@property (nonatomic, assign) double timeLeft;
@property (nonatomic, assign) NSInteger sliceIdentifier;

@property (nonatomic, assign) NSInteger weighting;

//@property (nonatomic, weak) SCTimedSliceGroup* timedSliceGroup;
//@property (nonatomic, strong) NSArray*

@property (nonatomic, strong) NSMutableArray* branches;
@property (nonatomic, weak) SCBriefingSearchTree* parent;

-(BOOL)iterateBranchesWithCatalog:(SCSliceCatalog*)catalog;
-(NSArray*)leaves;
-(NSArray*)validLeavesWithIntensity:(NSInteger)intensity;


-(NSArray*)intensitySequence;

@end