//
//  DZHUDCenter.h
//  TimeUI
//
//  Created by stonedong on 14-6-23.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

#define DZHUDShareCenter [DZHUDCenter ShareCenter]
#define DZHUDShow [DZHUDShareCenter show];
#define DZHUDHide [DZHUDShareCenter hide];
@interface DZHUDCenter : NSObject
@property (nonatomic, strong, readonly) MBProgressHUD* hud;
+ (DZHUDCenter*) ShareCenter;
- (void) show;
- (void) hide;
@end
