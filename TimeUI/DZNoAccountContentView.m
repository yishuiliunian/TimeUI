//
//  DZNoAccountContentView.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-24.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZNoAccountContentView.h"
#import "DZContextManager.h"
#import "DZSyncOperation.h"
#import "DZAccountManager.h"
#import "DZNotificationCenter.h"
#import <NSDate-TKExtensions.h>
@interface DZNoAccountContentView ()

@end

@implementation DZNoAccountContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        INIT_SELF_SUBVIEW(UIButton, _registerButton);
        INIT_SELF_SUBVIEW(UIButton, _loginButton);
        INIT_SELF_SUBVIEW_UILabel(_textLabel);
        [_registerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_registerButton setTitle:@"NO" forState:UIControlStateNormal];
        [_loginButton setTitle:@"YES" forState:UIControlStateNormal];
        _textLabel.text = @"您拥有CatchItime账号吗？";
        _textLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return self;
}

- (void) layoutSubviews
{
    _textLabel.frame = CGRectMake(10, 0, CGRectViewWidth - 120, CGRectViewHeight);
    _loginButton.frame = CGRectMake(CGRectGetMaxX(_textLabel.frame), 0, 50, CGRectViewHeight);
    _registerButton.frame = CGRectMake(CGRectGetMaxX(_loginButton.frame), 0, 50, CGRectViewHeight);
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
