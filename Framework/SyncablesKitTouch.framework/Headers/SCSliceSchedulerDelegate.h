//
//  SCSliceSchedulerDelegate.h
//  SyncablesPrototype
//
//  Created by Nigel Grange on 26/11/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCSlicePosition;

@protocol SCSliceSchedulerDelegate <NSObject>

-(void)didScheduleSubSlice:(SCSlicePosition*)position;

@end
