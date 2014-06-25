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
        [_actionButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self addSubview:_actionButton];
        
        _messageLabel = [UILabel new];
        [self addSubview:_messageLabel];
        _messageLabel.font = [UIFont systemFontOfSize:13];
        
        [[DZNotificationCenter defaultCenter] addObserver:self forKey:kDZSyncContextChangedMessage];
        [self showLastSyncDate];
    }
    return self;
}

- (void) showLastSyncDate
{
    NSDate* lastDate = DZDefaultContextManager.lastSyncDate;
    if (!lastDate) {
        _messageLabel.text = @"亲，您从来都没有同步过啊！！";
    } else {
        _messageLabel.text = [NSString stringWithFormat:@"上一次同步：%@", [lastDate  localDescription]];
    }

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
        case DZSyncContextSyncVersion:
            _messageLabel.text = @"正在同步版本数据....";
            break;
        case DZSyncContextSyncUploadTime:
            _messageLabel.text = @"正在上传时间片段...";
            break;
        case DZSyncContextSyncUploadType:
            _messageLabel.text = @"正在上传时间类型...";
            break;
        case DZSyncContextSyncDownloadTime:
            _messageLabel.text = @"正在下载服务器上的时间片段...";
            break;
        case DZSyncContextSyncDownloadType:
            _messageLabel.text = @"正在下载服务器上的时间类型...";
            break;
        case DZSyncContextSyncAppleToken:
            _messageLabel.text = @"正在登陆中....";
            break;
        case DZSyncContextNomal:
            [self showLastSyncDate];
            break;
        default:
            break;
    }
    NSLog(@"current state is %d",aim);
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
    _messageLabel.frame = CGRectMake(CGRectGetMaxX(_actionButton.frame) + 20, 0, CGRectGetWidth(self.frame)-20 - CGRectGetMaxX(_actionButton.frame), CGRectGetHeight(self.frame));
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
