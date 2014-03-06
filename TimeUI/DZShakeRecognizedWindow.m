//
//  DZShakeRecognizedWindow.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-19.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZShakeRecognizedWindow.h"
#import "DZNotificationCenter.h"
@implementation DZShakeRecognizedWindow

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event {
	if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        [[DZNotificationCenter defaultCenter] postMessage:DZShareNotificationMessage userInfo:nil];
	}
}


@end
