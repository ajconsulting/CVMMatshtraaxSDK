//
//  SCBriefSection.h
//  SyncablesPrototype
//
//  Created by Nigel Grange on 07/12/2014.
//  Copyright (c) 2014 Nigel Grange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCBriefSection : NSObject

@property (nonatomic, strong) NSArray* sliceDescriptions;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, assign) double duration;

- (instancetype)initWithSliceDescriptions:(NSArray*)descriptions;

@end


typedef void (^BriefSectionFnBlock)(SCBriefSection*);
