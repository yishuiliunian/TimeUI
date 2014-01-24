//
//  DZTypeCell.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-13.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTypeCell.h"
#import <KXKiOS7Colors.h>
#import "DZImageCache.h"

float CountLabelWidth = DZTypeCellHeight -40;
float TypeImageLabelWidth = 1;

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
        _selectedIndicaterView = [UIView new];
        _typeImageView         = [UIImageView new];
        
        [_contentView addSubview:_selectedIndicaterView];
        [_contentView addSubview:_typeImageView];
        
        INIT_SELF_SUBVIEW(UITextField, _countLabel);
        INIT_SELF_SUBVIEW(UITextField, _nameLabel);
        INIT_SELF_SUBVIEW(UITextField, _costLabel);
        
        _countLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _countLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        _countLabel.background = DZCachedImageByName(@"number_bg");


    }
    return self;
}

- (void) setIsSelected:(BOOL)isSelected
{
    [super setIsSelected:isSelected];
    
//    if (isSelected) {
//        _selectedIndicaterView.backgroundColor = [KXKiOS7Colors darkOrange];
//    }
//    else
//    {
//        _selectedIndicaterView.backgroundColor = [KXKiOS7Colors lightGreen];
//    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    _selectedIndicaterView.frame = CGRectMake(0, 0, 10, CGRectGetHeight(self.frame));
    _typeImageView.frame = CGRectMake(CGRectGetMaxX(_selectedIndicaterView.frame), 0, TypeImageLabelWidth, TypeImageLabelWidth);
    
    _countLabel.frame = CGRectMake(CGRectGetWidth(self.frame) - CountLabelWidth - 5, (CGRectViewHeight - CountLabelWidth)/2, CountLabelWidth, CountLabelWidth);
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_typeImageView.frame),
                                  0,
                                  CGRectGetMinX(_countLabel.frame) - CGRectGetMaxX(_typeImageView.frame),
                                  CGRectGetHeight(self.frame));
//    _costLabel.frame = CGRectOffset(_nameLabel.frame, 0, CGRectGetHeight(self.frame)/2);
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
