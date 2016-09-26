//
//  MXFXRenderChain.h
//  Mashtraxx
//
//  Created by Nigel Grange on 09/06/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXFXRenderComponent.h"

@class MXFXParamTexture;

@interface MXFXRenderChain : NSObject <MXGLResource>

@property (nonatomic, strong) MXFXParamTexture* paramTexture;

-(void)addRenderComponent:(id<MXFXRenderComponent>)component;
-(id<MXFXRenderComponent>)addShaderWithName:(NSString*)shader;
-(id<MXFXRenderComponent>)addShaderWithName:(NSString*)shader inBundle:(NSBundle*)bundle;

-(void)reset;

-(void)setupComponents;

-(NSArray*)components;
@end
