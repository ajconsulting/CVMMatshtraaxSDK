//
//  SCBriefingDirector.h
//  SyncablesPrototype
//
//  Created by Nigel Grange on 02/12/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCSliceDirector;
@class SCBriefSection;
@class SCSliceFillCriteria;

@interface SCBriefingDirector : NSObject

@property (nonatomic, strong) SCSliceDirector* sliceDirector;

-(SCBriefSection*)allSlicesForIntensity:(NSInteger)intensity;
-(SCBriefSection*)groupProgressionFromIntensity:(NSInteger)fromI toIntensity:(NSInteger)toI criteria:(SCSliceFillCriteria*)critiera withDuration:(double)duration;
-(SCBriefSection*)slicesForIntensity:(NSInteger)intensity criteria:(SCSliceFillCriteria*)critiera withDuration:(double)duration;

@end
