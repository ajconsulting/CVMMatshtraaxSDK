//
//  MXMetadataModel.h
//  MashtraxxSDK
//
//  Created by Nigel Grange on 23/08/2016.
//  Copyright © 2016 Mashtraxx Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MXAvailableAudioTrack;
@class MXAudioTimeline;
@class SCSliceCatalog;
@class SCAIBriefingProperties;

@protocol SSAudioTrackProvider;

@interface MXMetadataModel : NSObject

-(BOOL)loadAudioAndMetadataForTrack:(MXAvailableAudioTrack*)track;
-(MXAudioTimeline*)generateAudioTimelineWithDuration:(NSTimeInterval)duration;
-(MXAudioTimeline*)generateAudioTimelineWithBrief:(SCAIBriefingProperties *)properties;

-(id<SSAudioTrackProvider>)audioTrack;

-(SCSliceCatalog*)catalog;

@end
