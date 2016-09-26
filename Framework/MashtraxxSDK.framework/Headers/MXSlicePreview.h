//
//  MXSlicePreview.h
//  Mashtraxx
//
//  Created by Nigel Grange on 24/05/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXAudioTimeline.h"
@class MXCoordinatedAudio;
@class SSAudioProperties;
@class MXAudioTimelinePlayer;
@protocol MXAudioTimelinePlayerDelegate;

@interface MXSlicePreview : MXAudioTimeline

- (instancetype)initWithSlice:(SCSlice*)slice inSliceCatalog:(SCSliceCatalog*)catalog audioProperties:(SSAudioProperties*)audioProperties;
- (MXCoordinatedAudio*)playUsingTimelinePlayer:(MXAudioTimelinePlayer*)player delegate:(id<MXAudioTimelinePlayerDelegate>)delegate;

@end
