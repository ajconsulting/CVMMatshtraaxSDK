//
//  TestSDKAudioTimeline.m
//  MashtraxxSDK
//
//  Created by Nigel Grange on 25/08/2016.
//  Copyright © 2016 Mashtraxx Ltd. All rights reserved.
//

#import "TestSDKUnitTest.h"


@interface TestSDKAudioTimeline : TestSDKUnitTest

@end

@implementation TestSDKAudioTimeline

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testMetadataAvailable {
    MXCloudTrackProvider* cloudTrackProvider = [MXCloudTrackProvider sharedInstanceWithConfig:nil];
    NSDictionary* allTracks = [cloudTrackProvider allAvailableTracksByGenre];
    
    XCTAssert([allTracks allKeys].count > 0,@"Error: Track Database empty");
    
    MXAvailableAudioTrack* track = [self findTestTrackInTracks:allTracks];
    XCTAssert(track != nil,@"Error: Test Track not found");
    
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"RetrieveAudio"];
    
    MXAudioCacheDev* audioCache = [self audioCache];
    [audioCache provideAudioURLForTrack:track progress:nil completion:^{
        
        MXMetadataModel* model = [[MXMetadataModel alloc] init];
        [model loadAudioAndMetadataForTrack:track];
        
        SCSliceCatalog* catalog = model.catalog;
        
        XCTAssert(catalog.slices.count > 0,@"Error: Could not load metadata");
        
        NSLog(@"Loaded metadata: %@", catalog.slices);
        
        if (track.audioUrl != nil) {
            [expectation fulfill];
        }
    } onError:^(NSError *error) {
        NSLog(@"Error retrieving audio: %@", error);
    }];
    
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}


