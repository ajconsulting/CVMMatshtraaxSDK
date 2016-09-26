//
//  MXAudioTimelineDelegate.h
//  Mashtraxx
//
//  Created by Nigel Grange on 23/05/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCSlice;
@class MXAudioTimelineEntry;

@protocol MXAudioTimelineDelegate <NSObject>

-(void)didBeginPlayingSlice:(SCSlice*)slice;
-(void)audioTimelineDidAppend;
-(void)audioTimelineDidChange;
-(void)audioTimelineDidRemove;
-(void)audioTimelineDidTrim;
@optional
-(void)willRequireNextSlice;

@end
