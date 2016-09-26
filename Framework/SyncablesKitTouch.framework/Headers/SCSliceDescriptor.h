//
//  SCSliceDescriptor.h
//  SyncablesPrototype
//
//  Created by Nigel Grange on 27/11/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCSlice;
@class SCBriefSection;
@class SCSliceCatalog;

@interface SCSliceDescriptor : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) NSInteger entryAnacrusisIndex;
@property (nonatomic, assign) NSInteger exitIndex;
@property (nonatomic, assign) NSInteger exitAnacrusisIndex;

@property (nonatomic, assign) NSInteger followingEntryAnacrusisIndex;

@property (nonatomic, strong) SCBriefSection* briefSection;
@property (nonatomic, assign) NSInteger sliceIndex;
@property (nonatomic, assign) BOOL hasSkipped;

@property (nonatomic) BOOL isNaturalProgressionToNextSlice;
@property (nonatomic) BOOL isNaturalProgressionFromPreviousSlice;

-(NSString*)descriptionWithSlice:(SCSlice*)slice;

-(BOOL)setEntryToMatchPreviousSliceExit:(SCSliceDescriptor*)prevDesc inCatalog:(SCSliceCatalog*)catalog;
-(BOOL)setExitToMatchNextSliceEntry:(SCSliceDescriptor*)nextDesc inCatalog:(SCSliceCatalog*)catalog;
-(BOOL)setExitToMatchNextSliceEntryForExistingExit:(SCSliceDescriptor*)nextDesc inCatalog:(SCSliceCatalog*)catalog;

@end
