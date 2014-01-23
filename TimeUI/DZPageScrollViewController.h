//
//  DZPageScrollViewController.h
//  QQPicShow
//
//  Created by Stone Dong on 13-10-17.
//  Copyright (c) 2013年 Tencent SNS Terminal Develope Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZPageScrollView.h"
@interface DZPageScrollViewController : UIViewController <DZPageScrollViewDelegate, DZPageScrollViewActionDelegate>
@property (nonatomic, strong, readonly) DZPageScrollView* pageScrollView;
//初始化时，将会跳转到的位置
@property (nonatomic, assign) NSInteger initIndex;


@end
