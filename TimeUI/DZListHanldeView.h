//
//  DZListHanldeView.h
//  TimeUI
//
//  Created by stonedong on 14-8-7.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DZListHanldeViewInvalid,
    DZListHanldeStateBottom,
    DZListHanldeStateMoving,
    DZListHanldeStateTop
}DZListHanldeState;

@interface DZListHanldeView : UIImageView
@property (nonatomic, assign) DZListHanldeState state;
@end
