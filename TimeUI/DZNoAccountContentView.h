//
//  DZNoAccountContentView.h
//  TimeUI
//
//  Created by Stone Dong on 14-1-24.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZNoAccountContentView : UIView
DEFINE_PROPERTY_STRONG_UILabel(textLabel);
DEFINE_PROPERTY_STRONG(UIButton*, registerButton);
DEFINE_PROPERTY_STRONG(UIButton*, loginButton);
@end
