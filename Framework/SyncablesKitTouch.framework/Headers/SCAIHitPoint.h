//
//  SCAIHitPoint.h
//  SyncablesKit
//
//  Created by Vincent Akkermans on 05/09/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCAIHitPoint : NSObject
@property (nonatomic, assign) NSInteger timeOnset;              // required
@property (nonatomic, assign) NSInteger timeToleranceBefore;    // required
@property (nonatomic, assign) NSInteger timeToleranceAfter;     // required
@property (nonatomic, assign) NSInteger intensity;              // required
@property (nonatomic, assign) NSInteger importance;             // required
@end