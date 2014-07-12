//
//  DZSwitchCell.m
//  TimeUI
//
//  Created by stonedong on 14-7-12.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZSwitchCell.h"

@interface DZSwitchCell ()
DEFINE_PROPERTY_STRONG(UISwitch*, enableSwitch);
@end

@implementation DZSwitchCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        INIT_SELF_SUBVIEW(UISwitch, _enableSwitch);
        INIT_SELF_SUBVIEW_UILabel(_titleLabel);
        
        [self.contentView addSubview:_enableSwitch];
        [self.contentView addSubview:_titleLabel];
        
        [self setEnabled:YES];
        
        [_enableSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void) valueChanged:(UISwitch*)sch
{
    if ([_delegate respondsToSelector:@selector(switchCell:didChangedEnable:)]) {
        [_delegate switchCell:self didChangedEnable:_enableSwitch.on];
    }
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(10, 0, CGRectGetWidth(self.frame) - 20 - 80, CGRectViewHeight);
    float switchHeight = 40;
    _enableSwitch.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame) +10, (CGRectViewHeight - switchHeight)/2,  80 , switchHeight);
}

- (void) setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    [_enableSwitch setOn:enabled animated:NO];
}



@end
