//
//  DZChartsViewController.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-20.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZChartsViewController.h"
#import "DZTimeControl.h"
#import "DZNumberLabel.h"



@interface DZChartsViewController ()
{
    DZTimeControl* _timeControl;
    DZNumberLabel* _numberLabel;
    UIPageControl* _pageControl;
}
@end

@implementation DZChartsViewController


- (instancetype) initWithChartControllers:(NSArray *)vcs
{
    self = [super init];
    if (!self) {
        return self;
    }
    [self setChartsViewContoller:vcs];
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) loadViewCSS:(id)cssValue forKey:(NSString *)key
{
    if ([key isEqualToString:@"time_drag_bg"]) {
        _timeControl.dragBackgroundImageView.backgroundColor = [UIColor colorWithPatternImage:cssValue];
    }
    else if ([key isEqualToString:@"time_drag_item"])
    {
        _timeControl.dragItemImageView.image = cssValue;
    }
    else if ([key isEqualToString:@"control_bg"])
    {
        UIImage* image = cssValue;
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
        _timeControl.labelsBackgroundImageView.image = image;
    } else if ([key isEqualToString:@"time_bottom"])
    {
        _timeControl.bottomLabel.font = cssValue;
    }
    else if ([key isEqualToString:@"type_size"])
    {
        _timeControl.typeLabel.font = cssValue;
    }
    else if ([key isEqualToString:@"time_bottom_color"])
    {
        _timeControl.bottomLabel.textColor = cssValue;
    }
}

- (void) loadControls
{
    _timeControl = [DZTimeControl new];
    _timeControl.bottomLabel.text = NSLocalizedString(@"Click Save", nil);
    _timeControl.bottomLabel.textAlignment = NSTextAlignmentCenter;
    _timeControl.bottomLabel.textColor = [UIColor blueColor];
    _timeControl.typeLabel.textAlignment = NSTextAlignmentRight;
    _timeControl.typeLabel.text = @"睡大觉";
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    
    _timeControl.backgroundColor = [UIColor whiteColor];
}

- (void) viewWillLayoutSubviews
{
    _timeControl.frame = CGRectMake(0, 20, CGRectVCWidth, 150);
}
- (void) loadChartsViewControllers
{
    if (_chartsViewContoller) {
        if ([self isViewLoaded]) {
            for (UIViewController* vc in _chartsViewContoller) {
                [vc willMoveToParentViewController:self];
                [self addChildViewController:vc];
                [vc didMoveToParentViewController:vc];
            }
        }
    }
}
- (void) setChartsViewContoller:(NSArray *)chartsViewContoller
{
    if (_chartsViewContoller != chartsViewContoller) {
        if (_chartsViewContoller) {
            for (UIViewController* vc in _chartsViewContoller) {
                [vc willMoveToParentViewController:nil];
                [vc removeFromParentViewController];
                [vc didMoveToParentViewController:nil];
            }
        }
        _chartsViewContoller = chartsViewContoller;
        [self loadChartsViewControllers];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pageScrollView.backgroundColor = [UIColor whiteColor];
    self.pageScrollView.showGestrueIndicatoryView = NO;
    [self loadControls];
    [self loadChartsViewControllers];
    [self.pageScrollView reloadData];
	// Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger) numberOfPagesInPageScrollView:(DZPageScrollView *)pageScrollView
{
    return _chartsViewContoller.count;
}

- (DZPageScrollViewCell*) pageScrollView:(DZPageScrollView *)pageScrollView cellAtIndex:(NSUInteger)index
{
    static NSString* const cellIdentifiy = @"page_scroll_cell";
    DZPageScrollViewCell* cell = [pageScrollView dequeueReusableCell];
    if (!cell) {
        cell = [[DZPageScrollViewCell alloc] initWithReuseIdentifier:cellIdentifiy];
    }
    UIViewController* vc  = _chartsViewContoller[index];
    [cell setContentView:vc.view];
    return cell;
}
// top controls
- (UIView*) topToolsViewOfPageScrollView:(DZPageScrollView *)pageScrollView
{
    return _timeControl;
}
- (UIEdgeInsets) edgeInsetsOfTopToolViewInPageScrollView:(DZPageScrollView *)pageScrollView
{
    return UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.view.frame) - 150, 0);
}

- (UIEdgeInsets) edgeInsetsOfPageCellInPageScrollView:(DZPageScrollView *)pageScrollView
{
    return UIEdgeInsetsMake(160, 0, 20, 0);
}
//bottom
- (UIView*) bottomToolsViewOfPageScrollView:(DZPageScrollView *)pageScrollView
{
    return _pageControl;
}

- (UIEdgeInsets) edgeInsetsOfBottomToolViewInPageScrollView:(DZPageScrollView *)pageScrollView
{
    return UIEdgeInsetsMake(CGRectVCHeight - 20, 100, 0, 100);
}

- (void) pageScrollView:(DZPageScrollView *)pageView scrollingAtIndex:(NSInteger)index
{
    _pageControl.numberOfPages = _chartsViewContoller.count;
    _pageControl.currentPage = index;
}
//
//- (void) pageScrollView:(DZPageScrollView *)pageView willDisplayCell:(DZPageScrollViewCell *)cell atIndex:(NSInteger)index
//{
//    UIViewController* vc  = _chartsViewContoller[index];
//    [vc viewWillAppear:YES];
//}
//
//- (void) pageScrollView:(DZPageScrollView *)pageView didDisplayCell:(DZPageScrollViewCell *)cell atIndex:(NSInteger)index
//{
//    UIViewController* vc  = _chartsViewContoller[index];
//    [vc viewDidAppear:YES];
//}
//
//- (void) pageScrollView:(DZPageScrollView *)pageView willDisappearCell:(DZPageScrollViewCell *)cell atIndex:(NSInteger)index
//{
//    UIViewController* vc  = _chartsViewContoller[index];
//    [vc viewWillDisappear:YES];
//    [vc viewDidDisappear:YES];
//}
@end
