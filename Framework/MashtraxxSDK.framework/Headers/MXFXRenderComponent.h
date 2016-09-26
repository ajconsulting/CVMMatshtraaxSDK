//
//  MXFXRenderComponent.h
//  Mashtraxx
//
//  Created by Nigel Grange on 09/06/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MXGLResource.h"
#import "MXFXParamProvider.h"

@class MXFXParamTexture;
@class MXRenderFBO;

@protocol MXFXRenderComponent <NSObject>

-(void)setup;
-(BOOL)renderFromFBO:(MXRenderFBO*)sourceFBO toTargetFBO:(MXRenderFBO*)targetFBO withTime:(struct MXFXRenderTime)time;

-(void)setFloatProperty:(NSString*)property value:(float)value;
-(void)setParamTexture:(MXFXParamTexture*)paramTexture;

@end
