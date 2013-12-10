//
//  DZDragViewController.h
//  TimeUI
//
//  Created by Stone Dong on 13-11-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZDragViewController : UIViewController
@property (nonatomic, strong) UIViewController* topViewController;
@property (nonatomic, strong) UIViewController* centerViewController;
@property (nonatomic, strong) UIViewController* bottomViewController;

@property (nonatomic, assign) float middleHeight;
@end
