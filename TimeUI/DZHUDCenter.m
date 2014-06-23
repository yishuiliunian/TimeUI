//
//  DZHUDCenter.m
//  TimeUI
//
//  Created by stonedong on 14-6-23.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZHUDCenter.h"
#import "DZSingletonFactory.h"
@implementation DZHUDCenter
@synthesize hud = _hud;

+ (DZHUDCenter*) ShareCenter
{
    return DZSingleForClass([DZHUDCenter class]);
}
- (void) show{
    if (_hud) {
        [_hud hide:NO];
    }
     _hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [_hud show:YES];
}
- (void) hide {
    [_hud hide:YES];
}
@end
