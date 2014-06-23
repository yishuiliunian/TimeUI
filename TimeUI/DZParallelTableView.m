//
//  DZParallelTableView.m
//  TimeUI
//
//  Created by stonedong on 14-6-19.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZParallelTableView.h"

@implementation DZParallelTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void) layoutSubviews
{
    [super layoutSubviews];
    NSArray* visibleCells = [self visibleCells];
    for (UITableViewCell* cell in visibleCells) {
        CGFloat offsetRate = (CGRectGetMinY(cell.frame) - self.contentOffset.y);
        if ([cell isKindOfClass:[DZParallelTableViewCell class]]) {
            DZParallelTableViewCell* parallerCell = (DZParallelTableViewCell*)cell;
            parallerCell.offSet = offsetRate - CGRectGetHeight(self.bounds)/2;
        }
    }
}
@end
