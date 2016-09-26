//
//  MXDatabaseConfig.h
//  Mashtraxx
//
//  Created by Nigel Grange on 22/08/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MXDatabaseConfig <NSObject>

-(NSArray*)featuredTrackIDs;
-(NSArray*)blacklistedTrackIDs;
-(void)updatedFeaturedTrackIDs:(NSArray*)tracks;

@end
