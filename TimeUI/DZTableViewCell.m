//
//  DZTableViewCell.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTableViewCell.h"
#import "DZTableViewCell_private.h"
#import <KXKiOS7Colors.h>

@interface DZTableViewCell () <UIGestureRecognizerDelegate>
{
    UIPanGestureRecognizer* _panGestureRcognizer;
    CGPoint _startPoint;
}
@end

@implementation DZTableViewCell
@synthesize identifiy = _identifiy;
@synthesize index = _index;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView* contentV = [UIView new];
        contentV.backgroundColor = [KXKiOS7Colors yellow];
        [self setContentView:contentV];
        
        UIView* a = [UIView new];
        a.backgroundColor = [UIColor blueColor];
        [self setSelectedBackgroudView:a];
        
        //
        _panGestureRcognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
        _panGestureRcognizer.maximumNumberOfTouches = 1;
        _panGestureRcognizer.minimumNumberOfTouches = 1;
        _panGestureRcognizer.delegate = self;
        
        [self addGestureRecognizer:_panGestureRcognizer];
        
        //
        DZCellActionsView* actionView = [[DZCellActionsView alloc] init];
        [self setActionsView:actionView];
    }
    return self;
}

- (void) printtag:(UIButton*)btn
{
    DDLogDebug(@"btn %@ tag %d",btn, btn.tag);
}

- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return YES;
    }
    return YES;
}

//- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//        return YES;
//    }
//    else
//    {
//        return YES;
//    }
//}
//- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//        return NO;
//    }
//    else
//    {
//        return YES;
//    }
//}
- (void) handlePanGestureRecognizer:(UIPanGestureRecognizer*)prcg
{
    CGPoint point = [prcg locationInView:self];
    if (prcg.state == UIGestureRecognizerStateBegan) {
        _startPoint  = point;
    }
    else if (prcg.state == UIGestureRecognizerStateChanged)
    {
        float offset  = point.x - _startPoint.x;
        _contentView.frame = CGRectOffset(self.bounds, offset, 0);
        [_actionsView setEableItemWithMaskOffSet:offset];
    }
    else if (prcg.state == UIGestureRecognizerStateCancelled)
    {
        _contentView.frame = self.bounds;
    }
    else if (prcg.state == UIGestureRecognizerStateEnded)
    {
        if (_actionsView.abledItem) {
            [_actionsView.abledItem sendActionsForControlEvents:UIControlEventAllEvents];
        }
        _contentView.frame = self.bounds;
    }
}

- (void) prepareForReused
{
    _index = NSNotFound;
    [self setIsSelected:NO];
}
- (instancetype) initWithIdentifiy:(NSString*)identifiy
{
    self = [super init];
    if (self) {
        _identifiy = identifiy;
    }
    return self;
}
- (void) setContentView:(UIView *)contentView
{
    if (_contentView != contentView) {
        [_contentView removeFromSuperview];
        _contentView = contentView;
        [self addSubview:contentView];
        [self setNeedsLayout];
    }
}

- (void) setSelectedBackgroudView:(UIView *)selectedBackgroudView
{
    if (_selectedBackgroudView != selectedBackgroudView) {
        [_selectedBackgroudView removeFromSuperview];
        _selectedBackgroudView = selectedBackgroudView;
        [self addSubview:_selectedBackgroudView];
        [self setNeedsLayout];
    }
}

- (void) setActionsView:(DZCellActionsView *)actionsView
{
    if (_actionsView != actionsView) {
        [_actionsView removeFromSuperview];
        [self insertSubview:actionsView atIndex:0];
        _actionsView = actionsView;
        [self setNeedsLayout];
    }
}


- (void) layoutSubviews
{
    _contentView.frame = self.bounds;
    _actionsView.frame = self.bounds;
    if (_isSelected) {
        _selectedBackgroudView.frame = _contentView.bounds;
        _selectedBackgroudView.hidden =  NO;
        [_contentView insertSubview:_selectedBackgroudView atIndex:0];
    }
    else
    {
        _selectedBackgroudView.hidden = YES;
    }
}

- (void) setIsSelected:(BOOL)isSelected
{
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
        [self setNeedsLayout];
    }
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self setIsSelected:YES];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self setIsSelected:NO];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self setIsSelected:NO];
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