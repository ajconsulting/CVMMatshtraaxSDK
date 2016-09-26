//
//  MXAnimationPath.h
//  Mashtraxx
//
//  Created by Nigel Grange on 20/07/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreGraphics;

@protocol MXAnimationPath <NSObject>

-(CGRect)cropRectForSourceSize:(CGSize)sourceSize withOutputSize:(CGSize)outputSize tween:(CGFloat)tween;
-(CGSize)scaledSourceSize:(CGSize)sourceSize withOutputSize:(CGSize)outputSize;
-(CGFloat)scaleForSourceSize:(CGSize)sourceSize withOutputSize:(CGSize)outputSize;

@end
