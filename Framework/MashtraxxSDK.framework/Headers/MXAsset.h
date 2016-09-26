//
//  MXAsset.h
//  Mashtraxx
//
//  Created by Nigel Grange on 24/05/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockFn.h"

#define __ENABLE_FEATURE_DETECTION

@import UIKit;
@import CoreMedia;

@class AVAsset;
@class AVMutableCompositionTrack;
@class MXFXRenderChain;


@interface MXAssetFocusPoint : NSObject

@property (nonatomic, assign) CGRect normalisedRect;
@property (nonatomic, assign) CGPoint normalisedCentre;

@end

@interface MXAssetTimedFocusPoints : NSObject

@property (nonatomic, strong) NSArray* focusAreas;   // array of CGRect NSValues
@property (nonatomic, assign) NSTimeInterval focusPointStart;
@property (nonatomic, assign) NSTimeInterval focusPointDuration;

@end

@interface MXAsset : NSObject

@property (nonatomic, strong) UIImage* thumbnail;
@property (nonatomic, assign) UIImageOrientation orientation;
@property (nonatomic, assign) CGSize assetSize;

@property (nonatomic, assign) CGAffineTransform transform;
@property (nonatomic, strong) NSString *localIdentifier;
@property (nonatomic, strong) NSDate *creationDate;

@property (nonatomic, strong) NSArray* focusPoints;

-(AVAsset*)composableAsset;
-(void)prepareComposableAssetWithSize:(CGSize)preferredSize completion:(VoidFnBlock)completion;

-(CMTime)addAssetToVideoComposition:(AVMutableCompositionTrack*)videoTrack atTime:(CMTime)time withDuration:(CMTime)duration properties:(NSDictionary*)properties;

-(NSTimeInterval)addAssetToAudioComposition:(AVMutableCompositionTrack*)audioTrack atTime:(NSTimeInterval)time withDuration:(NSTimeInterval)duration properties:(NSDictionary*)properties;

-(void)addDefaultFXToRenderChain:(MXFXRenderChain*)chain;


@end

typedef void (^MXAssetFnBlock)(MXAsset*);
