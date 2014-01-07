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
@end
