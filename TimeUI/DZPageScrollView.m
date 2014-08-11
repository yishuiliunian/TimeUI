//
//  DZPageScrollView.m
//  QQPicShow
//
//  Created by Stone Dong on 13-10-17.
//  Copyright (c) 2013年 Tencent SNS Terminal Develope Center. All rights reserved.
//

#import "DZPageScrollView.h"
#import "DZGeometryTools.h"
#import "DZPageScrollViewCell_Private.h"
struct DZPageScrollViewDelegateReseponse {
    BOOL funcNumberOfPages;
    BOOL funcGetPageCell;
    BOOL funcDidTapCell;
};

@interface DZPageScrollView () <UIGestureRecognizerDelegate>
{
    
    NSMutableSet* _resuableCells;
    NSUInteger _numberOfPages;
    struct DZPageScrollViewDelegateReseponse _delegateResponse;
    UIEdgeInsets _pageCellEdgeInsets;
    //
    UIView* _bottomToolView;
    //
    UIEdgeInsets _bottomToolViewEdgeInsets;
    //
    CGRect _lastVisibleRect;
    //
    UIView* _topToolView;
    UIEdgeInsets _topToolViewEdgeInsets;
    //
    UITapGestureRecognizer* _tapRcg;
}

@end


@implementation DZPageScrollView
@synthesize pageDelegate = _pageDelegate;
@synthesize currentPageIndex = _currentPageIndex;
@synthesize leftArrowIndicatorView = _leftArrowIndicatorView;
@synthesize rightArrowIndicatorView = _rightArrowIndicatorView;
@synthesize pageActionDelegate = _pageActionDelegate;
@synthesize showGestrueIndicatoryView = _showGestrueIndicatoryView;
@synthesize backgroudView = _backgroudView;
@synthesize initIndex = _initIndex;
- (void) commitInit
{
    _initIndex = NSNotFound;
    _backgroudView = [[UIImageView alloc] init];
    [self addSubview:_backgroudView];
    _resuableCells = [NSMutableSet new];
    _numberOfPages = 0;
    _currentPageIndex = 0;
    //
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    //
    _showGestrueIndicatoryView = YES;
    _leftArrowIndicatorView = [[UIImageView alloc] init];
    _leftArrowIndicatorView.backgroundColor = [UIColor blackColor];
    [self addSubview:_leftArrowIndicatorView];
    UITapGestureRecognizer* leftTapRcg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleToLeftRecognizer:)];
    leftTapRcg.numberOfTapsRequired = 1;
    leftTapRcg.numberOfTouchesRequired = 1;
    _leftArrowIndicatorView.userInteractionEnabled = YES;
    [_leftArrowIndicatorView addGestureRecognizer:leftTapRcg];
    //
    _rightArrowIndicatorView = [[UIImageView alloc] init];
    _rightArrowIndicatorView.backgroundColor = [UIColor blueColor];
    [self addSubview:_rightArrowIndicatorView];
    UITapGestureRecognizer* rightTapRcg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleToRightRecognizer:)];
    rightTapRcg.numberOfTapsRequired = 1;
    rightTapRcg.numberOfTouchesRequired = 1;
 
    _rightArrowIndicatorView.userInteractionEnabled = YES;
    [_rightArrowIndicatorView addGestureRecognizer:rightTapRcg];
    
    //
    _tapRcg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestrueRecognizer:)];
    _tapRcg.numberOfTapsRequired = 1;
    _tapRcg.numberOfTouchesRequired = 1;
    _tapRcg.delegate = self;
    [_tapRcg requireGestureRecognizerToFail:rightTapRcg];
    [_tapRcg requireGestureRecognizerToFail:leftTapRcg];
    [self addGestureRecognizer:_tapRcg];
    
    INIT_SELF_SUBVIEW(UIImageView, _contentBackgroudView);
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isEqual:_tapRcg]) {
        CGPoint point = [_tapRcg locationInView:self];
        if (CGRectContainsPoint([self _rectOfPageAtIndex:_currentPageIndex], point)) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return YES;
}

