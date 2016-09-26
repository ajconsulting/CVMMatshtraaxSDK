//
//  SyncablesKitTouch.h
//  SyncablesKitTouch
//
//  Created by Nigel Grange on 08/05/2015.
//  Copyright (c) 2015 HeresyAI Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for SyncablesKitTouch.
FOUNDATION_EXPORT double SyncablesKitTouchVersionNumber;

//! Project version string for SyncablesKitTouch.
FOUNDATION_EXPORT const unsigned char SyncablesKitTouchVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SyncablesKitTouch/PublicHeader.h>

// AI
#import <SyncablesKitTouch/SCAIBriefingProperties.h>
#import <SyncablesKitTouch/SCAIHitPoint.h>
#import <SyncablesKitTouch/SCAISolution.h>
#import <SyncablesKitTouch/SCAIBriefingEnginev3.h>
#import <SyncablesKitTouch/SCAIBriefingMetadataBuilder.h>

// Brief
#import <SyncablesKitTouch/SCBriefingDirector.h>
#import <SyncablesKitTouch/SCBriefSection.h>
#import <SyncablesKitTouch/SCBriefingSearchTree.h>

// Director
#import <SyncablesKitTouch/SCSliceDirector.h>
#import <SyncablesKitTouch/SCSliceCatalog.h>
#import <SyncablesKitTouch/SCSliceProvider.h>
#import <SyncablesKitTouch/SCSliceDescriptor.h>
#import <SyncablesKitTouch/SCSliceSequence.h>
#import <SyncablesKitTouch/SCSliceGroup.h>
#import <SyncablesKitTouch/SCTimedSliceGroup.h>

// Slices
#import <SyncablesKitTouch/SCSliceScheduler.h>
#import <SyncablesKitTouch/SCSlicePosition.h>
#import <SyncablesKitTouch/SCSliceComponent.h>

// Buffer
#import <SyncablesKitTouch/SCSliceSchedulerDelegate.h>

// Syncables
#import <SyncablesKitTouch/SCSlice.h>
#import <SyncablesKitTouch/SCPosition.h>
#import <SyncablesKitTouch/SCLength.h>
#import <SyncablesKitTouch/SCExitPoint.h>
#import <SyncablesKitTouch/SCAnacrusis.h>

// Audio
#import <SyncablesKitTouch/SCAudioBuffer.h>
#import <SyncablesKitTouch/SCBufferProvider.h>