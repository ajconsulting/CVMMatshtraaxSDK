//
//  MXAudioRenderer.h
//  Mashtraxx
//
//  Created by Nigel Grange on 06/06/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockFn.h"
#import "MXAudioTimelineProvider.h"


@class MXAudioTimeline;
@protocol SSAudioTrackProvider;

@interface MXAudioRenderer : NSObject

-(void)configureWithTimelineProvider:(id<MXAudioTimelineProvider>)audioTimeline withAudioTrack:(id<SSAudioTrackProvider>)audioTrack;

-(void)renderToFile:(NSString*)outputFile completion:(VoidFnBlock)completion onError:(ErrFnBlock)errorBlock;

@end
