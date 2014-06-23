//
//  DZParallelTableViewCell.m
//  TimeUI
//
//  Created by stonedong on 14-6-19.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZParallelTableViewCell.h"

@implementation DZParallelTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        INIT_SELF_SUBVIEW_UIImageView(_backgroudImageView);
        [self.contentView addSubview:_backgroudImageView];
        _backgroudImageView.alpha = 0.5;
        _offSet = 0;
    }
    return self;
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void) setOffSet:(float)offSet
{
    _offSet = offSet;
    [self setNeedsLayout];
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    [self.contentView insertSubview:_backgroudImageView atIndex:0];
    CGRect rect = CGRectZero;
    
    CGSize imageSize = self.backgroudImageView.image.size;
    
    CGFloat shrinkHegith = CGRectGetWidth(self.bounds) / imageSize.width * imageSize.height;
    if (shrinkHegith < CGRectGetHeight(self.bounds) * 2) {
        rect.size.height = CGRectGetHeight(self.bounds) * 2;
        rect.size.width = imageSize.width * rect.size.height / imageSize.height;
    } else
    {
        rect.size.width = CGRectGetWidth(self.bounds);
        rect.size.height = shrinkHegith;
    }
    
    CGFloat baseY = (CGRectGetHeight(self.bounds) - rect.size.height)/2;
    rect.origin.y = baseY;
    rect.origin.x = (CGRectGetWidth(self.bounds) - rect.size.width )/ 2;
    CGFloat yOffset = CGRectGetHeight(self.bounds) / CGRectGetHeight(CGRectLoadViewFrame) * self.offSet;
    rect.origin.y += yOffset;
    if (rect.origin.y < baseY - rect.size.height/2) {
        rect.origin.y = baseY - rect.size.height/2;
    } else if (rect.origin.y> baseY + rect.size.height/2)
    {
        rect.origin.y = baseY + rect.size.height/2;
    }
    _backgroudImageView.frame = rect;
}

@end
