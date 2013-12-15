//
//  DZCustomeView.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-14.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DZCustomViewAnimation)(void);

@interface DZCustomeView : UIView
@property (nonatomic, strong) UIView* parentView;
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong, readonly) UIView* contentContainerView;
@property (nonatomic, strong, readonly) UIView* contentBackgroudView;
@property (nonatomic, strong, readonly) UIImageView* backgroudView;

- (void) showWithAnimation:(BOOL)aimation
                     start:(DZCustomViewAnimation)startAni
            animationBlock:(DZCustomViewAnimation)animationBlock
                  complete:(DZAnimationCompletion)completion;

- (void) hideWithAnimation:(BOOL)aimation
                     start:(DZCustomViewAnimation)startAni
            animationBlock:(DZCustomViewAnimation)animationBlock
                  complete:(DZAnimationCompletion)completion;

- (void) showWithAnimation:(BOOL)animation;
- (void) hideWithAnimation:(BOOL)aimation;


@end
