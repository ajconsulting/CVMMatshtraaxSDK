//
//  AudioViewController.m
//  MashtraxxSDK
//
//  Created by Nigel Grange on 23/08/2016.
//  Copyright © 2016 Mashtraxx Ltd. All rights reserved.
//

#import "AudioViewController.h"


@implementation UISliceButton
@end

const CGFloat KPreviewSamplesPerPixel = (4410 * 1.2);
const CGFloat KTimelineSamplesPerPixel = (4410 * 1.2) / 8;

const CGFloat KButtonHeight = 40;


@interface AudioViewController ()

@property (nonatomic, strong) MXAvailableAudioTrack* audioTrack;
@property (nonatomic, strong) UIView* playhead;


@end

@implementation AudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.metadataModel = [MXMetadataModel new];
    BOOL ok = [self.metadataModel loadAudioAndMetadataForTrack:self.audioTrack];
    NSLog(@"Loaded audio status = %d", ok);
    
    self.audioTimelinePlayer = [[MXAudioTimelinePlayer alloc] init];
    [self.audioTimelinePlayer configureWithAudioTrack:self.metadataModel.audioTrack];
    
    self.sliceButtons = [[NSMutableArray alloc] init];
    
    for (SCSlice* slice in self.metadataModel.catalog.slices) {
        UIButton* button = [self buttonForSlice:slice forPreview:YES];
        [self.sliceButtons addObject:button];
        [self.view addSubview:button];
    }
    
    self.playhead = [[UIView alloc] initWithFrame:CGRectMake(0,0,1,32)];
    self.playhead.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.playhead];

}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureWithAudioTrack:(MXAvailableAudioTrack*)audioTrack
{
    self.audioTrack = audioTrack;
}

-(void)doneButtonPressed:(id)sender
{
    [self.audioTimelinePlayer stopAllStreams];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UISliceButton*)buttonForSlice:(SCSlice*)slice forPreview:(BOOL)preview
{
    CGFloat lengthInSamples = slice.sampleDuration;
    
    CGFloat buttonWidth = lengthInSamples / (preview ? KPreviewSamplesPerPixel : KTimelineSamplesPerPixel);
    
    UISliceButton* button = [[UISliceButton alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, KButtonHeight)];
    button.slice = slice;
    [button setTitle:[NSString stringWithFormat:@"%ld", (long)slice.position.bars] forState:UIControlStateNormal];
    [button setBackgroundColor:slice.group.color];
    
    [button addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    
    button.layer.borderColor = [[UIColor blackColor] CGColor];
    button.layer.borderWidth = 2.0;
    
    return button;
}
- (IBAction)generate60secondEditFromHitpoints:(id)sender {
}

-(void)viewDidLayoutSubviews
{
    CGFloat width = self.view.frame.size.width;
    CGFloat yPos = 60;
    
    CGFloat xPos = 0;
    
    for (UIButton* button in self.sliceButtons) {
        CGRect rect = button.frame;
        
        CGFloat left = width - xPos;
        if (left < rect.size.width) {
            xPos = 0;
            yPos += KButtonHeight+4;
        }
        
        rect.origin.x = xPos;
        rect.origin.y = yPos;
        
        button.frame = rect;
        
        xPos += rect.size.width;
    }
    
}


-(void)buttonDown:(UISliceButton*)sender
{
    [self previewSlice:sender.slice];
}

-(void)previewSlice:(SCSlice*)slice
{
    MXSlicePreview* preview = [[MXSlicePreview alloc] initWithSlice:slice inSliceCatalog:self.metadataModel.catalog audioProperties:self.metadataModel.audioTrack.audioProperties];
    [preview playUsingTimelinePlayer:self.audioTimelinePlayer delegate:nil];
    
}



#pragma mark - MXAudioTimelinePlayerDelegate

-(void)timelinePlaybackPositionDidChange:(MXAudioTimelineEntry*)entry
                          samplePosition:(NSInteger)samplePosition
                             forTimeline:(id<MXAudioTimelineProvider>)timeline
{
    NSInteger sliceIndex = [self.metadataModel.catalog.slices indexOfObject:entry.slice];
    NSInteger total = [entry durationInSamples];
    
    
    onMainThread(^{
        UISliceButton* button = self.sliceButtons[sliceIndex];
        
        CGFloat xPos = button.frame.origin.x + (button.frame.size.width * (double)samplePosition / (double)total);
        CGRect frame = self.playhead.frame;
        frame.origin.x = xPos;
        frame.origin.y = button.frame.origin.y - 2.0;
        frame.size.height = button.frame.size.height + 4.0;
        self.playhead.frame = frame;
        
    });
    
}

-(void)timelinePlaybackPositionDidChange:(NSInteger)samplesFromStart
                             forTimeline:(id<MXAudioTimelineProvider>) timeline
{
}



@end
