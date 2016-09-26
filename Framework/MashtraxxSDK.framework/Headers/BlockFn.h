//
//  BlockFn.h
//  SyncablesStudio
//
//  Created by Nigel Grange on 19/02/2015.
//  Copyright (c) 2015 HeresyAI Ltd. All rights reserved.
//

#ifndef SyncablesStudio_BlockFn_h
#define SyncablesStudio_BlockFn_h

#define BLOCK_PROPERTY @property (readwrite, copy)

typedef void (^VoidFnBlock)(void);
typedef void (^BoolFnBlock)(BOOL);
typedef void (^IntFnBlock)(int);
typedef void (^FloatFnBlock)(float);
typedef void (^StringFnBlock)(NSString*);
typedef BOOL (^StringReturningBoolFnBlock)(NSString*);
typedef void (^DictionaryFnBlock)(NSDictionary*);
typedef void (^ArrayFnBlock)(NSArray*);
typedef void (^DataFnBlock)(NSData*);
typedef void (^ErrFnBlock)(NSError*);
typedef void (^StringDictFnBlock)(NSString*,NSDictionary*);

#define __WEAKSELF __weak __typeof__(self) weakSelf = self
#define __WEAK(x, weakX) __weak __typeof__(x) weakX = x

#define onMainThread(block) dispatch_async(dispatch_get_main_queue(), block)
#define onBackgroundThread(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), block)
#define doAfter(block,secs)  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(secs * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), block)
#define doAfterMain(block,secs)  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(secs * NSEC_PER_SEC)), dispatch_get_main_queue(), block)


#endif