- (void)testCreateTimeline {
    MXCloudTrackProvider* cloudTrackProvider = [MXCloudTrackProvider sharedInstanceWithConfig:nil];
    NSDictionary* allTracks = [cloudTrackProvider allAvailableTracksByGenre];
    
    XCTAssert([allTracks allKeys].count > 0,@"Error: Track Database empty");
    
    MXAvailableAudioTrack* track = [self findTestTrackInTracks:allTracks];
    XCTAssert(track != nil,@"Error: Test Track not found");
    
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"RetrieveAudio"];
    
    MXAudioCacheDev* audioCache = [self audioCache];
    [audioCache provideAudioURLForTrack:track progress:nil completion:^{
        
        MXMetadataModel* model = [[MXMetadataModel alloc] init];
        [model loadAudioAndMetadataForTrack:track];
        
        SCSliceCatalog* catalog = model.catalog;
        
        XCTAssert(catalog.slices.count > 0,@"Error: Could not load metadata");
        
        NSLog(@"Loaded metadata: %@", catalog.slices);
        
        
        // Create timeline containing first three sections of test track
        MXAudioTimeline* audioTimeline = [[MXAudioTimeline alloc] initWithSliceCatalog:model.catalog withSampleRate:[model.audioTrack audioProperties].sampleRate];
        [audioTimeline addSlice:catalog.slices[0]];
        [audioTimeline addSlice:catalog.slices[1]];
        [audioTimeline addSlice:catalog.slices[2]];
        
        
        XCTAssert([audioTimeline duration] > 10,@"Error: Could not generate correct timeline");
        
        NSLog(@"Audio timeline duration = %fs", [audioTimeline duration]);
        
        
        if (track.audioUrl != nil) {
            [expectation fulfill];
        }
    } onError:^(NSError *error) {
    }];
    
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testExportRendereredTimeline {
    MXCloudTrackProvider* cloudTrackProvider = [MXCloudTrackProvider sharedInstanceWithConfig:nil];
    NSDictionary* allTracks = [cloudTrackProvider allAvailableTracksByGenre];
    
    XCTAssert([allTracks allKeys].count > 0,@"Error: Track Database empty");
    
    MXAvailableAudioTrack* track = [self findTestTrackInTracks:allTracks];
    XCTAssert(track != nil,@"Error: Test Track not found");
    
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"RetrieveAudio"];
    
    MXAudioCacheDev* audioCache = [self audioCache];
    [audioCache provideAudioURLForTrack:track progress:nil completion:^{
        
        MXMetadataModel* model = [[MXMetadataModel alloc] init];
        [model loadAudioAndMetadataForTrack:track];
        
        SCSliceCatalog* catalog = model.catalog;
        
        XCTAssert(catalog.slices.count > 0,@"Error: Could not load metadata");
        
        NSLog(@"Loaded metadata: %@", catalog.slices);
        
        
        // Create timeline containing first three sections of test track
        MXAudioTimeline* audioTimeline = [[MXAudioTimeline alloc] initWithSliceCatalog:model.catalog withSampleRate:[model.audioTrack audioProperties].sampleRate];
        [audioTimeline addSlice:catalog.slices[0]];
        [audioTimeline addSlice:catalog.slices[1]];
        [audioTimeline addSlice:catalog.slices[2]];
        
        
        XCTAssert([audioTimeline duration] > 10,@"Error: Could not generate correct timeline");
        
        NSLog(@"Audio timeline duration = %fs", [audioTimeline duration]);
        
        
        NSString* renderPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"renderAudio.wav"];
        
        MXAudioRenderer* renderer = [[MXAudioRenderer alloc] init];
        [renderer configureWithTimelineProvider:audioTimeline withAudioTrack:model.audioTrack];
        
        [renderer renderToFile:renderPath completion:^{
            NSLog(@"Audio render completed: %@", renderPath);
            [expectation fulfill];
        } onError:^(NSError *err) {
            NSLog(@"Error during render: %@", err);
        }];
        
    } onError:^(NSError *error) {
    }];
    
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testSearchForCompatibleSlices {
    MXCloudTrackProvider* cloudTrackProvider = [MXCloudTrackProvider sharedInstanceWithConfig:nil];
    NSDictionary* allTracks = [cloudTrackProvider allAvailableTracksByGenre];
    
    XCTAssert([allTracks allKeys].count > 0,@"Error: Track Database empty");
    
    MXAvailableAudioTrack* track = [self findTestTrackInTracks:allTracks];
    XCTAssert(track != nil,@"Error: Test Track not found");
    
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"RetrieveAudio"];
    
    MXAudioCacheDev* audioCache = [self audioCache];
    [audioCache provideAudioURLForTrack:track progress:nil completion:^{
        
        MXMetadataModel* model = [[MXMetadataModel alloc] init];
        [model loadAudioAndMetadataForTrack:track];
        
        SCSliceCatalog* catalog = model.catalog;
        
        XCTAssert(catalog.slices.count > 0,@"Error: Could not load metadata");
        
        NSLog(@"Loaded metadata: %@", catalog.slices);
        
        
        // Create timeline containing first three sections of test track
        MXAudioTimeline* audioTimeline = [[MXAudioTimeline alloc] initWithSliceCatalog:model.catalog withSampleRate:[model.audioTrack audioProperties].sampleRate];
        [audioTimeline addSlice:catalog.slices[0]];
        [audioTimeline addSlice:catalog.slices[1]];
        
        
        // Search for all slices which can be appended to the first exit of the last entry on the audio timeline
        NSArray* compatibleSliceOptions = [audioTimeline slicesCompatibleWithExitIndex:0 forSlice:[audioTimeline lastEntry].slice];
        NSLog(@"Compatible slice options = %@", compatibleSliceOptions);
        
        // Pick the last option
        [audioTimeline addSliceOption:[compatibleSliceOptions lastObject]];
        
        XCTAssert([audioTimeline duration] > 10,@"Error: Could not generate correct timeline");
        
        
        NSLog(@"Timeline = %@", [audioTimeline allEntries]);
        NSLog(@"Audio timeline duration = %fs", [audioTimeline duration]);
        
        
        NSString* renderPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"renderAudio.wav"];
        
        MXAudioRenderer* renderer = [[MXAudioRenderer alloc] init];
        [renderer configureWithTimelineProvider:audioTimeline withAudioTrack:model.audioTrack];
        
        [renderer renderToFile:renderPath completion:^{
            NSLog(@"Audio render completed: %@", renderPath);
            [expectation fulfill];
        } onError:^(NSError *err) {
            NSLog(@"Error during render: %@", err);
        }];
        
    } onError:^(NSError *error) {
    }];
    
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
