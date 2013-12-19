//
//  DZContextManager.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-19.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DZSyncContextNomal            = 0,
    DZSyncContextSyncing          = 1,

    DZSyncContextSyncUploadTime   = 1 << 1  | 0x00000001,
    DZSyncContextSyncUploadType   = 1 << 2  |0x00000001,
    DZSyncContextSyncVersion      = 1 << 3  |0x00000001,
    DZSyncContextSyncAppleToken   = 1 << 4  |0x00000001,
    DZSyncContextSyncDownloadTime = 1 << 5  |0x00000001,
    DZSyncContextSyncDownloadType = 1 << 6  |0x00000001,
    DZSyncContextSyncError        = 1 << 7
}DZSyncContext;

#define DZDefaultContextManager [DZContextManager shareManager]

#define DZSyncContextSet(ctx) (DZDefaultContextManager.currentSyncContext = ctx)
#define bDZSyncContextIsSyncing ((DZDefaultContextManager.currentSyncContext | 0x0) == 1)
#define DZSyncContextCurrent (DZDefaultContextManager.currentSyncContext)



#define kDZSyncContextChangedMessage @"kDZSyncContextChangedMessage"
@protocol DZSyncContextChangedInterface
- (void) syncContextChangedFrom:(DZSyncContext)origin toContext:(DZSyncContext)aim;
@end

@interface DZContextManager : NSObject
@property (nonatomic, assign) DZSyncContext currentSyncContext;
+ (DZContextManager*) shareManager;
@end
