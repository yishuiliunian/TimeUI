//
//  DZCommand.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-20.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DZCommandBlock)(void);

@interface DZCommand : NSObject
@property (nonatomic, strong) NSString       * identify;
@property (nonatomic, strong) DZCommandBlock commandBlock;
- (instancetype) initWithBlock:(DZCommandBlock)block;
@end
