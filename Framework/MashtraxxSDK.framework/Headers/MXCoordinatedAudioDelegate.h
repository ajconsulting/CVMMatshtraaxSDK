//
//  MXCoordinatedAudioDelegate.h
//  Mashtraxx
//
//  Created by Nigel Grange on 03/06/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MXCoordinatedAudio;


@protocol MXCoordinatedAudioDelegate <NSObject>

-(void)audioStreamDidEnd:(MXCoordinatedAudio*)audioStream;
-(void)allStreamsRemoved;

@end

