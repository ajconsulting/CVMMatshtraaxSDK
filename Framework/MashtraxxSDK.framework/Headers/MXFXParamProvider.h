//
//  MXFXParamProvider.h
//  Mashtraxx
//
//  Created by Nigel Grange on 13/06/2016.
//  Copyright © 2016 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXFXRenderComponent.h"

#define KMaxParamChannels 8

typedef enum : NSUInteger {
    KParamChannel_On,       // Always 'On' channel
    KParamChannel_Audio,    // System channel used for audio analysis channel
    KParamChannel_Timeline,
    KParamChannel0,
    KParamChannel1,
    KParamChannel2,
    KParamChannel3,
    KParamChannel4,
} KParamChannel;

struct MXFXParamValue {
    // Values clamped to between 0.0 - 1.0, 8-bit depth (i.e. maps to 0-255 RGBA Uint8)
    float value0;
    float value1;
    float value2;
    float value3;
};

struct MXFXRenderTime {
    NSTimeInterval globalTime;
    double tween;
};


@protocol MXFXParamProvider <NSObject>

-(BOOL)supportsChannel:(KParamChannel)channel;
-(struct MXFXParamValue)valueAtRenderTime:(struct MXFXRenderTime)renderTime forChannel:(KParamChannel)channel;

@end
