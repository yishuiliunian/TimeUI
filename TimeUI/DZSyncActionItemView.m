//
//  DZSyncActionItemView.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-19.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZSyncActionItemView.h"
#import "DZContextManager.h"
#import "DZSyncOperation.h"
#import "DZAccountManager.h"
#import "DZNotificationCenter.h"
#import <NSDate-TKExtensions.h>

#import "DZNoAccountContentView.h"
#import "DZHasAccountContentView.h"




@interface DZSyncActionItemView () <DZSyncContextChangedInterface>
DEFINE_PROPERTY_STRONG(UIView*, contentView);
@end

@implementation DZSyncActionItemView


- (void) dealloc
{
//    [[DZNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if(NO)
        {
            [self setContentView:[DZHasAccountContentView new] animation:NO];
        }
        else
        {
            [self setContentView:[DZNoAccountContentView new] animation:NO];
        }
    }
    return self;
}


- (void) setContentView:(UIView *)contentView animation:(BOOL)animation
{
    if (_contentView != contentView) {
        if (contentView) {
            UIView* old = _contentView;
            contentView.frame = CGRectOffset(self.bounds, CGRectViewWidth, 0);
            [self addSubview:contentView];
            void(^aimationBlock)(void) = ^(void) {
                _contentView.frame = CGRectMake(-CGRectGetWidth(self.frame), 0, CGRectViewWidth, CGRectViewHeight);
                contentView.frame = self.bounds;
            };
            if (animation) {
                [UIView animateWithDuration:0.25 animations:aimationBlock completion:^(BOOL finished) {
                    [old removeFromSuperview];
                }];
            }
            else
            {
                aimationBlock();
                [old removeFromSuperview];
            }
            _contentView = contentView;
        }
    }
}

- (void) layoutSubviews
{
    _contentView.frame = self.bounds;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
