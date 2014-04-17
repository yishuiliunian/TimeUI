//
//  DZWebPluginEngine.h
//  TimeUI
//
//  Created by stonedong on 14-4-4.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DZDefaultWebPluginEngine [DZWebPluginEngine defaultEngine]
@class DZWebViewController;
@interface DZWebPluginEngine : NSObject
+ (DZWebPluginEngine*) defaultEngine;
- (BOOL) handleURLRequst:(NSURL*)url fromWebViewController:(DZWebViewController*)webVC;
@end
