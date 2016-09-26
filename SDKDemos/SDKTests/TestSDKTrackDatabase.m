//
//  TestSDKTrackDatabase.m
//  MashtraxxSDK
//
//  Created by Nigel Grange on 25/08/2016.
//  Copyright © 2016 Mashtraxx Ltd. All rights reserved.
//

#import "TestSDKUnitTest.h"

@interface TestSDKTrackDatabase : TestSDKUnitTest

@end

@implementation TestSDKTrackDatabase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTrackDatabase {
    MXCloudTrackProvider* cloudTrackProvider = [MXCloudTrackProvider sharedInstanceWithConfig:nil];
    NSDictionary* allTracks = [cloudTrackProvider allAvailableTracksByGenre];
    
    XCTAssert([allTracks allKeys].count > 0,@"Error: Track Database empty");
    
}


- (void)testFindTestTrackDatabase {
    MXCloudTrackProvider* cloudTrackProvider = [MXCloudTrackProvider sharedInstanceWithConfig:nil];
    NSDictionary* allTracks = [cloudTrackProvider allAvailableTracksByGenre];
    
    XCTAssert([allTracks allKeys].count > 0,@"Error: Track Database empty");
    
    MXAvailableAudioTrack* track = [self findTestTrackInTracks:allTracks];
    XCTAssert(track != nil,@"Error: Test Track not found");
}

-(void)testTrackCount
{
    MXCloudTrackProvider* cloudTrackProvider = [MXCloudTrackProvider sharedInstanceWithConfig:nil];
    NSDictionary* allTracks = [cloudTrackProvider allAvailableTracksByGenre];
    
    NSArray* genres = [allTracks allKeys];
    NSLog(@"Found genres: %@", genres);
    
    NSInteger trackCount = 0;
    
    for (NSString* genre in genres) {
        NSArray* tracks = allTracks[genre];
        trackCount += tracks.count;
    }
    
    NSLog(@"Found %ld tracks", (long)trackCount);
  
    XCTAssert(trackCount > 0,@"Error: Track Database empty");
}

@end
