//
//  SCSliceProvider.h
//  SyncablesPrototype
//
//  Created by Nigel Grange on 27/11/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCSliceComponent.h"

typedef NS_ENUM(NSUInteger, kSliceProviderUrgency) {
    kSliceUrgencyImmediate,
    kSliceUrgencyAsync
};

@protocol SCSliceProvider <NSObject>

-(void)provideSliceComponentWithUrgency:(enum kSliceProviderUrgency)urgency next:(BOOL) next forUpdate:(BOOL) forUpdate completion:(SliceComponentFnBlock)block;
-(void)provideNextSliceComponentWithUrgency:(enum kSliceProviderUrgency)urgency completion:(SliceComponentFnBlock)block;

-(void)didBeginPlayingSliceComponent:(SCSliceComponent*)component;

@end
