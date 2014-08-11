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
#import "DZTimeTrickManger.h"
#import "DZSelecteTypeInterface.h"
#import "DZNotificationCenter.h"
#import "DZTimeType.h"
#import "DZRestoreTrickDataNI.h"
static float const kDefaultDragItemHeight = 40;

@interface DZTimeControl () <DZSelecteTypeInterface, DZRestoreTrickDateNI>
{
    @package
    UITapGestureRecognizer* _tapGerg;
}
@end

@implementation DZTimeControl
- (void) handleTapGestrueRecg:(UITapGestureRecognizer*)recg
{
    if (recg.state == UIGestureRecognizerStateRecognized) {
        CGPoint point = [recg locationInView:self];
        if (CGRectContainsPoint(self.labelsBackgroundImageView.frame, point)) {
            [[DZTimeTrickManger shareManager] addTimeWithDetail:@"nothind"];
            _counterLabel.beginTimeOffset = ABS([[DZTimeTrickManger shareManager].lastTrickDate timeIntervalSinceNow]);
            [_counterLabel start];
        }
    }
}



- (void) dealloc
{
    [DZDefaultNotificationCenter removeObserver:self forMessage:kDZNotification_selectedType];
    [DZDefaultNotificationCenter removeObserver:self forMessage:kDZNotification_restoreDate];
}

- (void) didSelectedTimeType:(DZTimeType *)timetype
{
    _typeLabel.text = timetype.name;
}
- (void) didGetRestoreTrickDateMessage
{
    _counterLabel.beginTimeOffset = ABS([[DZTimeTrickManger shareManager].lastTrickDate timeIntervalSinceNow]);
    [_counterLabel start];
}
- (void) commonInit
{
    INIT_SELF_SUBVIEW_UIImageView(_contentBackgroundView);
    _contentBackgroundView.backgroundColor = [UIColor whiteColor];
    //
    INIT_SELF_SUBVIEW_UIImageView(_dragBackgroundImageView);
    INIT_SUBVIEW_UIImageView(_dragBackgroundImageView, _dragItemImageView);
    INIT_SELF_SUBVIEW_UIImageView(_labelsBackgroundImageView);
    INIT_SUBVIEW_UIButton(_dragBackgroundImageView, _leftButton);
    INIT_SUBVIEW_UIButton(_dragBackgroundImageView, _rightButton);
    
    _counterLabel = [[DZTimeCountLabel alloc] init];
    [_labelsBackgroundImageView addSubview:_counterLabel];
    INIT_SUBVIEW_UILabel(_labelsBackgroundImageView, _typeLabel);
    _typeLabel.adjustsFontSizeToFitWidth = YES;
    _typeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    INIT_SUBVIEW_UILabel(_labelsBackgroundImageView, _bottomLabel);
    
    INIT_SELF_SUBVIEW(DZListHanldeView, _listHandleView);

    _counterLabel.beginTimeOffset = ABS([[DZTimeTrickManger shareManager].lastTrickDate timeIntervalSinceNow]);
    [_counterLabel start];
    
    _tapGerg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestrueRecg:)];
    [self addGestureRecognizer:_tapGerg];
    _tapGerg.numberOfTapsRequired = 1;
    _tapGerg.numberOfTouchesRequired = 1;
    
    
    
    [DZDefaultNotificationCenter addObserver:self forKey:kDZNotification_selectedType];
    [DZDefaultNotificationCenter addObserver:self forKey:kDZNotification_restoreDate];
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
    
    
    LAYOUT_SUBVIEW_TOP_FILL_WIDTH(_listHandleView, 0 , 0 , kDefaultDragItemHeight+2);
    LAYOUT_SUBVIEW_FILL_WIDTH_RELY_MAX_Y(_dragBackgroundImageView, self, 0, _listHandleView, -2, kDefaultDragItemHeight+2);
//    LAYOUT_SUBVIEW_CENTER(_dragItemImageView, _dragBackgroundImageView, 137, 8);
    
    
    LAYOUT_VIEW_FILL_WIDTH_RELY_MAX_Y(_labelsBackgroundImageView,
                                      10,
                                      _dragBackgroundImageView,
                                      5,
                                      CGRectViewHeight - 5 - CGRectGetMaxY(_dragBackgroundImageView.frame));
    
    
    LAYOUT_VIEW_TOP_FILL_WIDTH(_typeLabel, _labelsBackgroundImageView, 5, 5, 15);
    LAYOUT_SUBVIEW_FILL_WIDTH_RELY_MAX_Y(_counterLabel,
                                         _labelsBackgroundImageView,0,
                                         _typeLabel,
                                         0,
                                         CGRectGetHeight(_labelsBackgroundImageView.frame) - CGRectGetMaxY(_typeLabel.frame) - 20);
    LAYOUT_SUBVIEW_FILL_WIDTH_RELY_MAX_Y(_bottomLabel,_labelsBackgroundImageView, 0, _counterLabel, 0, CGRectGetHeight(_labelsBackgroundImageView.frame) - CGRectGetMaxY(_counterLabel.frame));
    
    static float ButttonHeight = 35;
    
#define DragBackgroundImageViewHeight CGRectGetHeight(_dragBackgroundImageView.frame)
    _leftButton.frame = CGRectMake(10,
                                    (DragBackgroundImageViewHeight - ButttonHeight) /2,
                                   ButttonHeight ,
                                   ButttonHeight);
    
    _rightButton.frame = CGRectMake(CGRectGetWidth(rect_dragBackgroundImageView) - 10 -ButttonHeight,
                                     (DragBackgroundImageViewHeight - ButttonHeight) /2,
                                    ButttonHeight,  ButttonHeight);
    
    
    //
    _contentBackgroundView.frame = CGRectMake(0, CGRectGetMaxY(_listHandleView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)- CGRectGetMaxY(_listHandleView.frame));

}

@end
