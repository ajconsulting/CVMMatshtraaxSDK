//
//  MXAudioTimelineProvider.h
//  Mashtraxx
//
//  Created by Nigel Grange on 24/05/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCSliceDirector;
@class SCSlicePosition;
@class MXAudioTimelineEntry;
@class MXAudioDiskBuffer;

@protocol MXAudioTimelineProvider <NSObject>

-(SCSliceDirector*)director;
-(NSInteger)durationInSamples;
-(MXAudioTimelineEntry*)entryFromPlayingPosition:(SCSlicePosition*)position;

-(MXAudioDiskBuffer*)buffferedAudioProvider;
-(NSString*)bufferedAudioAssetPath;

@end
