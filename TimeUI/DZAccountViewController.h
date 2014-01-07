//
//  DZAccountViewController.h
//  TimeUI
//
//  Created by Stone Dong on 14-1-6.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZAccountViewController : UIViewController <DZAppearanceInterface>
@property (nonatomic, strong, readonly) UITextField* emailTextField;
@property (nonatomic, strong, readonly) UITextField* passwordTextField;
@property (nonatomic, strong, readonly) UIButton* loginBtn;
@end
