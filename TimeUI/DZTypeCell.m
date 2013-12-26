//
//  DZTypeCell.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-13.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTypeCell.h"
#import <KXKiOS7Colors.h>

float CountLabelWidth = DZTypeCellHeight;
float TypeImageLabelWidth = DZTypeCellHeight;

@interface DZTypeCell()
{
    UIView* _selectedIndicaterView;
}
@end
@implementation DZTypeCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _nameLabel             = [UILabel new];
        _selectedIndicaterView = [UIView new];
        _countLabel            = [UILabel new];
        _costLabel             = [UILabel new];
        _typeImageView         = [UIImageView new];
        
        [_contentView addSubview:_selectedIndicaterView];
        [_contentView addSubview:_nameLabel];
        [_contentView addSubview:_countLabel];
        [_contentView addSubview:_costLabel];
        [_contentView addSubview:_typeImageView];
    }
    return self;
}

- (void) setIsSelected:(BOOL)isSelected
{
    [super setIsSelected:isSelected];
    if (isSelected) {
        _selectedIndicaterView.backgroundColor = [KXKiOS7Colors darkOrange];
    }
    else
    {
        _selectedIndicaterView.backgroundColor = [KXKiOS7Colors lightGreen];
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    _selectedIndicaterView.frame = CGRectMake(0, 0, 10, CGRectGetHeight(self.frame));
    _typeImageView.frame = CGRectMake(CGRectGetMaxX(_selectedIndicaterView.frame), 0, TypeImageLabelWidth, TypeImageLabelWidth);
    _countLabel.frame = CGRectMake(CGRectGetWidth(self.frame) - CountLabelWidth, 0, CountLabelWidth, CountLabelWidth);
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_typeImageView.frame),
                                  0,
                                  CGRectGetMinX(_countLabel.frame) - CGRectGetMaxX(_typeImageView.frame),
                                  CGRectGetHeight(self.frame) / 2);
    _costLabel.frame = CGRectOffset(_nameLabel.frame, 0, CGRectGetHeight(self.frame)/2);
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
