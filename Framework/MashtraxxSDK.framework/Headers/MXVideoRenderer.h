//
//  MXVideoRenderer.h
//  Mashtraxx
//
//  Created by Nigel Grange on 26/05/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockFn.h"
@import CoreGraphics;
@import CoreMedia;

@class MXVideoTimeline;
@class MXFXTimeline;
@class MXTakeFX;

@class AVAsset;
@class AVVideoComposition;
@class AVAssetExportSession;
@class AVAudioMix;

@interface MXVideoRenderer : NSObject

@property (nonatomic, assign) CGSize preferredVideoSize;
@property (nonatomic, strong) AVAssetExportSession *_Nullable exportSession;
@property (nonatomic, assign) BOOL showProgress;
@property (nonatomic, assign) BOOL duckMashtraxxAudioBehindVideoAudio;
@property (nonatomic, assign) NSTimeInterval automaticFadeOutDuration;
@property (nonatomic, assign) CGFloat fps;

-(void)prepareWithVideoTimeline:(MXVideoTimeline* _Nonnull)timeline;

// Generate playable / exportable asset  (AVComposition)
-(AVAsset* _Nullable)generateAssetWithVideoAudio:(BOOL)includeVideoAudio;


// Sub-components of the render pipeline

-(void)prepareAllAssets:(VoidFnBlock _Nonnull)completion;
-(void)prepareAudioAssetFromPath:(NSString* _Nonnull)path;
-(void)prepareAudioAssetFromURL:(NSURL* _Nonnull)url;

// Generate audio from video timeline. AudioAssetPath for exporting should be a .m4a file
-(void)generateAudioAssetForVideoTimeline:(NSString* _Nonnull)audioAssetPath completion:(VoidFnBlock _Nonnull)completion error:(ErrFnBlock _Nullable)errorBlock;

-(MXFXTimeline* _Nullable)generateDefaultVideoCompositor;
-(void)applyFXToAllAssets:(MXTakeFX* _Nonnull)takeFX;
-(AVAudioMix* _Nullable)audioMixForAutomaticFadeoutForAsset:(AVAsset* _Nonnull)asset;

-(AVVideoComposition* _Nullable)videoCompositionForAsset:(AVAsset* _Nonnull)asset withSize:(CGSize)size;

-(void)renderAssetToURL:(NSURL* _Nonnull)url completion:(VoidFnBlock _Nonnull)completion error:(ErrFnBlock _Nullable)errorBlock;

-(CMTime)playbackEndTime;

-(void) setRenderOrientation:(BOOL) portrait;

// FX

-(void)applyFXTimeline:(MXFXTimeline* _Nonnull)fxTimeline;
@end
