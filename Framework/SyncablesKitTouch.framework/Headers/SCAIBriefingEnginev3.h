//
//  SCAIBriefingEnginev3.h
//  SyncablesKit
//
//  Created by Vincent Akkermans on 01/09/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCSliceCatalog;
@class SCAIBriefingProperties;

@interface SCAIBriefingEnginev3 : NSObject

-(void)configureWithCatalog:(SCSliceCatalog*)catalog;
-(NSArray*)generateArrangements:(SCAIBriefingProperties*)properties maxSolutions:(NSInteger)maxSolutions;

@end
