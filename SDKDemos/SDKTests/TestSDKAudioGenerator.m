//
//  TestSDKAudioGenerator.m
//  MashtraxxSDK
//
//  Created by Nigel Grange on 24/08/2016.
//  Copyright © 2016 Mashtraxx Ltd. All rights reserved.
//

#import "TestSDKUnitTest.h"


@interface TestSDKAudioGenerator : TestSDKUnitTest


@end

@implementation TestSDKAudioGenerator

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testRetrieveTrackAudio {
    MXCloudTrackProvider* cloudTrackProvider = [MXCloudTrackProvider sharedInstanceWithConfig:nil];
    NSDictionary* allTracks = [cloudTrackProvider allAvailableTracksByGenre];
    
    XCTAssert([allTracks allKeys].count > 0,@"Error: Track Database empty");
    
    MXAvailableAudioTrack* track = [self findTestTrackInTracks:allTracks];
    XCTAssert(track != nil,@"Error: Test Track not found");
    

    XCTestExpectation* expectation = [self expectationWithDescription:@"RetrieveAudio"];
    
    MXAudioCacheDev* audioCache = [self audioCache];
    [audioCache provideAudioURLForTrack:track progress:nil completion:^{
        // track.audioUrl now contans the URL to the cached audio stream
        if (track.audioUrl != nil) {
            [expectation fulfill];
        }
    } onError:^(NSError *error) {
    }];


    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}


- (void)testGenerateAudioTimeline {
    MXCloudTrackProvider* cloudTrackProvider = [MXCloudTrackProvider sharedInstanceWithConfig:nil];
    NSDictionary* allTracks = [cloudTrackProvider allAvailableTracksByGenre];
    
    NSAssert([allTracks allKeys].count > 0,@"Error: Track Database empty");
    
    MXAvailableAudioTrack* track = [self findTestTrackInTracks:allTracks];
    XCTAssert(track != nil,@"Error: Test Track not found");
    
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"RetrieveAudio"];
    
    MXAudioCacheDev* audioCache = [self audioCache];
    [audioCache provideAudioURLForTrack:track progress:nil completion:^{
        
        MXMetadataModel* model = [MXMetadataModel new];
        [model loadAudioAndMetadataForTrack:track];
        
        XCTAssert(model.catalog != nil,@"Error: Empty Catalog");
        
        MXAudioTimeline* timeline = [model generateAudioTimelineWithDuration:60.0 tolerance:2.0];
        
        XCTAssert(timeline.duration >= 60.0, @"Error: Timeline too short");
        
        NSLog(@"Generated timeline = %@", [timeline allEntries]);
        
        
        if (track.audioUrl != nil) {
            [expectation fulfill];
        }
    } onError:^(NSError *error) {
    }];
    
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testGenerateAudioTimelineAndSave {
    MXCloudTrackProvider* cloudTrackProvider = [MXCloudTrackProvider sharedInstanceWithConfig:nil];
    NSDictionary* allTracks = [cloudTrackProvider allAvailableTracksByGenre];
    
    NSAssert([allTracks allKeys].count > 0,@"Error: Track Database empty");
    
    MXAvailableAudioTrack* track = [self findTestTrackInTracks:allTracks];
    XCTAssert(track != nil,@"Error: Test Track not found");
    
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"RetrieveAudio"];
    
    MXAudioCacheDev* audioCache = [self audioCache];
    [audioCache provideAudioURLForTrack:track progress:nil completion:^{
        
        MXMetadataModel* model = [MXMetadataModel new];
        [model loadAudioAndMetadataForTrack:track];
        
        XCTAssert(model.catalog != nil,@"Error: Empty Catalog");
        
        MXAudioTimeline* timeline = [model generateAudioTimelineWithDuration:65.0 tolerance:2.0];
        
        XCTAssert(timeline.duration >= 65.0, @"Error: Timeline too short");
        
        NSLog(@"Generated timeline = %@", [timeline allEntries]);
        
        NSString* renderedAudio = [timeline bufferedAudioAssetPath];
        
        NSString* exportTo = [NSTemporaryDirectory() stringByAppendingPathComponent:@"output.wav"];
        
        [[NSFileManager defaultManager] copyItemAtPath:renderedAudio toPath:exportTo error:nil];
        NSLog(@"Exported to %@", exportTo);
        
        if (track.audioUrl != nil) {
            [expectation fulfill];
        }
    } onError:^(NSError *error) {
    }];
    
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)_testGenerateAudioTimelineAndSavex100 {
    MXCloudTrackProvider* cloudTrackProvider = [MXCloudTrackProvider sharedInstanceWithConfig:nil];
    NSDictionary* allTracks = [cloudTrackProvider allAvailableTracksByGenre];
    
    NSAssert([allTracks allKeys].count > 0,@"Error: Track Database empty");
    
    MXAvailableAudioTrack* track = [self findTestTrackInTracks:allTracks];
    XCTAssert(track != nil,@"Error: Test Track not found");
    
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"RetrieveAudio"];
    
    MXAudioCacheDev* audioCache = [self audioCache];
    [audioCache provideAudioURLForTrack:track progress:nil completion:^{
        
        MXMetadataModel* model = [MXMetadataModel new];
        [model loadAudioAndMetadataForTrack:track];
        
        XCTAssert(model.catalog != nil,@"Error: Empty Catalog");
        
        for (NSInteger i=0; i<100; i++) {
        
        MXAudioTimeline* timeline = [model generateAudioTimelineWithDuration:60.0 tolerance:2.0];
        
        XCTAssert(timeline.duration >= 60.0, @"Error: Timeline too short");
        
        NSLog(@"Generated timeline = %@", [timeline allEntries]);
        
        NSString* renderedAudio = [timeline bufferedAudioAssetPath];
        
        NSString* exportTo = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"output-%03ld.wav", (long)i]];
        
        [[NSFileManager defaultManager] copyItemAtPath:renderedAudio toPath:exportTo error:nil];
        NSLog(@"Exported to %@", exportTo);
        }
        
        if (track.audioUrl != nil) {
            [expectation fulfill];
        }
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
