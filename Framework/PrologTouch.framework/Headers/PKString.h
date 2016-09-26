//
//  PKString.h
//  PrologKit
//
//  Created by Vincent Akkermans on 02/09/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import "PKTerm.h"

@interface PKString : PKTerm

-(instancetype)initWithValue:(NSString*)value;
-(NSString*)value;

@end
