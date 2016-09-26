//
//  SCBufferProvider.h
//  SyncablesPrototype
//
//  Created by Nigel Grange on 24/11/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAudioBuffer.h"

@protocol SCBufferProvider <NSObject>

-(SCAudioBuffer*)provideAudioForSampleRange:(SCSampleRange)range;
-(NSInteger)availableSamples;
-(NSInteger)sampleSize;

@end
