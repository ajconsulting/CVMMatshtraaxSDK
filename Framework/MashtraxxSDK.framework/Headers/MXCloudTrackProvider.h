//
//  MXCloudTrackProvider.h
//  Mashtraxx
//
//  Created by Duncan on 11/08/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXAvailableTracksProvider.h"
#import "MXDatabaseConfig.h"

@interface MXCloudTrackProvider : NSObject <MXAvailableTracksProvider>

+(MXCloudTrackProvider*)sharedInstanceWithConfig:(id<MXDatabaseConfig>)config;

- (instancetype)initWithConfig:(id<MXDatabaseConfig>)config;
- (NSDictionary*)allAvailableTracksByGenre;
- (NSArray *)availableTracksMatchingString:(NSString *)searchTerm;

@end
