//
//  DZBackgroudLabel.h
//  TimeUI
//
//  Created by stonedong on 14-6-20.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZBackgroudLabel : UIView
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, strong, readonly) UILabel* label;
@property (nonatomic, strong, readonly) UIImageView* backgroundImageView;
@end
