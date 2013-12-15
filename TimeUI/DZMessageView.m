//
//  DZMessageView.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-14.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZMessageView.h"

@implementation DZMessageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [UILabel new];
        [self addSubview:_textLabel];
        
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
    }
    return self;
}

- (void) layoutSubviews
{
    _imageView.frame = CGRectMake(0, 0, 40, 40);
    _textLabel.frame = CGRectMake(CGRectGetMaxX(_imageView.frame), 0, CGRectGetWidth(self.frame) - CGRectGetMaxX(_imageView.frame), CGRectGetHeight(self.frame));
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
