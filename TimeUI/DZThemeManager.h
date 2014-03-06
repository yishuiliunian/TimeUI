//
//  DZThemeManager.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-20.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZAppearanceInterface.h"
#define DZDefaultThemManager [DZThemeManager shareManager]

#define DZThemeLoadCSS [DZDefaultThemManager updateCSSOfObject:self]



@protocol DZAppearanceInterface;
@interface DZThemeManager : NSObject
+ (DZThemeManager*) shareManager;
- (void) updateCSSOfObject:(id<DZAppearanceInterface>) object;
@end


@interface UIViewController (Appearance) <DZAppearanceInterface>

@end
