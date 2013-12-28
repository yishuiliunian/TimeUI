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
    NSString* dbPath = DZActiveAccount.timeDatabasePath;
    DZTimeDB* temp = [[DZTimeDB alloc] initWithPath:dbPath modelName:@"DZTimeTrick"];
    temp.userGuid = DZActiveAccount.identifiy;
    return temp;
}
@end
