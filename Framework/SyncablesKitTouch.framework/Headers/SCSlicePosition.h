//
//  SCSlicePosition.h
//  SyncablesPrototype
//
//  Created by Nigel Grange on 26/11/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCSlice;
@class SCSliceComponent;

@interface SCSlicePosition : NSObject

@property (nonatomic, weak) SCSliceComponent* slice;
@property (nonatomic, assign) NSInteger samplePosition;
@property (nonatomic, assign) NSInteger samplesRemaining;

@end