- (void) handleTapGestrueRecognizer:(UITapGestureRecognizer*)tapRcg
{
    if (tapRcg.state == UIGestureRecognizerStateRecognized) {
        if (!self.isDragging && !self.isZooming ) {
            NSArray* array = [self _allCells];
            CGRect visibleRect = [self _visibleRect];
            for (DZPageScrollViewCell* cell in array) {
                if (CGRectContainsRect(visibleRect, cell.frame)) {
                    if (_delegateResponse.funcDidTapCell) {
                        [_pageActionDelegate pageScrollView:self didTapCellAtIndex:cell.index];
                        break;
                    }
                }
            }
        }
    }
}

- (void) handleToLeftRecognizer:(UITapGestureRecognizer*)tapRcg
{
    if (tapRcg.state == UIGestureRecognizerStateRecognized) {
        [self setCurrentPageIndex:_currentPageIndex - 1 animate:YES];
    }
}
- (void) handleToRightRecognizer:(UITapGestureRecognizer*)tapRcg
{
    if (tapRcg.state == UIGestureRecognizerStateRecognized) {
        [self setCurrentPageIndex:_currentPageIndex + 1 animate:YES];
    }
}
- (void) setCurrentPageIndex:(NSInteger)currentPageIndex animate:(BOOL)animate
{
    CGPoint offSet = CGPointMake(CGRectViewWidth * currentPageIndex, 0);
    [self setContentOffset:offSet animated:animate];
    [self setNeedsLayout];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        [self commitInit];
    }
    return self;
}

- (void) reloadData
{
    _delegateResponse.funcNumberOfPages = [_pageDelegate respondsToSelector:@selector(numberOfPagesInPageScrollView:)];
    NSAssert(_delegateResponse.funcNumberOfPages, @"not impletion the selector numberOfPagesInPageScrollView:");
    //
    _delegateResponse.funcDidTapCell = [_pageActionDelegate respondsToSelector:@selector(pageScrollView:didTapCellAtIndex:)];
    //
    _delegateResponse.funcGetPageCell = [_pageDelegate respondsToSelector:@selector(pageScrollView:cellAtIndex:)];
    NSAssert(_delegateResponse.funcGetPageCell, @"not impletion the selector pageScrollView:cellAtIndex:");

    if (_delegateResponse.funcNumberOfPages) {
        _numberOfPages = [_pageDelegate numberOfPagesInPageScrollView:self];
    }

    if ([_pageDelegate respondsToSelector:@selector(bottomToolsViewOfPageScrollView:)]) {
        if (_bottomToolView) {
            [_bottomToolView removeFromSuperview];
        }
        _bottomToolView = [_pageDelegate bottomToolsViewOfPageScrollView:self];
        [self addSubview:_bottomToolView];
    }

    self.contentSize = CGSizeMake(CGRectViewWidth *MAX(_numberOfPages , 1), CGRectViewHeight);
    if ([_pageDelegate respondsToSelector:@selector(topToolsViewOfPageScrollView:)]) {
        [_topToolView removeFromSuperview];
        _topToolView = [_pageDelegate topToolsViewOfPageScrollView:self];
        [self addSubview:_topToolView];

    }
    [self layoutSubviews];
}

- (CGRect) _rectOfPageAtIndex:(NSUInteger)index
{
    CGRect pageRect = CGRectMake(index* CGRectViewWidth, 0, CGRectViewWidth, CGRectViewHeight);
    return CGRectWithEdgeInsetsForRect(_pageCellEdgeInsets, pageRect);
}

- (NSRange) _rangeOfLoadCells
{
    CGPoint offSet = self.contentOffset;
    NSInteger midleIndex = (int)floor(offSet.x / CGRectViewWidth);
    NSInteger count = floor(self.contentOffset.x / CGRectViewWidth);
    CGFloat rest =  self.contentOffset.x - CGRectViewWidth*count;
    if (floor(rest) == 0 ||  ceil(rest) == 0)
    {
        return NSMakeRange(midleIndex, 1);
    }
    else
    {
        return NSMakeRange(midleIndex, 2);
    }
}



