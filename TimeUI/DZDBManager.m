//
//  DZDBManager.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZDBManager.h"
#import "DZTimeDB.h"
#import "DZAccountManager.h"
#import "DZSingletonFactory.h"
#import "DZFileUtility.h"
@implementation DZDBManager
+ (DZDBManager*) shareManager
{
    return DZSingleForClass([DZDBManager class]);
}

- (id<DZTimeDBInterface>) timeDBInterface
{
    return [self timeDBInterfaceForAccount:DZActiveAccount];
}

- (id<DZTimeDBInterface>) timeDBInterfaceForAccount:(DZAccount*)account
{
    NSString* dbPath = account.timeDatabasePath;
    DZTimeDB* db = [[DZTimeDB alloc] initWithPath:dbPath modelName:@"DZTimeTrick"];
    db.userGuid = account.identifiy;
    return db;
}

- (void) removeDBForAccount:(DZAccount *)account
{
    NSString* dbPath = account.timeDatabasePath;
    NSError* error = nil;
    if (![DZFileUtility removeFile:dbPath error:&error]) {
        DDLogError(@"删除数据库文件失败! %@",error);
    }
}
@end
