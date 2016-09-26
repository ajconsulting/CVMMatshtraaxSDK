//
//  MXAvailableTracksProvider.h
//  Mashtraxx
//
//  Created by Nigel Grange on 16/05/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockFn.h"

@class MXAvailableAudioTrack;

@protocol MXAvailableTracksProvider <NSObject>

-(void)provideAvailableTracks:(nonnull VoidFnBlock)updatedResultsBlock
                                  onError:(nonnull ErrFnBlock)errorBlock;

-(void)retrieveMetadataForTrack:( MXAvailableAudioTrack* _Nonnull )track onSuccess:(_Nonnull DataFnBlock)success onError:(_Nullable ErrFnBlock)errorBlock;
-(NSArray* _Nullable)audioAlignmentForTrack:(MXAvailableAudioTrack* _Nonnull) track;

-(NSArray* _Nullable)matchedResults;
-(NSArray* _Nullable)unmatchedResults;

@end
