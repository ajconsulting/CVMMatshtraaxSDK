//
//  TestSDKUnitTest.h
//  MashtraxxSDK
//
//  Created by Nigel Grange on 25/08/2016.
//  Copyright © 2016 Mashtraxx Ltd. All rights reserved.
//

#ifndef TestSDKUnitTest_h
#define TestSDKUnitTest_h

#import <XCTest/XCTest.h>
#import <MashtraxxSDK/MashtraxxSDK.h>

@interface TestSDKUnitTest : XCTestCase

-(MXAvailableAudioTrack*)findTestTrackInTracks:(NSDictionary*)tracks;
-(MXAudioCacheDev*)audioCache;

@end


#endif /* TestSDKUnitTest_h */
