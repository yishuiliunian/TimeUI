//
//  DZEditTimeLine.h
//  TimeUI
//
//  Created by Stone Dong on 14-2-14.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DZEditTimeLine;
@protocol DZEditTimeLineDelegate <NSObject>

- (void) editTimeLine:(DZEditTimeLine*)line didHanldeLongPress:(UILongPressGestureRecognizer*)recg;
- (NSString*) editTimeLine:(DZEditTimeLine*)line timeStringWithRote:(float)rote;
@end

@interface DZEditTimeLine : UIView
@property (nonatomic, weak) id<DZEditTimeLineDelegate> delegate;
DEFINE_PROPERTY_ASSIGN_Float(ratio);
DEFINE_PROPERTY_STRONG_NSString(typeString);
DEFINE_PROPERTY_STRONG(UIFont*, timeFont);
DEFINE_PROPERTY_STRONG(UIColor*, lineColor);
DEFINE_PROPERTY_STRONG(UIColor*, timeColor);
@end
