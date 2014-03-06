//
//  DZHasAccountContentView.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-24.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZHasAccountContentView.h"

#import "DZContextManager.h"
#import "DZSyncOperation.h"
#import "DZAccountManager.h"
#import "DZNotificationCenter.h"
#import <NSDate-TKExtensions.h>
@interface DZHasAccountContentView ()
{
    UIButton* _actionButton;
    UILabel* _messageLabel;
}
@end

@implementation DZHasAccountContentView
- (void) dealloc
{
    [DZDefaultNotificationCenter removeObserver:self forMessage:kDZSyncContextChangedMessage];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_actionButton];
        
        _messageLabel = [UILabel new];
        [self addSubview:_messageLabel];
        
        _messageLabel.text = [DZDefaultContextManager.lastSyncDate localDescription];
        
        [[DZNotificationCenter defaultCenter] addObserver:self forKey:kDZSyncContextChangedMessage];
    }
    return self;
}



- (void) syncContextChangedFrom:(DZSyncContext)origin toContext:(DZSyncContext)aim
{
    [self setNeedsLayout];
    switch (aim) {
        case DZSyncContextSyncError:
        {
            NSError* error  = DZDefaultContextManager.lastSyncError;
            _messageLabel.text = error.localizedDescription;
            break;
        }
        default:
            break;
    }
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
