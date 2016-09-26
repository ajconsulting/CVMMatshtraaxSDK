//
//  SSAudioTrackProvider.h
//  SyncablesStudio
//
//  Created by Nigel Grange on 09/02/2015.
//  Copyright (c) 2015 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSSampleRange.h"

@class SSAudioBuffer;
@class SSAudioProperties;

@protocol SSAudioTrackProvider <NSObject>

-(SSAudioProperties*)audioProperties;
-(SSAudioBuffer*)provideAudioForCompleteRange;
-(SSAudioBuffer*)provideAudioForSampleRange:(SSSampleRange)range;
-(NSInteger)availableSamples;
-(NSInteger)sampleSize;
-(id<SSAudioTrackProvider>)duplicate;

@end
