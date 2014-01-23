//
//  DZPageScrollView.h
//  QQPicShow
//
//  Created by Stone Dong on 13-10-17.
//  Copyright (c) 2013年 Tencent SNS Terminal Develope Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZPageScrollViewCell.h"
@class DZPageScrollView;
@protocol DZPageScrollViewDelegate <NSObject>
@optional
//总共的Page数量
- (NSUInteger) numberOfPagesInPageScrollView:(DZPageScrollView*)pageScrollView;
//返回一个PageCell
- (DZPageScrollViewCell*) pageScrollView:(DZPageScrollView*)pageScrollView cellAtIndex:(NSUInteger)index;
//PageCell 的上下左右边距
- (UIEdgeInsets) edgeInsetsOfPageCellInPageScrollView:(DZPageScrollView*)pageScrollView;
//返回底部工具栏
- (UIView*) bottomToolsViewOfPageScrollView:(DZPageScrollView*)pageScrollView;
//地步工具栏上下左右边距
- (UIEdgeInsets) edgeInsetsOfBottomToolViewInPageScrollView:(DZPageScrollView *)pageScrollView;
//头部工具栏
- (UIView*) topToolsViewOfPageScrollView:(DZPageScrollView*)pageScrollView;
- (UIEdgeInsets) edgeInsetsOfTopToolViewInPageScrollView:(DZPageScrollView *)pageScrollView;
//按页滑动正好滑动到某一页时，将会触发该函数
- (void) pageScrollView:(DZPageScrollView*)pageView didDisplayCell:(DZPageScrollViewCell*)cell atIndex:(NSInteger)index;
//按页滑动，某一页将要进入屏幕时触发该回调
- (void) pageScrollView:(DZPageScrollView *)pageView willDisplayCell:(DZPageScrollViewCell *)cell atIndex:(NSInteger)index;

//按页滑动，某一页将要离开屏幕时触发该回调
- (void) pageScrollView:(DZPageScrollView *)pageView willDisappearCell:(DZPageScrollViewCell *)cell atIndex:(NSInteger)index;

- (void) pageScrollView:(DZPageScrollView *)pageView scrollingAtIndex:(NSInteger)index;

@end


@protocol DZPageScrollViewActionDelegate <NSObject>
@optional
//点击某一页之后，回调
- (void) pageScrollView:(DZPageScrollView*)pageScrollView didTapCellAtIndex:(NSUInteger)index;
@end

/*
 *提供按页横向滑动的布局方式的View，并且提供设置顶部和地步工具栏
 */

@interface DZPageScrollView : UIScrollView
@property (nonatomic, strong, readonly) UIImageView* backgroudView;
@property (nonatomic, assign) BOOL showGestrueIndicatoryView;
@property (nonatomic, strong, readonly) UIImageView* leftArrowIndicatorView;
@property (nonatomic, strong, readonly) UIImageView* rightArrowIndicatorView;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, weak) id<DZPageScrollViewDelegate> pageDelegate;
@property (nonatomic, weak) id<DZPageScrollViewActionDelegate> pageActionDelegate;
@property (nonatomic, assign) NSInteger initIndex;
- (void) reloadData;
//互动到某一个具体的压面
- (void) scrollToPageAtIndex:(NSUInteger)index withAnimation:(BOOL)animation;
- (DZPageScrollViewCell*) dequeueReusableCell;
- (DZPageScrollViewCell*) currentPageScrollCell;
- (void) removeObjectAtIndex:(NSInteger)index;
@end