- (CGRect) _visibleRect
{
    return CGRectMake(self.contentOffset.x ,self.contentOffset.y , CGRectViewWidth, CGRectViewHeight);
}
- (void) _cleanUnOnScrrenCells
{
    NSArray* subViews = self.subviews;
    CGRect visibleRect = [self _visibleRect];
    for (UIView* eachView  in subViews) {
        if ([eachView isKindOfClass:[DZPageScrollViewCell class]]) {
            DZPageScrollViewCell* cell = (DZPageScrollViewCell*)eachView;
            if (!CGRectIntersectsRect(cell.frame, visibleRect)) {
                [cell removeFromSuperview];
                [cell prepareReuse];
                [_resuableCells addObject:cell];
            }
        }
    }
}

- (NSArray*) _allCells
{
    NSMutableArray* array = [NSMutableArray new];
    NSArray* subviews = self.subviews;
    for (UIView* each  in subviews) {
        if ([each isKindOfClass:[DZPageScrollViewCell class]]) {
            [array addObject:each];
        }
    }
    return array;
}

- (DZPageScrollViewCell*) currentPageScrollCell
{
    NSArray* allCells = [self _allCells];
    for (DZPageScrollViewCell* cell in allCells) {
        if (cell.index == _currentPageIndex) {
            return cell;
        }
    }
    return nil;
}

- (DZPageScrollViewCell*) _cellForIndex:(NSInteger)index
{
    NSArray* cells = [self _allCells];
    for (DZPageScrollViewCell* cell  in cells) {
        if (cell.index == index) {
            return cell;
        }
    }
    DZPageScrollViewCell* cell = [_pageDelegate pageScrollView:self cellAtIndex:index];
    if ([_pageDelegate respondsToSelector:@selector(pageScrollView:willDisplayCell:atIndex:)]) {
        [_pageDelegate pageScrollView:self willDisplayCell:cell atIndex:index];
    }
    return cell;
}

- (DZPageScrollViewCell*) dequeueReusableCell
{
    DZPageScrollViewCell* cell = [_resuableCells anyObject];
    if (cell) {
        [_resuableCells removeObject:cell];
    }
    return cell;
}
- (void) loadRequireCells
{
    self.contentSize = CGSizeMake(CGRectViewWidth*MAX(_numberOfPages , 1), CGRectViewHeight);
    NSRange loadRange = [self _rangeOfLoadCells];
    for (int i = loadRange.location; i < loadRange.location + loadRange.length && i <_numberOfPages; ++i) {
        DZPageScrollViewCell* cell = [self _cellForIndex:i];
        cell.index = i;
        CGRect cellRect = [self _rectOfPageAtIndex:i];
        CGRect visibleRect = [self _visibleRect];
        if (!CGRectContainsRect(visibleRect, cell.frame) &&  CGRectContainsRect(_lastVisibleRect, cellRect)) {
            if ([_pageDelegate respondsToSelector:@selector(pageScrollView:willDisappearCell:atIndex:)]) {
                [_pageDelegate pageScrollView:self willDisappearCell:cell atIndex:i];
            }
        }
        cell.frame = cellRect;
        [self addSubview:cell];
    }
    [self _cleanUnOnScrrenCells];
}

- (void) setShowGestrueIndicatoryView:(BOOL)showGestrueIndicatoryView
{
    _showGestrueIndicatoryView = showGestrueIndicatoryView;
    [self setNeedsLayout];
}


