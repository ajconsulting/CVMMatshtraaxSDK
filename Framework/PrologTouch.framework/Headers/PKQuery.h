//
//  PKQuery.h
//  PrologKit
//
//  Created by Nigel Grange on 05/05/2015.
//  Copyright (c) 2015 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PKTerm.h"

@interface PKQuery : NSObject

+(PKQuery*)queryWithPredicate:(NSString*)predicate arguments:(int)arguments;
-(void)setVaribaleArgument:(int)index;
-(void)setDoubleArgument:(int)index value:(double)value;

-(void)open;
-(void)close;
-(BOOL)nextSolution;

-(PKTerm*)termResult:(int)index;
-(NSString*)stringResult:(int)index;
-(double)doubleResult:(int)index;
-(NSArray*)stringListResult:(int)index;
-(NSArray*)integerListResult:(int)index;
-(NSArray*)doubleListResult:(int)index;

@end
