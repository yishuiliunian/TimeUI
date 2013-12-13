//
//  DZInputCellView.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-13.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZInputCellView.h"

@interface DZInputCellView ()
{
    UIView* _containerView;
    
    UIImageView* _containerBackgroudView;
}
@end

@implementation DZInputCellView
@synthesize backgroudView = _backgroudView;
@synthesize textField = _textField;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _backgroudView = [UIImageView new];
        _backgroudView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backgroudView];
        
        _containerView = [UIView new];
        [self addSubview:_containerView];
        
        _containerBackgroudView = [[UIImageView alloc] init];
        [_containerView addSubview:_containerBackgroudView];
        
        [_containerBackgroudView addTapTarget:self selector:@selector(_hideSelf)];
        
        _textField = [[UITextField alloc] init];
        [_containerView addSubview:_textField];
        _textField.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void) _hideSelf
{
    [self hideWithAnimation:YES completion:^{
        if ([_delegate respondsToSelector:@selector(dzInputCellViewUserCancel:)]) {
            [_delegate dzInputCellViewUserCancel:self];
        }
    }];
}


- (void) layoutSubviews
{
    _textField.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 44);
    _backgroudView.frame = self.bounds;
    _containerView.frame = self.bounds;
    _containerBackgroudView.frame = self.bounds;
}


- (void) showInView:(UIView*)view withAnimation:(BOOL)animation completion:(DZAnimationCompletion)completionBlock
{
    [view addSubview:self];
    self.frame = view.frame;
    void(^StartAnimationBlock)(void) = ^(void) {
        _backgroudView.alpha = 0.0f;
    };
    
    void(^AnimationBlock)(void) = ^(void) {
        _backgroudView.alpha = 0.4;
    };
    
    void(^EndAnimationBlock)(void) = ^(void) {
        if (completionBlock) {
            completionBlock();
        }
        [_textField becomeFirstResponder];
    };
    
    StartAnimationBlock();
    if (animation) {
        [UIView animateWithDuration:DZAnimationDefualtDuration animations:AnimationBlock completion:^(BOOL finished) {
            EndAnimationBlock();
        }];
    }
    else
    {
        AnimationBlock();
        completionBlock();
    }
}


- (void) hideWithAnimation:(BOOL)animation completion:(DZAnimationCompletion)completionBlock
{

    void(^StartAnimationBlock)(void) = ^(void) {
        [_textField resignFirstResponder];
    };
    
    void(^AnimationBlock)(void) = ^(void) {
        _backgroudView.alpha = 0.;
    };
    
    void(^EndAnimationBlock)(void) = ^(void) {
        if (completionBlock) {
            completionBlock();
        }
        [self removeFromSuperview];
    };
    
    StartAnimationBlock();
    if (animation) {
        [UIView animateWithDuration:DZAnimationDefualtDuration animations:AnimationBlock completion:^(BOOL finished) {
            EndAnimationBlock();
        }];
    }
    else
    {
        AnimationBlock();
        completionBlock();
    }
}



@end
