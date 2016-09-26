//
//  AudioViewController.h
//  MashtraxxSDK
//
//  Created by Nigel Grange on 23/08/2016.
//  Copyright © 2016 Mashtraxx Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@import SyncablesKitTouch;
#import <MashtraxxSDK/MashtraxxSDK.h>
@class MXAvailableAudioTrack;

@interface AudioViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
-(void)configureWithAudioTrack:(MXAvailableAudioTrack*)audioTrack;
- (IBAction)previewTrackButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;

@end
