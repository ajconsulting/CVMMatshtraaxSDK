//
//  SCAnacrusis.h
//  SyncablesPrototype
//
//  Created by LouisMcCallum on 27/11/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCPosition.h"
#import "SCLength.h"

@interface SCAnacrusis : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) SCLength *length;
@property (nonatomic, assign) NSInteger sampleOffset;
@property (nonatomic, assign) NSUInteger crossfadeDuration;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithPulses:(NSInteger)pulses;

- (NSInteger) getAsSamples;

-(BOOL)isCompatibleWithAnacrusis:(SCAnacrusis*)ana;

@end
