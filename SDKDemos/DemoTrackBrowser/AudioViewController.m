//
//  AudioViewController.m
//  MashtraxxSDK
//
//  Created by Nigel Grange on 23/08/2016.
//  Copyright © 2016 Mashtraxx Ltd. All rights reserved.
//

#import "AudioViewController.h"

@import AVKit;
@import AVFoundation;


@interface AudioViewController ()

@property (nonatomic, strong) MXAvailableAudioTrack* audioTrack;
@property (nonatomic, strong) AVPlayerItem* playerItem;
@property (nonatomic, strong) MXMetadataModel* metadataModel;
@property (nonatomic, strong) MXAudioTimelinePlayer* audioTimelinePlayer;
@end

@implementation AudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = [NSString stringWithFormat:@"%@\n%@",self.audioTrack.trackTitle,self.audioTrack.artist];
    
    self.metadataModel = [MXMetadataModel new];
    BOOL ok = [self.metadataModel loadAudioAndMetadataForTrack:self.audioTrack];
    NSLog(@"Loaded audio status = %d", ok);
//    self.audioTimelinePlayer = [[MXAudioTimelinePlayer alloc] init];
//    [self.audioTimelinePlayer configureWithAudioTrack:self.metadataModel.audioTrack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}


-(void)configureWithAudioTrack:(MXAvailableAudioTrack*)audioTrack
{
    self.audioTrack = audioTrack;
}

- (IBAction)previewTrackButtonPressed:(id)sender {
    [self previewAudioUrl:self.audioTrack.audioUrl];
}


-(void)previewAudioUrl:(NSURL*)audioUrl
{
    NSLog(@"Previewing: %@", audioUrl);
    self.playerItem = [AVPlayerItem playerItemWithURL:audioUrl];
    AVPlayerViewController* player = [AVPlayerViewController new];
    player.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    [player.player play];
    [self presentViewController:player animated:YES completion:nil];
}

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)generate30secondEdit:(UIButton*)sender {
    MXAudioTimeline* timeline = [self.metadataModel generateAudioTimelineWithDuration:30.0];
    [self renderAndPreviewAudioTimeline:timeline];
    
}

- (IBAction)generate60secondEdit:(id)sender {
    MXAudioTimeline* timeline = [self.metadataModel generateAudioTimelineWithDuration:60.0];
    [self renderAndPreviewAudioTimeline:timeline];
}

- (IBAction)generate60secondEditFromHitpoints:(id)sender
{
    NSInteger sr = [self.metadataModel.audioTrack audioProperties].sampleRate;
    
    SCAIBriefingProperties *properties = [[SCAIBriefingProperties alloc] init];
    properties.minDuration = 60 * sr;
    NSInteger maxIntensity = 0;
    for (SCSliceGroup *group in [self.metadataModel.catalog sliceGroups]) {
        maxIntensity = group.intensity > maxIntensity ? group.intensity : maxIntensity;
    }
    
    SCAIHitPoint *hp1 = [[SCAIHitPoint alloc] init];
    hp1.timeOnset = 20 * sr;
    hp1.timeToleranceBefore = -0.25 * sr;
    hp1.timeToleranceAfter = sr;
    hp1.importance = 1;
    hp1.intensity = maxIntensity / 2;
    [properties addHitPoint:hp1];
    
    SCAIHitPoint *hp2 = [[SCAIHitPoint alloc] init];
    hp2.timeOnset = 40 * sr;
    hp2.timeToleranceBefore = -0.25 * sr;
    hp2.timeToleranceAfter = 0.25 * sr;
    hp2.importance = 1;
    hp2.intensity = maxIntensity;
    [properties addHitPoint:hp2];
    
    MXAudioTimeline *timeline = [self.metadataModel generateAudioTimelineWithBrief:properties];
    [self renderAndPreviewAudioTimeline:timeline];
}


-(void)renderAndPreviewAudioTimeline:(MXAudioTimeline*)timeline
{
//    [self.audioTimelinePlayer addAudioStream:[self.audioTimelinePlayer createAudioStreamForProvider:timeline delegate:self]];
//    [self.audioTimelinePlayer playFromStart];
    
    MXAudioRenderer* audioRenderer = [[MXAudioRenderer alloc] init];
    [audioRenderer configureWithTimelineProvider:timeline withAudioTrack:[self.metadataModel audioTrack]];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* audioRenderPath = [documentsDirectory stringByAppendingPathComponent:@"renderAudio.wav"];
    
    [[NSFileManager defaultManager] removeItemAtPath:audioRenderPath error:nil];
    
    [audioRenderer renderToFile:audioRenderPath completion:^{

        
        [self previewAudioUrl:[NSURL fileURLWithPath:audioRenderPath]];
        
        
    } onError:^(NSError *err) {
        NSLog(@"Audio render failed: %@", err);
    }];
    
}

@end
