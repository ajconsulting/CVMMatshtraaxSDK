//
//  MXAudioCacheDev.h
//  MashtraxxSDK
//
//  Created by Nigel Grange on 25/08/2016.
//  Copyright © 2016 Mashtraxx Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockFn.h"
#import "MXProgressDelegate.h"

@class MXAvailableAudioTrack;

@interface MXAudioCacheDev : NSObject<NSURLSessionDownloadDelegate>

- (instancetype)initWithSecret:(NSString*)secret;
-(void)provideAudioURLForTrack:(MXAvailableAudioTrack*)track progress:(id<MXProgressDelegate>)progress completion:(VoidFnBlock)completionBlock onError:(ErrFnBlock)errorBlock;
@end