- (void) layoutSubviews
{
    if ([_pageDelegate respondsToSelector:@selector(edgeInsetsOfPageCellInPageScrollView:)]) {
        _pageCellEdgeInsets = [_pageDelegate edgeInsetsOfPageCellInPageScrollView:self];
    }
    else
    {
        _pageCellEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    

    
    //
    if ([_pageDelegate respondsToSelector:@selector(edgeInsetsOfTopToolViewInPageScrollView:)]) {
        _topToolViewEdgeInsets = [_pageDelegate edgeInsetsOfTopToolViewInPageScrollView:self];
    }
    else
    {
        _topToolViewEdgeInsets =  UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ([_pageDelegate respondsToSelector:@selector(edgeInsetsOfBottomToolViewInPageScrollView:)]) {
        _bottomToolViewEdgeInsets = [_pageDelegate edgeInsetsOfBottomToolViewInPageScrollView:self];
    }
    [self loadRequireCells];
    //
    CGSize arrowSize = CGSizeMake(40, 40);
    if (_showGestrueIndicatoryView) {
        _leftArrowIndicatorView.frame = CGRectMake(self.contentOffset.x + 10, self.contentOffset.y + (CGRectGetHeight(self.bounds) - 40)/2, arrowSize.width, arrowSize.height);
        _rightArrowIndicatorView.frame = CGRectMake(self.contentOffset.x + CGRectGetWidth(self.bounds) - 10 - arrowSize.width, self.contentOffset.y + (CGRectGetHeight(self.bounds) - 40)/2, arrowSize.width, arrowSize.height);
        [self bringSubviewToFront:_leftArrowIndicatorView];
        [self bringSubviewToFront:_rightArrowIndicatorView];
    }
    else
    {
        _leftArrowIndicatorView.frame = CGRectZero;
        _rightArrowIndicatorView.frame = CGRectZero;
    }
    
    
    NSInteger count = floor(self.contentOffset.x / CGRectViewWidth);
    CGFloat rest =  (self.contentOffset.x - CGRectViewWidth*count) / CGRectViewWidth;
    
    if (count >=0 && count <= _numberOfPages) {
        if ([_pageDelegate respondsToSelector:@selector(pageScrollView:scrollingAtIndex:)]) {
            [_pageDelegate pageScrollView:self scrollingAtIndex:floor(count)];
        }
    }
    
    if (floor(rest) == 0 ||  ceil(rest) == 0) {
        _currentPageIndex = floor(count);
        if ([_pageDelegate respondsToSelector:@selector(pageScrollView:didDisplayCell:atIndex:)] && _currentPageIndex >= 0) {
            [_pageDelegate pageScrollView:self didDisplayCell:[self _cellForIndex:_currentPageIndex] atIndex:_currentPageIndex];
        }
        if (_currentPageIndex == 0) {
            _leftArrowIndicatorView.hidden = YES;
        }
        else
        {
            _leftArrowIndicatorView.hidden = NO;
        }
        if (_currentPageIndex == _numberOfPages -1) {
            _rightArrowIndicatorView.hidden = YES;
        }
        else
        {
            _rightArrowIndicatorView.hidden = NO;
        }
    }
    if (_bottomToolView) {
        CGRect rect = CGRectWithEdgeInsetsForRect(_bottomToolViewEdgeInsets, CGRectMake(0, 0, CGRectViewWidth, CGRectViewHeight));
        rect = CGRectOffset(rect, self.contentOffset.x, self.contentOffset.y);
        
        
        rect = CGRectMake(rect.origin.x, rect.origin.y-20, rect.size.width,rect.size.height+20);
        
        _bottomToolView.frame = rect;
        

        [self bringSubviewToFront:_bottomToolView];
    }
    
    
    _contentBackgroudView.frame = CGRectMake(0 + self.contentOffset.x, _pageCellEdgeInsets.top, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - _pageCellEdgeInsets.top - _pageCellEdgeInsets.bottom);
    
    if (_topToolView) {
        CGRect rect = CGRectWithEdgeInsetsForRect(_topToolViewEdgeInsets, CGRectMake(0, 0, CGRectViewWidth, CGRectViewHeight));
        _topToolView.frame =  CGRectOffset(rect, self.contentOffset.x, self.contentOffset.y);
        [self bringSubviewToFront:_topToolView];
    }
    CGRect viewRect = self.bounds;
    viewRect.origin = self.contentOffset;
    _backgroudView.frame = viewRect;
    _lastVisibleRect = [self _visibleRect];
}
- (void) scrollToPageAtIndex:(NSUInteger)index withAnimation:(BOOL)animation
{
    [self setCurrentPageIndex:index animate:animation];
}

- (void) removeObjectAtIndex:(NSInteger)index
{
    if (index != _currentPageIndex) {
        return;
    }
    _numberOfPages -= 1;
    for (DZPageScrollViewCell* cell  in [self _allCells]) {
        [cell removeFromSuperview];
        [cell prepareReuse];
        [_resuableCells addObject:cell];
    }
    if (_numberOfPages > 0) {
        if (_currentPageIndex > 1) {
            [self scrollToPageAtIndex:_currentPageIndex  withAnimation:YES];
        }else{
            [self layoutSubviews];
        }
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
