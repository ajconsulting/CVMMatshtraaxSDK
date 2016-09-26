//
//  MXVideoAsset.h
//  Mashtraxx
//
//  Created by Nigel Grange on 24/05/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXAsset.h"
@class AVAsset;

typedef NS_ENUM(NSInteger, MXLiveCapturePlaybackSpeed) {
    MXLiveCapturePlaybackSpeedNormal,
    MXLiveCapturePlaybackSpeedSlow,
    MXLiveCapturePlaybackSpeedFast
};

@interface MXVideoAsset : MXAsset<NSCoding>

@property (nonatomic, strong) AVAsset* asset;
@property (nonatomic, strong) NSURL* localVideoUrl;
@property (nonatomic, assign) BOOL doScaleAsset;
@property (nonatomic, assign) MXLiveCapturePlaybackSpeed playbackSpeed;
@property (nonatomic, assign) NSTimeInterval start;

@property (nonatomic, assign) NSTimeInterval duration;

-(UIImage*)firstVideoFrame;
-(NSString *) uniqueKey;


@end
