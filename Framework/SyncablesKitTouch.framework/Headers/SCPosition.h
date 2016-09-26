//
//  SCPosition.h
//  SyncablesPrototype
//
//  Created by LouisMcCallum on 27/11/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#ifndef SyncablesPrototype_SCPosition_h
#define SyncablesPrototype_SCPosition_h
#import "SCLength.h"

@interface SCPosition : NSObject <NSCoding>

- (instancetype)initWithString:(NSString *)string withTempo:(double)tempo;

- (void) setWithBars:(NSInteger) bars beats:(NSInteger) beats fraction:(double) fraction andPulses:(double) pulses;
- (void) setWithString:(NSString *) str;

@property (nonatomic, assign) NSInteger bars;
@property (nonatomic, assign) NSInteger beats;
@property (nonatomic, assign) double fraction;
@property (nonatomic, assign )double pulses;
@property (nonatomic, assign) double tempo;
@end

#endif
