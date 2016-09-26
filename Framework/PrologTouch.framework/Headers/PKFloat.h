//
//  PKFloat.h
//  PrologKit
//
//  Created by Vincent Akkermans on 02/09/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import "PKNumber.h"

@interface PKFloat : PKNumber

-(instancetype)initWithValue:(double)value;
-(double)value;

@end
