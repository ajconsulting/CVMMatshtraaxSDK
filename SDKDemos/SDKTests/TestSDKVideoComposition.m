//
//  TestSDKVideoComposition.m
//  MashtraxxSDK
//
//  Created by Nigel Grange on 25/08/2016.
//  Copyright © 2016 Mashtraxx Ltd. All rights reserved.
//

#import "TestSDKUnitTest.h"

@interface TestSDKVideoComposition : TestSDKUnitTest

@end

@implementation TestSDKVideoComposition

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testCompositionWithAudioTimeline
{
    XCTestExpectation* expectation = [self expectationWithDescription:@"VideoRender"];
    
    NSURL* testVideoAssetUrl1 = [[NSBundle bundleForClass:[self class]] URLForResource:@"60secs" withExtension:@"mp4"];
    
    MXVideoAsset* asset1 = [[MXVideoAsset alloc] init];
    asset1.localVideoUrl = testVideoAssetUrl1;
    
    MXVideoTimeline* timeline = [[MXVideoTimeline alloc] init];
    [timeline appendAsset:asset1 forDuration:30.0];
    
    NSTimeInterval duration = [timeline duration];
    XCTAssert(duration == 30.0, @"Invalid timeline duration");
    
    MXVideoRenderer* renderer = [[MXVideoRenderer alloc] init];
    [renderer prepareWithVideoTimeline:timeline];
    
    
    MXCloudTrackProvider* cloudTrackProvider = [MXCloudTrackProvider sharedInstanceWithConfig:nil];
    NSDictionary* allTracks = [cloudTrackProvider allAvailableTracksByGenre];
    MXAvailableAudioTrack* track = [self findTestTrackInTracks:allTracks];
    
    MXAudioCacheDev* audioCache = [self audioCache];
    [audioCache provideAudioURLForTrack:track progress:nil completion:^{
        
        MXMetadataModel* model = [[MXMetadataModel alloc] init];
        [model loadAudioAndMetadataForTrack:track];
        
        
        
        MXAudioTimeline* audioTimeline = [[MXAudioTimeline alloc] initWithSliceCatalog:model.catalog withSampleRate:[model.audioTrack audioProperties].sampleRate];
        [audioTimeline addSlice:model.catalog.slices[0]];
        [audioTimeline addSlice:model.catalog.slices[1]];
        [audioTimeline addSlice:model.catalog.slices[2]];
        [audioTimeline addSlice:model.catalog.slices[3]];
        
        MXAudioRenderer* audioRenderer = [[MXAudioRenderer alloc] init];
        [audioRenderer configureWithTimelineProvider:audioTimeline withAudioTrack:model.audioTrack];
        
        
        NSString* renderPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"render.mov"];
        NSString* audioRenderPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"renderAudio.wav"];
        
        [[NSFileManager defaultManager] removeItemAtPath:renderPath error:nil];
        
        [audioRenderer renderToFile:audioRenderPath completion:^{
            
            [renderer prepareAudioAssetFromPath:audioRenderPath];
            NSLog(@"Audio asset prepared");
            
            [renderer prepareAllAssets:^{
                NSLog(@"->Rendering to %@", renderPath);
                [renderer renderAssetToURL:[NSURL fileURLWithPath:renderPath] completion:^{
                    NSLog(@"Done!");
                    [expectation fulfill];
                } error:^(NSError *err) {
                    NSLog(@"Error: %@", err);
                }];
            }];
            
        } onError:^(NSError *err) {
            NSLog(@"Audio render failed: %@", err);
        }];
        
    } onError:^(NSError *err) {
    }];
    
    
    
    
    
    
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
    
}




