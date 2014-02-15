//
//  DZEditTimeSegmentView.h
//  TimeUI
//
//  Created by Stone Dong on 14-2-14.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DZEditTimeSegmentDelegate.h"

@interface DZEditTimeSegmentView : UIView
DEFINE_PROPERTY_WEAK(id<DZEditTimeSegmentDelegate>, delegate);
- (instancetype) initWithTime:(DZTime*)time;
- (void) addDivisionLine:(float)rote withType:(DZTimeType*)type;

- (NSArray*) getAllEditedTimes;
@end
