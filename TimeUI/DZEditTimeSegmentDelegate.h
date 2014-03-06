//
//  DZEditTimeSegmentDelegate.h
//  TimeUI
//
//  Created by Stone Dong on 14-2-15.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DZEditTimeSegmentView;
@class DZTimeType;
@protocol DZEditTimeSegmentDelegate <NSObject>
- (void) editTimeSegmentView:(DZEditTimeSegmentView*)timeView willAddLinewithRote:(float)rote;
@end
