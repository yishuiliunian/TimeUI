//
//  DZFunctionsManager.h
//  TimeUI
//
//  Created by stonedong on 14-6-18.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZFuncPlugin.h"
#define DZFunctionsDefaultManager [DZFunctionsManager defaultManager]

@interface DZFunctionsManager : NSObject
@property (nonatomic, assign, readonly) NSArray* functions;
+ (DZFunctionsManager*) defaultManager;
@end
