//
//  DZGlobalActionView.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-19.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZGlobalActionView.h"

@implementation DZGlobalActionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}
- (instancetype) init
{
    self = [super init];
    if (self) {
        DZActionItemView* item1 = [[DZActionItemView alloc] init];
        item1.height = 40;
        item1.backgroundColor = [UIColor redColor];
        
        DZActionItemView* item2 = [[DZActionItemView alloc] init];
        item2.height = 70;
        item2.backgroundColor = [UIColor blueColor];
        
        [self.actionContentView setItems:@[item1, item2]];
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
