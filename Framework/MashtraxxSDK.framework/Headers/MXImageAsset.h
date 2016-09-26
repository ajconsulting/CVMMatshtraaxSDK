//
//  MXImageAsset.h
//  Mashtraxx
//
//  Created by Nigel Grange on 24/05/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXAsset.h"

@import UIKit;

@interface MXImageAsset : MXAsset

@property (nonatomic, strong) UIImage* image;
@property (nonatomic, assign) float scale;
-(void) rotateRight;
-(void) rotateLeft;

-(UIImage*)imageWithRotation;

@end
