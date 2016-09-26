//
//  SSAudioPlayerDelegate.h
//  SyncablesStudio
//
//  Created by Nigel Grange on 19/02/2015.
//  Copyright (c) 2015 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSAudioPlayerDelegate <NSObject>

-(void)playheadDidChange:(NSInteger)samplePosition;

@optional
-(void)audioDidFinish;
-(void)audioDidResume;
-(void)loopWasEnabled;
-(void)loopWasDisabled;
-(void)audioDidPause;

@end
