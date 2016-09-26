//
//  MXProgressDelegate.h
//  Mashtraxx
//
//  Created by Nigel Grange on 19/08/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockFn.h"
@import CoreGraphics;

@protocol MXProgressDelegate <NSObject>

-(void)showProgressIndicator:(CGFloat)amount withCaption:(NSString*)caption withCancellationBlock:(VoidFnBlock)cancelOptionation;
-(void)showUndeterminedProgressIndicatorWithCaption:(NSString*)caption withCancellationBlock:(VoidFnBlock)cancelOptionation;
-(void)hideProgressIndicator;
-(void)showOperationCancelled;
@end
