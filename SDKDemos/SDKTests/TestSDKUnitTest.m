//
//  TestSDKUnitTest.m
//  MashtraxxSDK
//
//  Created by Nigel Grange on 25/08/2016.
//  Copyright © 2016 Mashtraxx Ltd. All rights reserved.
//
#import "TestSDKUnitTest.h"

const NSInteger KTestTrackID = 227176;

#define SDK_SECRET @"b5f86592-b5ea-49f1-a439-9a3d45c8f36b"

@implementation TestSDKUnitTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(MXAudioCacheDev*)audioCache
{
    return [[MXAudioCacheDev alloc] initWithSecret:SDK_SECRET];
}

-(MXAvailableAudioTrack*)findTrackId:(NSInteger)trackID inTracks:(NSDictionary*)tracks
{
    for (NSString* genre in [tracks allKeys]) {
        for (MXAvailableAudioTrack* track in tracks[genre]) {
            if (track.mashtraxxID == trackID) {
                return track;
            }
        }
    }
    return nil;
}


-(MXAvailableAudioTrack*)findTestTrackInTracks:(NSDictionary*)tracks
{
    return [self findTrackId:KTestTrackID inTracks:tracks];
}


@end
