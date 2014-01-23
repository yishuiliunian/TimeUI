//
//  DZPageScrollViewCell.m
//  QQPicShow
//
//  Created by Stone Dong on 13-10-17.
//  Copyright (c) 2013年 Tencent SNS Terminal Develope Center. All rights reserved.
//

#import "DZPageScrollViewCell.h"
#import "DZPageScrollViewCell_Private.h"
#import "DZGeometryTools.h"
@interface DZPageScrollViewCell ()
{
}
@end

@implementation DZPageScrollViewCell
@synthesize index = _index;
@synthesize resueIdentifier = _resueIdentifier;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (instancetype) initWithReuseIdentifier:(NSString *)identifier
{
    self = [super init];
    if (self) {
        _resueIdentifier = identifier;
    }
    return self;
}

- (void) prepareReuse
{
    _index = NSNotFound;
}

- (void) setContentView:(UIView *)contentView
{
    _contentView = contentView;
    if (contentView) {
        [self addSubview:_contentView];
    }
    [self setNeedsLayout];
}

- (void) layoutSubviews
{
    _contentView.frame = self.bounds;
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
