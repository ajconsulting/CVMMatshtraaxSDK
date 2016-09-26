//
//  SyncablesBlockFn.h
//  SyncablesKit
//
//  Created by Nigel Grange on 20/02/2015.
//  Copyright (c) 2015 HeresyAI Ltd. All rights reserved.
//

#ifndef SyncablesKit_SyncablesBlockFn_h
#define SyncablesKit_SyncablesBlockFn_h

typedef void (^VoidFnBlock)(void);
typedef void (^BoolFnBlock)(BOOL);
typedef void (^IntFnBlock)(int);
typedef void (^StringFnBlock)(NSString*);
typedef void (^DictionaryFnBlock)(NSDictionary*);
typedef void (^ArrayFnBlock)(NSArray*);
typedef void (^DataFnBlock)(NSData*);
typedef void (^ErrFnBlock)(NSError*);

#define onMainThread(block) dispatch_async(dispatch_get_main_queue(), block)
#define onBackgroundThread(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), block)


#define BLOCK_PROPERTY @property (readwrite, copy)

#define __WEAKSELF __weak __typeof__(self) weakSelf = self
#define __WEAK(x, weakX) __weak __typeof__(x) weakX = x


#endif
