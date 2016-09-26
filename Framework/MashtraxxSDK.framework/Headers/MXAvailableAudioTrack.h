//
//  MXAvailableAudioTrack.h
//  Mashtraxx
//
//  Created by Nigel Grange on 16/05/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MXAvailableTracksProvider;

@interface MXAvailableAudioTrack : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString* trackTitle;
@property (nonatomic, strong) NSString* artist;
@property (nonatomic, assign) NSInteger mashtraxxID;
@property (nonatomic, strong) NSString* artworkUrl;
@property (nonatomic, strong) NSString* iTunesID;
@property (nonatomic, strong) NSURL* previewUrl;
@property (nonatomic, strong) NSString* mxUUID;

@property (nonatomic, strong) NSString* localTrackPersistentID;

@property (nonatomic, strong) NSString* genre;

@property (nonatomic, strong) NSURL* audioUrl;

@property (nonatomic, assign) BOOL isCloudItem;

@property (nonatomic, weak) id<MXAvailableTracksProvider> provider;

- (id)copyWithZone:(NSZone *)zone;

@end


typedef void (^MXAvailableAudioTrackFnBlock)(MXAvailableAudioTrack*);

