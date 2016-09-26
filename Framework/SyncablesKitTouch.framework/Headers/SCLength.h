//
//  SCLength.h
//  SyncablesPrototype
//
//  Created by LouisMcCallum on 27/11/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCLength : NSObject <NSCoding>

- (instancetype)initWithString:(NSString *)string;

- (void) setWithBars:(NSInteger) bars beats:(NSInteger) beats fraction:(double) fraction andPulses:(double) pulses;
- (BOOL) setWithString:(NSString *) str;
- (NSInteger) getAsSamples;

@property (nonatomic, assign) NSInteger lengthInSamples;

@property (nonatomic, assign) NSInteger bars;
@property (nonatomic, assign) NSInteger beats;
@property (nonatomic, assign) double fraction;
@property (nonatomic, assign) double pulses;

-(BOOL)isEqualToLength:(SCLength*)length;

@end
