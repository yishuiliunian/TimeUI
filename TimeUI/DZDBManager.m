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
@implementation DZDBManager
+ (DZDBManager*) shareManager
{
    static DZDBManager* manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DZDBManager alloc] init];
    });
    return manager;
}

- (id<DZTimeDBInterface>) timeDBInterface
{
    NSString* dbPath = DZActiveAccount.timeDatabasePath;
    DZTimeDB* temp = [[DZTimeDB alloc] initWithPath:dbPath modelName:@"DZTimeTrick"];
    temp.userGuid = DZActiveAccount.identifiy;
    return temp;
}
@end
