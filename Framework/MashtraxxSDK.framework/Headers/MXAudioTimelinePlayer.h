//
//  MXAudioTimelinePlayer.h
//  Mashtraxx
//
//  Created by Nigel Grange on 23/05/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSAudioTrackProvider.h"
#import "MXAudioTimelineProvider.h"
#import "MXCoordinatedAudioDelegate.h"
#import "SSAudioPlayerDelegate.h"

@class MXAudioTimeline;
@class MXCoordinatedAudio;
@protocol MXAudioTimelinePlayerDelegate;

@interface MXAudioTimelinePlayer : NSObject <MXCoordinatedAudioDelegate, SSAudioPlayerDelegate>

-(void)configureWithAudioTrack:(id<SSAudioTrackProvider>)audioTrack;

-(MXCoordinatedAudio*)createAudioStreamForProvider:(id<MXAudioTimelineProvider>)audioTimeline delegate:(id<MXAudioTimelinePlayerDelegate>)delegate;

-(void)addAudioStream:(MXCoordinatedAudio*)audioStream;

-(void)updatePlayerAfterTimelineChange;

-(void)playIfNeeded;

-(void)playFromStart;
-(void)playFrom:(NSTimeInterval)position;

-(void)stopAllStreams;
-(void)fadeAndStopAllStreams;

-(BOOL)isPlaying;
-(void)pause;
-(void)resume;
-(void)setPlaybackRate:(double)rate;
-(MXCoordinatedAudio*) currentCoordinatedAudio;
-(BOOL)isPlayingStream:(MXCoordinatedAudio *)stream;
-(void)seekToSample:(NSInteger)samplePos;
-(void) skipTo:(NSUInteger) seconds onExistingStream:(id<MXAudioTimelineProvider>)audioTimeline;


@end
