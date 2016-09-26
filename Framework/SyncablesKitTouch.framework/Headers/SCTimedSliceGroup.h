//
//  SCTimedSliceGroup.h
//  SyncablesPrototype
//
//  Created by Nigel Grange on 04/12/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCSliceSequence;

@interface SCTimedSliceGroup : NSObject

@property (nonatomic, assign) double duration;
@property (nonatomic, strong) SCSliceSequence* sequence;

@end
