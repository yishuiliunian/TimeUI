//
//  DZCommandQueue.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-20.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZCommand.h"

#define DZCommandConditionNoCommand  0
#define DZCommandConditionHasCommand 1

@interface DZCommandQueue : NSObject
@property (nonatomic, assign          ) NSInteger   countOfThread;
@property (nonatomic, strong, readonly) NSCondition * conditionLock;
- (void) addCommand:(DZCommand*)command;
- (DZCommand*) anyCommand;

- (void) addBlockCommond:(DZCommandBlock)block identify:(NSString*)identify;
@end
