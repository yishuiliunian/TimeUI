//
//  DZTimeControl.h
//  TimeUI
//
//  Created by Stone Dong on 14-1-20.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZTimeCountLabel.h"
@interface DZTimeControl : UIView
DEFINE_PROPERTY_ASSIGN_Float(dragBackgroudHeight);
DEFINE_PROPERTY_STRONG_UIImageView(dragBackgroundImageView);
DEFINE_PROPERTY_STRONG_UIImageView(dragItemImageView);
DEFINE_PROPERTY_STRONG_UILabel(typeLabel);
DEFINE_PROPERTY_STRONG_UILabel(bottomLabel);
DEFINE_PROPERTY_STRONG_UIImageView(labelsBackgroundImageView);
DEFINE_PROPERTY_STRONG_UIButton(leftButton);
DEFINE_PROPERTY_STRONG_UIButton(rightButton);

@property (nonatomic, strong, readonly) DZTimeCountLabel* counterLabel;
@end
