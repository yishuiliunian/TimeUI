//
//  DZFuncCell.m
//  TimeUI
//
//  Created by stonedong on 14-6-20.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZFuncCell.h"

@implementation DZFuncCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return self;
    }
    INIT_SELF_SUBVIEW_UIImageView(_installIndicateImageView);
    [self.contentView addSubview:_installIndicateImageView];
    
    INIT_SELF_SUBVIEW(DZBackgroudLabel,_nameLabel);
    [self.contentView addSubview:_nameLabel];
    
    INIT_SELF_SUBVIEW(DZBackgroudLabel,_contentDetailLabel);
    [self.contentView addSubview:_contentDetailLabel];
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    LAYOUT_SUBVIEW_TOP_FILL_WIDTH(_nameLabel, 0, 0, 30);
    _nameLabel.edgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    _contentDetailLabel.frame = CGRectMake(0, CGRectGetMaxY(_nameLabel.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetHeight(_nameLabel.frame));
    _contentDetailLabel.edgeInsets = UIEdgeInsetsMake(0, 20, 5, 10);
}

@end
