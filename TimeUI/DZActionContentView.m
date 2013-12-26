//
//  DZActionContentView.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-18.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZActionContentView.h"
#import <CTFeedbackViewController.h>
@interface DZActionContentView ()
{
    
}
@end

@implementation DZActionContentView
@synthesize height=_height;


- (void) handleTapGestruceRecoginzer:(UITapGestureRecognizer*)tgrz
{
    if(tgrz.state == UIGestureRecognizerStateRecognized)
    {
        CTFeedbackViewController* vc = [[CTFeedbackViewController alloc] init];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:vc]  animated:YES completion:^{
            
        }];
    }
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTapTarget:self selector:@selector(handleTapGestruceRecoginzer:)];
        _height = 0;
    }
    return self;
}

- (instancetype) initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        [self setItems:items];
    }
    return self;
}

- (void) setItems:(NSArray *)items
{
    if (_items != items) {
        for (DZActionItemView* each  in _items) {
            [each removeFromSuperview];
        }
        _items = items;
        _height = 0;
        for (DZActionItemView* each  in _items) {
            _height += each.height;
            [self addSubview:each];
        }
    }
}

- (void) layoutSubviews
{
    float yoffSet = 0;
    for (int i = 0 ; i < _items.count; i++) {
        DZActionItemView* item = _items[i];
        item.frame = CGRectMake(0, yoffSet, CGRectGetWidth(self.frame), item.height);
        yoffSet += item.height;
    }
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
