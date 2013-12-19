//
//  DZSyncActionItemView.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-19.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZSyncActionItemView.h"
#import "DZContextManager.h"
#import "DZSyncOperation.h"
#import "DZAccountManager.h"
#import "DZNotificationCenter.h"
@interface DZSyncActionItemView () <DZSyncContextChangedInterface>
{
    UIButton* _actionButton;
    UILabel* _messageLabel;
}
@end

@implementation DZSyncActionItemView

- (void) dealloc
{
    [[DZNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_actionButton];
        
        _messageLabel = [UILabel new];
        [self addSubview:_messageLabel];
        
        [[DZNotificationCenter defaultCenter] addObserver:self forKey:kDZSyncContextChangedMessage];
    }
    return self;
}

- (void) syncContextChangedFrom:(DZSyncContext)origin toContext:(DZSyncContext)aim
{
    [self setNeedsLayout];
}

- (void) configureButtonWithSyncing:(BOOL)isSyncing
{
    [_actionButton removeTarget:self action:@selector(startSync) forControlEvents:UIControlEventTouchUpInside];
    [_actionButton removeTarget:self action:@selector(stopSync) forControlEvents:UIControlEventTouchUpInside];
    if (!isSyncing) {
        [_actionButton setTitle:@"同步" forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(startSync) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [_actionButton setTitle:@"停止" forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(stopSync) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void) startSync
{
    [self configureButtonWithSyncing:YES];
    [DZSyncOperation syncAccount:DZActiveAccount];
}

- (void) stopSync
{
    [self configureButtonWithSyncing:NO];
}



- (void) layoutSubviews
{
    BOOL isSyncing = bDZSyncContextIsSyncing;
    [self configureButtonWithSyncing:isSyncing];
    _actionButton.frame = CGRectMake(10, 0, 40, CGRectGetHeight(self.frame));
    if (!isSyncing) {
        _messageLabel.frame = CGRectMake(50, 0, CGRectGetWidth(self.frame)-60, CGRectGetHeight(self.frame));
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
