//
//  MXDefaultAnimationPath.h
//  Mashtraxx
//
//  Created by Nigel Grange on 20/07/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXAnimationPath.h"

typedef enum : NSUInteger {
    MXPathHintNone,
    MXPathHintCentre,
    MXPathHintBeginning,
    MXPathHintEnding
} MXPathHint;

typedef enum : NSUInteger {
    MXPathBoundsNone,
    MXPathBoundsKeepInsideByShiftingCentre,
    MXPathBoundsKeepInsideByScaling
} MXPathBounds;


@interface MXDefaultAnimationPath : NSObject <MXAnimationPath>

@property (nonatomic, assign) CGPoint centre;
@property (nonatomic, assign) MXPathHint centreHint;
@property (nonatomic, assign) MXPathBounds pathBounds;

@property (nonatomic, assign) CGSize lastSourceSize;
@property (nonatomic, assign) CGSize lastOutputSize;

-(void)setupWithSourceSize:(CGSize)sourceSize withOutputSize:(CGSize)outputSize;
-(CGRect)boundCropRect:(CGRect)rect;

-(CGRect)cropToFillSourceSize:(CGSize)sourceSize withOutputSize:(CGSize)outputSize withCentre:(CGPoint)centre;

-(CGPoint)beginningPointCropRectForSourceSize:(CGSize)sourceSize withOutputSize:(CGSize)outputSize;
-(CGPoint)endingPointCropRectForSourceSize:(CGSize)sourceSize withOutputSize:(CGSize)outputSize;

@end