-(void)testCompositionSynchronizedWithAudio
{
    XCTestExpectation* expectation = [self expectationWithDescription:@"VideoRender"];
    
    MXCloudTrackProvider* cloudTrackProvider = [MXCloudTrackProvider sharedInstanceWithConfig:nil];
    NSDictionary* allTracks = [cloudTrackProvider allAvailableTracksByGenre];
    MXAvailableAudioTrack* track = [self findTestTrackInTracks:allTracks];
    
    MXAudioCacheDev* audioCache = [self audioCache];
    [audioCache provideAudioURLForTrack:track progress:nil completion:^{
        
        MXMetadataModel* model = [[MXMetadataModel alloc] init];
        [model loadAudioAndMetadataForTrack:track];
        
        
        
        MXAudioTimeline* audioTimeline = [[MXAudioTimeline alloc] initWithSliceCatalog:model.catalog withSampleRate:[model.audioTrack audioProperties].sampleRate];
        [audioTimeline addSlice:model.catalog.slices[0]];
        [audioTimeline addSlice:model.catalog.slices[1]];
        [audioTimeline addSlice:model.catalog.slices[2]];
        [audioTimeline addSlice:model.catalog.slices[3]];
        [audioTimeline addSlice:model.catalog.slices[4]];
        [audioTimeline addSlice:model.catalog.slices[5]];
        
        NSURL* testVideoAssetUrl1 = [[NSBundle bundleForClass:[self class]] URLForResource:@"60secs" withExtension:@"mp4"];
        NSURL* testVideoAssetUrl2 = [[NSBundle bundleForClass:[self class]] URLForResource:@"demoVideoCVA-01-surfsup-2" withExtension:@"mp4"];
        
        
        MXVideoAsset* videoAsset1 = [[MXVideoAsset alloc] init];
        videoAsset1.localVideoUrl = testVideoAssetUrl1;
        
        MXVideoAsset* videoAsset2 = [[MXVideoAsset alloc] init];
        videoAsset2.localVideoUrl = testVideoAssetUrl2;
        
        
        MXVideoTimeline* timeline = [[MXVideoTimeline alloc] init];
        BOOL showVideo1 = YES;
        
        NSArray* bars = [audioTimeline allAudioFeaturesFilteredBy:MXAudioFeatureBar];
        NSLog(@"All bars = %@", bars);
        
        NSInteger barCount = [bars count];
        for (NSInteger i=0; i<barCount; i++) {
            MXAudioFeature* bar = bars[i];
            MXAudioFeature* nextBar = (i == barCount -1) ? nil : bars[i+1];
            
            NSTimeInterval duration = nextBar.timeInterval - bar.timeInterval;
            if (nextBar == nil) {
                duration = [audioTimeline duration] - bar.timeInterval;
            }
            
            if (showVideo1) {
                [timeline appendAsset:videoAsset1 forDuration:duration];
            } else {
                [timeline appendAsset:videoAsset2 forDuration:duration];
            }
            showVideo1 = !showVideo1;
        }
        
        [timeline quantiseEntriesToMatchFps:30.0];
        
        NSTimeInterval duration = [timeline duration];
        XCTAssert(duration == [audioTimeline duration], @"Invalid timeline duration");
        
        MXVideoRenderer* renderer = [[MXVideoRenderer alloc] init];
        [renderer prepareWithVideoTimeline:timeline];
        renderer.duckMashtraxxAudioBehindVideoAudio = NO;
        
        
        MXAudioRenderer* audioRenderer = [[MXAudioRenderer alloc] init];
        [audioRenderer configureWithTimelineProvider:audioTimeline withAudioTrack:model.audioTrack];
        
        NSString* renderPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"render.mov"];
        NSString* audioRenderPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"renderAudio.wav"];
        
        [[NSFileManager defaultManager] removeItemAtPath:renderPath error:nil];
        
        [audioRenderer renderToFile:audioRenderPath completion:^{
            
            [renderer prepareAudioAssetFromPath:audioRenderPath];
            NSLog(@"Audio asset prepared");
            
            [renderer prepareAllAssets:^{
                NSLog(@"->Rendering to %@", renderPath);
                [renderer renderAssetToURL:[NSURL fileURLWithPath:renderPath] completion:^{
                    NSLog(@"Done!");
                    [expectation fulfill];
                } error:^(NSError *err) {
                    NSLog(@"Error: %@", err);
                }];
            }];
            
        } onError:^(NSError *err) {
            NSLog(@"Audio render failed: %@", err);
        }];
        
    } onError:^(NSError *err) {
    }];
    
    
    
    
    
    
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
    
}

