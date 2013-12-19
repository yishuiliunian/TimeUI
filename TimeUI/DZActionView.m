//
//  DZActionView.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-18.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZActionView.h"

@implementation DZActionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _actionContentView = [[DZActionContentView alloc] init];
        [self setContentView:_actionContentView];
    }
    return self;
}

- (instancetype) initWithItems:(NSArray *)items
{
    self =[super init];
    if (self) {
        [_actionContentView setItems:items];
    }
    return self;
}

- (void) showWithAnimation:(BOOL)animation
{
    self.parentView = [UIApplication sharedApplication].keyWindow;
    CGRect rect  = CGRectMake(0, CGRectGetHeight(self.parentView.frame), CGRectGetWidth(self.parentView.frame), self.actionContentView.height);
    [self showWithAnimation:animation start:^{
        self.contentView.frame = rect;
    } animationBlock:^{
        self.contentView.frame = CGRectOffset(rect, 0, -self.actionContentView.height);

    } complete:^{
        
    }];
}


- (void) hideWithAnimation:(BOOL)aimation
{
    [self hideWithAnimation:aimation start:^{
        
    } animationBlock:^{
        self.contentView.frame = CGRectOffset(self.contentView.frame, 0, self.actionContentView.height);
    } complete:^{
        
    }];
}
@end
