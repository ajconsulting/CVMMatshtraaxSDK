//
//  MashtraxxSDK.h
//  MashtraxxSDK
//
//  Created by Nigel Grange on 22/08/2016.
//  Copyright © 2016 Mashtraxx Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for MashtraxxSDK.
FOUNDATION_EXPORT double MashtraxxSDKVersionNumber;

//! Project version string for MashtraxxSDK.
FOUNDATION_EXPORT const unsigned char MashtraxxSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <MashtraxxSDK/PublicHeader.h>

// Utiltiies
#import <MashtraxxSDK/BlockFn.h>

// Low level API
//#import <MashtraxxSDK/SCSliceCatalog.h>
//#import <MashtraxxSDK/SCSlice.h>
//#import <MashtraxxSDK/SCPosition.h>
//#import <MashtraxxSDK/SCLength.h>
//#import <MashtraxxSDK/SCExitPoint.h>
//#import <MashtraxxSDK/SCAnacrusis.h>
//#import <MashtraxxSDK/SCSliceGroup.h>
//#import <MashtraxxSDK/SCAudioBuffer.h>
//
//
#import <MashtraxxSDK/SSAudioTrackProvider.h>
#import <MashtraxxSDK/SSSampleRange.h>
#import <MashtraxxSDK/SSAudioProperties.h>
#import <MashtraxxSDK/SSAudioPlayerDelegate.h>

// Audio Cache / Track Database
#import <MashtraxxSDK/MXAudioCacheDev.h>
#import <MashtraxxSDK/MXCloudTrackProvider.h>
#import <MashtraxxSDK/MXAvailableTracksProvider.h>
#import <MashtraxxSDK/MXAvailableAudioTrack.h>
#import <MashtraxxSDK/MXDatabaseConfig.h>
#import <MashtraxxSDK/MXProgressDelegate.h>
#import <MashtraxxSDK/MXMetadataModel.h>


// Audio API
#import <MashtraxxSDK/MXAudioTimelineProvider.h>
#import <MashtraxxSDK/MXAudioRenderer.h>
#import <MashtraxxSDK/MXAudioTimeline.h>
#import <MashtraxxSDK/MXCoordinatedAudioDelegate.h>


// Audio Playback

#import <MashtraxxSDK/MXSlicePreview.h>
#import <MashtraxxSDK/MXAudioTimelinePlayer.h>
#import <MashtraxxSDK/MXAudioTimelinePlayerDelegate.h>


// Video Timeline
#import <MashtraxxSDK/MXAsset.h>
#import <MashtraxxSDK/MXImageAsset.h>
#import <MashtraxxSDK/MXVideoAsset.h>
#import <MashtraxxSDK/MXVideoTimeline.h>

// Video Renderer
#import <MashtraxxSDK/MXVideoRenderer.h>

// Video FX
#import <MashtraxxSDK/MXFXTimeline.h>
#import <MashtraxxSDK/MXFXRenderChain.h>
#import <MashtraxxSDK/MXFXRenderComponent.h>
#import <MashtraxxSDK/MXFXParamProvider.h>
#import <MashtraxxSDK/MXGLResource.h>


// Animation Path

#import <MashtraxxSDK/MXAnimationPath.h>
#import <MashtraxxSDK/MXDefaultAnimationPath.h>