/*
-(void)testCompositionWithDuckedAudioTimelineWithImagesSynchronizedWithAudio
{
    MXAudioTimeline* audioTimeline = [[MXAudioTimeline alloc] initWithSliceCatalog:self.catalog withSampleRate:[self.editorModel.audioTrack audioProperties].sampleRate];
    [audioTimeline addSlice:self.catalog.slices[0]];
    [audioTimeline addSlice:self.catalog.slices[1]];
    [audioTimeline addSlice:self.catalog.slices[2]];
    [audioTimeline addSlice:self.catalog.slices[10]];
    [audioTimeline addSlice:self.catalog.slices[11]];
    [audioTimeline addSlice:self.catalog.slices[12]];
    
    
    NSURL* testVideoAssetUrl = [[NSBundle bundleForClass:[self class]] URLForResource:@"60secs" withExtension:@"mp4"];
    NSString* testImageAssetPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"testcard" ofType:@"png"];
    
    
    MXVideoAsset* videoAsset = [[MXVideoAsset alloc] init];
    videoAsset.localVideoUrl = testVideoAssetUrl;
    
    MXImageAsset* imageAsset = [[MXImageAsset alloc] init];
    imageAsset.image = [UIImage imageWithContentsOfFile:testImageAssetPath];
    
    MXVideoTimeline* timeline = [[MXVideoTimeline alloc] init];
    BOOL showimage = YES;
    
    NSArray* bars = [audioTimeline allAudioFeaturesFilteredBy:MXAudioFeatureBar];
    NSLog(@"All bars = %@", bars);
    
    NSInteger barCount = [bars count];
    for (NSInteger i=0; i<barCount; i++) {
        MXAudioFeature* bar = bars[i];
        MXAudioFeature* nextBar = (i == barCount -1) ? nil : bars[i+1];
        
        NSTimeInterval duration = nextBar.timeInterval - bar.timeInterval;
        if (nextBar == nil) {
            duration = [audioTimeline duration] - bar.timeInterval;
        }
        
        if (showimage) {
            [timeline appendAsset:imageAsset forDuration:duration];
        } else {
            [timeline appendAsset:videoAsset forDuration:duration];
        }
        showimage = !showimage;
    }
    
    NSTimeInterval duration = [timeline duration];
    XCTAssert(duration == [audioTimeline duration], @"Invalid timeline duration");
    
    MXVideoRenderer* renderer = [[MXVideoRenderer alloc] init];
    [renderer prepareWithVideoTimeline:timeline];
    renderer.duckMashtraxxAudioBehindVideoAudio = YES;
    
    
    MXAudioRenderer* audioRenderer = [[MXAudioRenderer alloc] init];
    [audioRenderer configureWithTimelineProvider:audioTimeline withAudioTrack:self.editorModel.audioTrack];
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"VideoRender"];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* renderPath = [documentsDirectory stringByAppendingPathComponent:@"render.mov"];
    NSString* audioRenderPath = [documentsDirectory stringByAppendingPathComponent:@"renderAudio.wav"];
    
    [[NSFileManager defaultManager] removeItemAtPath:renderPath error:nil];
    
    [audioRenderer renderToFile:audioRenderPath completion:^{
        
        [renderer prepareAudioAssetFromPath:audioRenderPath];
        NSLog(@"Audio asset prepared");
        
        [renderer prepareAllAssets:^{
            NSLog(@"->Rendering to %@", renderPath);
            [renderer renderAssetToURL:[NSURL fileURLWithPath:renderPath] completion:^{
                NSLog(@"Done!");
                [expectation fulfill];
            } error:^(NSError *err) {
                NSLog(@"Error: %@", err);
            }];
        }];
        
    } onError:^(NSError *err) {
        NSLog(@"Audio render failed: %@", err);
    }];
    
    
    
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    
}
*/

@end
