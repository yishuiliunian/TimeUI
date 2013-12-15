//
//  DZCustomeView.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-14.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZCustomeView.h"

@implementation DZCustomeView


- (void) setContentView:(UIView *)contentView
{
    if (_contentView != contentView) {
        [_contentView removeFromSuperview];
        _contentView = contentView;
        [_contentContainerView addSubview:contentView];
        [self setNeedsLayout];
    }
}

- (void) handleSingleTap:(UITapGestureRecognizer*)tpcg
{
    [self hideWithAnimation:YES];
}

- (void) hideWithAnimation:(BOOL)aimation
{
    [self hideWithAnimation:aimation start:^{
        
    } animationBlock:^{
        
    } complete:^{
        
    }];
}


- (void) showWithAnimation:(BOOL)animation
{
    [self showWithAnimation:animation start:^{
        
    } animationBlock:^{
        
    } complete:^{
        
    }];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _backgroudView = [UIImageView new];
        _backgroudView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backgroudView];
        
        _contentContainerView = [[UIView alloc] init];
        [self addSubview:_contentContainerView];
        
        _contentBackgroudView = [UIView new];
        [_contentContainerView addSubview:_contentBackgroudView];
    
        [_contentBackgroudView addTapTarget:self selector:@selector(handleSingleTap:)];
    }
    return self;
}


- (void) layoutSubviews
{
    _backgroudView.frame = self.bounds;
    _contentContainerView.frame = self.bounds;
    _contentBackgroudView.frame = self.bounds;
}

- (void) showWithAnimation:(BOOL)aimation start:(DZCustomViewAnimation)startAni animationBlock:(DZCustomViewAnimation)animationBlock complete:(DZAnimationCompletion)completion
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    _backgroudView.alpha = 0.0f;
    UIView* pView = [self parentView];
    self.frame = pView.frame;
    [pView addSubview:self];
    if (startAni) {
        startAni();
    }
    DZCustomViewAnimation animationing = ^{
        if (animationBlock) {
            animationBlock();
        }
        _backgroudView.alpha = 0.4f;
    };
    DZCustomViewAnimation completed = ^{
        if (completion) {
            completion();
        }
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    };
    if (animationBlock) {
        [UIView animateWithDuration:DZAnimationDefualtDuration animations:animationing completion:^(BOOL finished) {
            completed();
        }];
    }
    else
    {
        animationing();
        completed();

    }
}

- (void) hideWithAnimation:(BOOL)aimation start:(DZCustomViewAnimation)startAni animationBlock:(DZCustomViewAnimation)animationBlock complete:(DZAnimationCompletion)completion
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    if (startAni) {
        startAni();
    }
    
    DZCustomViewAnimation animationing = ^{
        if (animationBlock) {
            animationBlock();
        }
        _backgroudView.alpha = 0.0f;
    };
    
    DZCustomViewAnimation completed = ^{
        if (completion) {
            completion();
        }
        [self removeFromSuperview];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    };
    if (aimation) {
        [UIView animateWithDuration:DZAnimationDefualtDuration animations:animationing completion:^(BOOL finished) {
            completed();
        }];
    }
    else
    {
        animationing();
        completed();
    }
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
