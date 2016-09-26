//
//  PKIntegration.h
//  PrologKit
//
//  Created by Nigel Grange on 05/05/2015.
//  Copyright (c) 2015 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PKIntegration : NSObject

+(BOOL)initializeProlog:(BOOL)withDebug;
+(void)runInteractiveShell;

+(BOOL)consult:(NSString*)path;

@end
