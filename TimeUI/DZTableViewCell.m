//
//  DZTableViewCell.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTableViewCell.h"
#import "DZTableViewCell_private.h"


@implementation DZTableViewCell
@synthesize identifiy = _identifiy;
@synthesize index = _index;


- (void) prepareForReused
{
    _index = NSNotFound;
}

- (instancetype) initWithIdentifiy:(NSString*)identifiy
{
    self = [super init];
    if (self) {
        _identifiy = identifiy;
    }
    return self;
}

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

@end
