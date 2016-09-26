//
//  ExploreAudioViewController.m
//  MashtraxxSDK
//
//  Created by Nigel Grange on 23/08/2016.
//  Copyright © 2016 Mashtraxx Ltd. All rights reserved.
//

#import "ExploreAudioViewController.h"
@import SyncablesKitTouch;
@import MashtraxxSDK;

@interface ExploreAudioViewController ()
@property (nonatomic, strong) MXAudioTimeline* audioTimeline;
@property (nonatomic, strong) SCSlice* currentlyPlayingSlice;


@end

@implementation ExploreAudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.audioTimeline = [[MXAudioTimeline alloc] initWithSliceCatalog:self.metadataModel.catalog withSampleRate:self.metadataModel.audioTrack.audioProperties.sampleRate];
    self.audioTimeline.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonDown:(UISliceButton*)sender
{
    [self playFromSlice:sender.slice];
}

-(void)playFromSlice:(SCSlice*)slice
{
    if (![self.audioTimelinePlayer isPlaying]) {
        // If not playing, reset timeline, and add just this slice
        [self.audioTimeline clear];
        [self.audioTimeline addSlice:slice];
        
        [self findNextContiguousSlice:slice];
        
        [self.audioTimelinePlayer addAudioStream:[self.audioTimelinePlayer createAudioStreamForProvider:self.audioTimeline delegate:self]];
        [self.audioTimelinePlayer playFromStart];
    } else {
        // Replace last slice with this one
        [self.audioTimeline replaceLastSliceWithSlice:slice];
        
        [self updatePlayingStatus];
    }
}

-(SCSlice*)findNextContiguousSlice:(SCSlice*)current
{
    NSInteger index = [self.metadataModel.catalog.slices indexOfObject:current];
    if (self.metadataModel.catalog.slices.count-1 > index) {
        return self.metadataModel.catalog.slices[index+1];
    } else {
        return nil;
    }
}


-(void)updatePlayingStatus
{
    SCSlice* current = self.currentlyPlayingSlice;
    
    SCSlice* next = [self.audioTimeline lastEntry].slice;
    
    NSArray* nextCompatibleSlices = [self.audioTimeline slicesCompatibleWithExitIndex:0 forSlice:current];
    
    onMainThread(^{
        for (UISliceButton* button in self.sliceButtons) {
            
            UIColor* borderColor = [UIColor blackColor];
            
            BOOL available = NO;
            for (SCSliceEntryOrExitOption* option in nextCompatibleSlices) {
                if (option.slice == button.slice) {
                    available = YES;
                }
            }
            
            button.enabled = available;
            if (available) {
                [button setBackgroundColor:button.slice.group.color];
            } else {
                [button setBackgroundColor:[UIColor lightGrayColor]];
                borderColor = [UIColor lightGrayColor];
            }
            
            if (button.slice == current) {
                borderColor = [UIColor greenColor];
            }
            if (button.slice == next) {
                borderColor = [UIColor redColor];
            }
            button.layer.borderColor = [borderColor CGColor];
            
        }
    });
}


#pragma mark - MXAudioTimelineDelegate

-(void)didBeginPlayingSlice:(SCSlice*)slice
{
    NSLog(@"Playing %@", slice);
    self.currentlyPlayingSlice = slice;
    [self updatePlayingStatus];
}

-(void)audioTimelineDidAppend
{
    [self audioTimelineChanged];
    
}

-(void)audioTimelineDidChange
{
    [self audioTimelineChanged];
    [self.audioTimelinePlayer updatePlayerAfterTimelineChange];
}

-(void)audioTimelineDidRemove
{
    
}

-(void)audioTimelineDidTrim
{
    
}

-(void)willRequireNextSlice
{
    [self scheduleNextSlice];
}

-(void)audioTimelineChanged
{
    
}

-(void)scheduleNextSlice
{
    // Add next contiguous slice
/*
    if (self.sliceToPlayNext) {
        NSLog(@"Adding next slice: %@", self.sliceToPlayNext);
        [self.audioTimeline addSlice:self.sliceToPlayNext];
        self.sliceToPlayNext = nil;
    } else {
        MXAudioTimelineEntry* lastEntry = [self.audioTimeline lastEntry];
        SCSlice* next = [self findNextContiguousSlice:lastEntry.slice];
        
        if (next) {
            NSLog(@"Adding contguous slice: %@", next);
            [self.audioTimeline addSlice:next];
        }
    }
    
    [self updatePlayingStatus];
*/

    MXAudioTimelineEntry* lastEntry = [self.audioTimeline lastEntry];
    SCSlice* next = [self findNextContiguousSlice:lastEntry.slice];
    
    if (next) {
        NSLog(@"Adding contguous slice: %@", next);
        [self.audioTimeline addSlice:next];
        [self updatePlayingStatus];
    }
 

}


@end
