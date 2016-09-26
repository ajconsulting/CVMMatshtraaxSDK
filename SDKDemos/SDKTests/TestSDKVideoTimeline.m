//
//  TestSDKVideoTimeline.m
//  MashtraxxSDK
//
//  Created by Nigel Grange on 25/08/2016.
//  Copyright © 2016 Mashtraxx Ltd. All rights reserved.
//

#import "TestSDKUnitTest.h"

@import AVFoundation;

@interface TestSDKVideoTimeline : TestSDKUnitTest

@end

@implementation TestSDKVideoTimeline

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testAddingAssetsToTimeline
{
    NSURL* testVideoAssetUrl = [[NSBundle bundleForClass:[self class]] URLForResource:@"60secs" withExtension:@"mp4"];
    
    MXVideoAsset* asset = [[MXVideoAsset alloc] init];
    asset.localVideoUrl = testVideoAssetUrl;
    
    MXVideoTimeline* timeline = [[MXVideoTimeline alloc] init];
    [timeline appendAsset:asset forDuration:10.0];
    [timeline appendAsset:asset forDuration:10.0];
    
    NSTimeInterval duration = [timeline duration];
    XCTAssert(duration == 20.0, @"Invalid timeline duration");
}


-(void)testCompositionWithVideoAssets
{
    NSURL* testVideoAssetUrl = [[NSBundle bundleForClass:[self class]] URLForResource:@"60secs" withExtension:@"mp4"];
    
    MXVideoAsset* asset = [[MXVideoAsset alloc] init];
    asset.localVideoUrl = testVideoAssetUrl;
    
    MXVideoTimeline* timeline = [[MXVideoTimeline alloc] init];
    [timeline appendAsset:asset forDuration:10.0];
    [timeline appendAsset:asset forDuration:10.0];
    
    NSTimeInterval duration = [timeline duration];
    XCTAssert(duration == 20.0, @"Invalid timeline duration");
    
    MXVideoRenderer* renderer = [[MXVideoRenderer alloc] init];
    [renderer prepareWithVideoTimeline:timeline];
    
    AVAsset* composition = [renderer generateAssetWithVideoAudio:NO];
    XCTAssert(composition != nil,@"Generated nil composition");
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"VideoRender"];
    
    NSString* renderPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"render.mov"];
    [[NSFileManager defaultManager] removeItemAtPath:renderPath error:nil];
    
    NSLog(@"->Rendering to %@", renderPath);
    [renderer renderAssetToURL:[NSURL fileURLWithPath:renderPath] completion:^{
        NSLog(@"Done!");
        [expectation fulfill];
    } error:^(NSError *err) {
        NSLog(@"Error: %@", err);
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
    
}

-(void)testCompositionWithVideoAssetsWithModifiedStartTime
{
    NSURL* testVideoAssetUrl = [[NSBundle bundleForClass:[self class]] URLForResource:@"60secs" withExtension:@"mp4"];
    
    MXVideoAsset* asset = [[MXVideoAsset alloc] init];
    asset.localVideoUrl = testVideoAssetUrl;
    
    MXVideoTimeline* timeline = [[MXVideoTimeline alloc] init];
    MXVideoTimelineEntry* entry1 = [timeline appendAsset:asset forDuration:10.0];
    MXVideoTimelineEntry* entry2 = [timeline appendAsset:asset forDuration:10.0];
    
    [entry1 setAssetStartTime:10.0];
    [entry2 setAssetStartTime:30.0];
    
    NSTimeInterval duration = [timeline duration];
    XCTAssert(duration == 20.0, @"Invalid timeline duration");
    
    MXVideoRenderer* renderer = [[MXVideoRenderer alloc] init];
    [renderer prepareWithVideoTimeline:timeline];
    
    AVAsset* composition = [renderer generateAssetWithVideoAudio:NO];
    XCTAssert(composition != nil,@"Generated nil composition");
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"VideoRender"];
    
    NSString* renderPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"render.mov"];
    [[NSFileManager defaultManager] removeItemAtPath:renderPath error:nil];
    
    NSLog(@"->Rendering to %@", renderPath);
    [renderer renderAssetToURL:[NSURL fileURLWithPath:renderPath] completion:^{
        NSLog(@"Done!");
        [expectation fulfill];
    } error:^(NSError *err) {
        NSLog(@"Error: %@", err);
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
    
}


-(void)testCompositionWithTrimmedVideoAssets
{
    NSURL* testVideoAssetUrl = [[NSBundle bundleForClass:[self class]] URLForResource:@"60secs" withExtension:@"mp4"];
    
    MXVideoAsset* asset = [[MXVideoAsset alloc] init];
    asset.localVideoUrl = testVideoAssetUrl;
    
    MXVideoTimeline* timeline = [[MXVideoTimeline alloc] init];
    [timeline appendAsset:asset forDuration:10.0];
    
    [timeline trimTimelineToLength:5.0];
    
    [timeline appendAsset:asset forDuration:10.0];
    
    NSTimeInterval duration = [timeline duration];
    XCTAssert(duration == 15.0, @"Invalid timeline duration");
    
    MXVideoRenderer* renderer = [[MXVideoRenderer alloc] init];
    [renderer prepareWithVideoTimeline:timeline];
    
    AVAsset* composition = [renderer generateAssetWithVideoAudio:NO];
    XCTAssert(composition != nil,@"Generated nil composition");
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"VideoRender"];
    
    NSString* renderPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"render.mov"];
    [[NSFileManager defaultManager] removeItemAtPath:renderPath error:nil];
    
    NSLog(@"->Rendering to %@", renderPath);
    [renderer renderAssetToURL:[NSURL fileURLWithPath:renderPath] completion:^{
        NSLog(@"Done!");
        [expectation fulfill];
    } error:^(NSError *err) {
        NSLog(@"Error: %@", err);
    }];
    
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
    
}

-(void)testCompositionWithVideoAndImageAssets
{
    NSURL* testVideoAssetUrl = [[NSBundle bundleForClass:[self class]] URLForResource:@"60secs" withExtension:@"mp4"];
    NSString* testImageAssetPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"testcard" ofType:@"png"];
    
    
    MXVideoAsset* videoAsset = [[MXVideoAsset alloc] init];
    videoAsset.localVideoUrl = testVideoAssetUrl;
    
    MXImageAsset* imageAsset = [[MXImageAsset alloc] init];
    imageAsset.image = [UIImage imageWithContentsOfFile:testImageAssetPath];
    
    MXVideoTimeline* timeline = [[MXVideoTimeline alloc] init];
    [timeline appendAsset:imageAsset forDuration:5.0];
    [timeline appendAsset:videoAsset forDuration:5.0];
    
    NSTimeInterval duration = [timeline duration];
    XCTAssert(duration == 10.0, @"Invalid timeline duration");
    
    MXVideoRenderer* renderer = [[MXVideoRenderer alloc] init];
    [renderer prepareWithVideoTimeline:timeline];
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"VideoRender"];
    
    NSString* renderPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"render.mov"];
    [[NSFileManager defaultManager] removeItemAtPath:renderPath error:nil];
    
    [renderer prepareAllAssets:^{
        NSLog(@"->Rendering to %@", renderPath);
        [renderer renderAssetToURL:[NSURL fileURLWithPath:renderPath] completion:^{
            NSLog(@"Done!");
            [expectation fulfill];
        } error:^(NSError *err) {
            NSLog(@"Error: %@", err);
        }];
    }];
    
    
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
    
}




@end
