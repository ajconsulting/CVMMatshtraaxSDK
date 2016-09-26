//
//  MXProgressHUD.m
//  Mashtraxx
//
//  Created by Nigel Grange on 19/08/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import "MXProgressHUD.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface MXProgressHUD ()

@property (nonatomic, strong) NSDate* lastUpdate;
@property (nonatomic, assign) BOOL hasSetNotification;
BLOCK_PROPERTY VoidFnBlock cancelOperation;

@end

@implementation MXProgressHUD

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)subscribeToTapNotifications
{
    if (!self.hasSetNotification) {
        self.hasSetNotification = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudTapped:) name:SVProgressHUDDidReceiveTouchEventNotification object:nil];
    }
}

-(void)hudTapped:(id)sender
{
    if (self.cancelOperation) {
        self.cancelOperation();
    }
}

-(void)showProgressIndicator:(CGFloat)amount withCaption:(NSString*)caption withCancellationBlock:(VoidFnBlock)cancelOptionation
{
    self.cancelOperation = cancelOptionation;
    if (self.cancelOperation != nil) {
        [self subscribeToTapNotifications];
    }
    
    NSDate* now = [NSDate date];
    if ([now timeIntervalSinceDate:_lastUpdate ] < 0.1 && _lastUpdate != nil) {
        // Filter out many updates..
        return;
    }
    self.lastUpdate = now;
    [SVProgressHUD showProgress:amount status:caption];
}

-(void)showUndeterminedProgressIndicatorWithCaption:(NSString*)caption withCancellationBlock:(VoidFnBlock)cancelOptionation
{
    self.cancelOperation = cancelOptionation;
    if (self.cancelOperation != nil) {
        [self subscribeToTapNotifications];
    }
    
    [SVProgressHUD showWithStatus:caption];
}

-(void)hideProgressIndicator
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [SVProgressHUD dismiss];
}

        
-(void)showOperationCancelled
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [SVProgressHUD showInfoWithStatus:@"Cancelled"];
    
}

        
@end
