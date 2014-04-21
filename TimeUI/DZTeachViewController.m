//
//  DZTeachViewController.m
//  TimeUI
//
//  Created by stonedong on 14-4-18.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZTeachViewController.h"
@interface DZGuidePageCell : DZPageScrollViewCell
@property (nonatomic, strong, readonly) UILabel* textLabel;
@end


@implementation DZGuidePageCell

- (instancetype) initWithReuseIdentifier:(NSString *)identifier
{
    self = [super initWithReuseIdentifier:identifier];
    if (!self) {
        return self;
    }
    _contentView = [UIImageView new];
    [self setContentView:_contentView];
    INIT_SUBVIEW_UILabel(_contentView, _textLabel);
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
}
@end


@interface DZTeachViewController ()

@end

@implementation DZTeachViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.pageScrollView reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//总共的Page数量
- (NSUInteger) numberOfPagesInPageScrollView:(DZPageScrollView*)pageScrollView
{
    return 10;
}
//返回一个PageCell
- (DZPageScrollViewCell*) pageScrollView:(DZPageScrollView*)pageScrollView cellAtIndex:(NSUInteger)index
{
    DZGuidePageCell* cell = (DZGuidePageCell*)[pageScrollView dequeueReusableCell];
    if (!cell) {
        cell = [[DZGuidePageCell alloc] initWithReuseIdentifier:@"aa"];
    }
    cell.textLabel.text = [@(index) stringValue];
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}
//PageCell 的上下左右边距
- (UIEdgeInsets) edgeInsetsOfPageCellInPageScrollView:(DZPageScrollView*)pageScrollView
{
    return UIEdgeInsetsZero;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
