//
//  DZSplitChartView.h
//  TimeUI
//
//  Created by stonedong on 14-6-18.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZOvalMaskImageView.h"
@class DZChartNode;
@interface DZSplitChartView : UIScrollView
DEFINE_PROPERTY_STRONG(UITextField*, titleTextField);
DEFINE_PROPERTY_ASSIGN_Float(innerCiclePercent);
DEFINE_PROPERTY_STRONG(DZOvalMaskImageView*, avatarImageView);
DEFINE_PROPERTY_STRONG_UILabel(avatarHolderLabel);
- (void) addChartNode:(DZChartNode *)node;
@end
