//
//  PKCompound.h
//  PrologKit
//
//  Created by Vincent Akkermans on 02/09/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import "PKTerm.h"

@interface PKCompound : PKTerm

-(instancetype)initWithFunctor:(NSString*)functor andArguments:(NSArray*)arguments;
-(NSString*)functor;
-(PKTerm*)argument:(int)index;
-(NSInteger)arity;

@end
