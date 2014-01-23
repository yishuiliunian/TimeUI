//
//  DZTimeControl.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-20.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZTimeControl.h"
#import "DZUITools.h"
#import "DZGeometryTools.h"


static float const kDefaultDragItemHeight = 25;

@implementation DZTimeControl

- (void) commonInit
{
    INIT_SELF_SUBVIEW_UIImageView(_dragBackgroundImageView);
    INIT_SUBVIEW_UIImageView(_dragBackgroundImageView, _dragItemImageView);
    INIT_SELF_SUBVIEW_UIImageView(_labelsBackgroundImageView);
    _counterLabel = [[TTCounterLabel alloc] init];
    [_labelsBackgroundImageView addSubview:_counterLabel];
    INIT_SUBVIEW_UILabel(_labelsBackgroundImageView, _typeLabel);
    _typeLabel.adjustsFontSizeToFitWidth = YES;
    _typeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    INIT_SUBVIEW_UILabel(_labelsBackgroundImageView, _bottomLabel);
    _counterLabel.startValue = 1000;
    [_counterLabel start];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (void) layoutSubviews
{
    LAYOUT_SUBVIEW_TOP_FILL_WIDTH(_dragBackgroundImageView, 0 , 0 , kDefaultDragItemHeight);
    LAYOUT_SUBVIEW_CENTER(_dragItemImageView, _dragBackgroundImageView, 142.5, 5);
    LAYOUT_VIEW_FILL_WIDTH_RELY_MAX_Y(_labelsBackgroundImageView, 10, _dragBackgroundImageView, 5, CGRectViewHeight - 5 - CGRectGetMaxY(_dragBackgroundImageView.frame));
    LAYOUT_VIEW_TOP_FILL_WIDTH(_typeLabel, _labelsBackgroundImageView, 5, 5, 15);
    LAYOUT_SUBVIEW_FILL_WIDTH_RELY_MAX_Y(_counterLabel, _labelsBackgroundImageView,0, _typeLabel, 0, CGRectGetHeight(_labelsBackgroundImageView.frame) - CGRectGetMaxY(_typeLabel.frame) - 20);
    LAYOUT_SUBVIEW_FILL_WIDTH_RELY_MAX_Y(_bottomLabel,_labelsBackgroundImageView, 0, _counterLabel, 0, CGRectGetHeight(_labelsBackgroundImageView.frame) - CGRectGetMaxY(_counterLabel.frame));
}

@end
