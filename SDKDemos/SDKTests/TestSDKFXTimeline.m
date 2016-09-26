//
//  TestSDKFXTimeline.m
//  MashtraxxSDK
//
//  Created by Nigel Grange on 25/08/2016.
//  Copyright © 2016 Mashtraxx Ltd. All rights reserved.
//

#import "TestSDKUnitTest.h"

@interface TestSDKFXTimeline : TestSDKUnitTest

@end

@implementation TestSDKFXTimeline

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void)testVideoCompositionWithFX
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
    renderer.duckMashtraxxAudioBehindVideoAudio = YES;

    
    MXFXTimeline* fxTimeline = [[MXFXTimeline alloc] init];
    
    MXFXRenderChain* chain1 = [fxTimeline renderChainWithDuration:10.0];
    [chain1 addShaderWithName:@"fxShaderGreyscale" inBundle:[NSBundle bundleForClass:[TestSDKFXTimeline class]]];
    
    MXFXRenderChain* chain2 = [fxTimeline renderChainWithDuration:10.0];
    [chain2 addShaderWithName:@"fxShaderInverse" inBundle:[NSBundle bundleForClass:[TestSDKFXTimeline class]]];
    
    [renderer applyFXTimeline:fxTimeline];
    
    
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

@end
