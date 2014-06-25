//
//  DZSyncManager.h
//  TimeUI
//
//  Created by stonedong on 14-6-24.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DZSyncShareManager [DZSyncManager shareManager]
@interface DZSyncManager : NSObject
+ (DZSyncManager*) shareManager;
@end
