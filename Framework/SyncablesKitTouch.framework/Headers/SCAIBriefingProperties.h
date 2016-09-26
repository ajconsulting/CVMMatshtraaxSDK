//
//  SCAIBriefingProperties.h
//  SyncablesKit
//
//  Created by Nigel Grange on 05/08/2015.
//  Copyright (c) 2015 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCAIHitPoint;

@interface SCAIBriefingProperties : NSObject
@property (nonatomic, assign) NSInteger minDuration;
-(void) addHitPoint:(SCAIHitPoint *)hitPoint;
-(NSArray*)getHitpoints;
@end
