//
//  AudioViewController.h
//  MashtraxxSDK
//
//  Created by Nigel Grange on 23/08/2016.
//  Copyright © 2016 Mashtraxx Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MashtraxxSDK/MashtraxxSDK.h>
@import SyncablesKitTouch;

@class MXAvailableAudioTrack;
@class SCSlice;
@class MXAudioTimelineEntry;
@class MXAudioTimelinePlayer;

@interface UISliceButton : UIButton
@property (nonatomic, strong) SCSlice* slice;
@property (nonatomic, strong) MXAudioTimelineEntry* entry;
@end


@interface AudioViewController : UIViewController <MXAudioTimelinePlayerDelegate>


@property (nonatomic, strong) MXAudioTimelinePlayer* audioTimelinePlayer;
@property (nonatomic, strong) MXMetadataModel* metadataModel;
@property (nonatomic, strong) NSMutableArray* sliceButtons;

-(void)configureWithAudioTrack:(MXAvailableAudioTrack*)audioTrack;

@end
