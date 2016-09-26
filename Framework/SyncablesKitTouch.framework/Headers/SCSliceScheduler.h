//
//  SCSliceScheduler.h
//  SyncablesPrototype
//
//  Created by Nigel Grange on 25/11/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCBufferProvider.h"
#import "SCSliceSchedulerDelegate.h"
#import "SCSliceProvider.h"

@class SCSlice;
@class SCAudioBuffer;
@class SCBufferWriter;

@interface SCSliceScheduler : NSObject

@property (nonatomic, weak) id<SCBufferProvider> bufferProvider;
@property (nonatomic, strong) SCBufferWriter* bufferWriter;
@property (nonatomic, weak) id<SCSliceSchedulerDelegate> delegate;

@property (nonatomic, weak) id<SCSliceProvider> sliceProvider;
@property (nonatomic, assign) BOOL synchronousAudioProduction;

-(void) removeNextSliceComponent;
//-(void) clearNextBuffer;
//-(void) reloadNextBuffer;
-(void) updateBuffers;

-(SCAudioBuffer*)next;

-(SCAudioBuffer*)nextSubSlice;

-(void)writeAll;

@end
