//
//  MXAudioTimelinePlayerDelegate.h
//  Mashtraxx
//
//  Created by Nigel Grange on 06/06/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MXAudioTimelineEntry;
#import "MXAudioTimelineProvider.h"

@protocol MXAudioTimelinePlayerDelegate <NSObject>

-(void)timelinePlaybackPositionDidChange:(MXAudioTimelineEntry*)entry
                          samplePosition:(NSInteger)samplePosition
                               forTimeline:(id<MXAudioTimelineProvider>)timeline;

-(void)timelinePlaybackPositionDidChange:(NSInteger)samplesFromStart
                               forTimeline:(id<MXAudioTimelineProvider>) timeline;

@optional

-(void)audioDidEnd;

@end
