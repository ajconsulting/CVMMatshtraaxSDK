//
//  MXFXTimeline.h
//  Mashtraxx
//
//  Created by Nigel Grange on 08/06/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXFXRenderChain.h"
#import "MXFXParamProvider.h"
#import "MXAnimationPath.h"

@import UIKit;

@class MXVideoTimelineEntry;

@interface MXFXTimelineEntry : NSObject

@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval duration;
@property (atomic, strong) MXFXRenderChain* renderChain;
@property (nonatomic, assign) CGAffineTransform transform;
@property (nonatomic, assign) BOOL aspectScaleToFill;
@property (nonatomic, assign) BOOL swapSrcAspectRatio;
@property (nonatomic, strong) id<MXAnimationPath> animationPath;

-(void)setTransformFromAssetTransform:(CGAffineTransform)transform;

@end

@interface MXFXTimeline : NSObject

-(MXFXRenderChain*)renderChainWithDuration:(NSTimeInterval)duration;

-(NSArray*)allEntries;

-(MXFXTimelineEntry*)addRenderChain:(MXFXRenderChain*)renderChain forVideoEntry:(MXVideoTimelineEntry*)videoEntry;


-(void)provideRenderParamaters:(NSArray*)providers;

@end
