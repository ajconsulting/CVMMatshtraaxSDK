//
//  PKInteger.h
//  PrologKit
//
//  Created by Vincent Akkermans on 02/09/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import "PKNumber.h"

@interface PKInteger : PKNumber

-(instancetype)initWithValue:(NSInteger)value;
-(NSInteger)value;

@end
