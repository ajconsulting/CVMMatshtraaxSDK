//
//  SCAIBriefingMetadataBuilder.h
//  SyncablesKit
//
//  Created by Nigel Grange on 05/02/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class SCSlice;
@class SCSliceCatalog;
@class SCSliceGroup;

@interface SCAIBriefingMetadataBuilder : NSObject

-(void)addSlice:(SCSlice*)slice;
-(void)addSliceCatalog:(SCSliceCatalog*)catalog;
-(SCSliceGroup*)sliceGroupContainingLongestContiguousSection;
-(CGFloat)longestContiguousSectionForGroup:(SCSliceGroup*)group;
-(CGFloat)totalDurationForSlicesInGroup:(SCSliceGroup*)group;

-(NSArray*)rangesForFollowingGroup:(SCSliceGroup*)group;
-(NSArray*)rangesForPreviousGroup:(SCSliceGroup*)group;

@end
