//
//  DZLocalNotificationCenter.h
//  TimeUI
//
//  Created by stonedong on 14-6-19.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZLocalNotificationCenter : NSObject
+ (DZLocalNotificationCenter*) defaultCenter;
- (void) repostAllNotifications;
@end
