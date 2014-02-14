//
//  DZEditTimeLine.h
//  TimeUI
//
//  Created by Stone Dong on 14-2-14.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZEditTimeLine : UIView
DEFINE_PROPERTY_STRONG_NSString(timeString);
DEFINE_PROPERTY_STRONG_NSString(typeString);
DEFINE_PROPERTY_STRONG(UIFont*, timeFont);
DEFINE_PROPERTY_STRONG(UIColor*, lineColor);
DEFINE_PROPERTY_STRONG(UIColor*, timeColor);
@end
