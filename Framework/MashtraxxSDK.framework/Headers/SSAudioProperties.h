//
//  SSAudioProperties.h
//  SyncablesStudio
//
//  Created by Nigel Grange on 09/02/2015.
//  Copyright (c) 2015 HeresyAI Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSAudioProperties : NSObject

@property (nonatomic, assign) NSInteger sampleRate;
@property (nonatomic, assign) UInt32 channels;

@end
