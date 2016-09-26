//
//  SCAISolution.h
//  SyncablesKit
//
//  Created by Vincent Akkermans on 08/09/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCAIBriefingProperties;

@interface SCAISolution : NSObject
@property (strong, nonatomic) NSArray* sliceDescriptors;
@property (assign, nonatomic) NSInteger samplesToDiscard;
@property (strong, nonatomic) SCAIBriefingProperties *fulfilledBrief;
@end
