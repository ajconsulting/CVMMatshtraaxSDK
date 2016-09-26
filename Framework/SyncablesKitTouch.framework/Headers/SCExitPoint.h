//
//  SCExitPoint.h
//  SyncablesPrototype
//
//  Created by LouisMcCallum on 27/11/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCPosition.h"
#import "SCLength.h"
#import "SCAnacrusis.h"

@interface SCExitPoint : NSObject <NSCoding>

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) SCLength * length;
@property (nonatomic, assign) NSInteger xFade;
@property (nonatomic, strong) NSMutableArray * anacrusisList;


@end
