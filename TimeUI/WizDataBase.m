//
//  WizDataBase.m
//  WizIos
//
//  Created by dzpqzb on 12-12-20.
//  Copyright (c) 2012年 wiz.cn. All rights reserved.
//

#import "WizDataBase.h"
static int const WizMetaDataBaseVersion = 3;

@implementation WizDataBase

- (void) dealloc
{
    [_dataBase closeOpenResultSets];
    [_dataBase close];
}

- (id) initWithPath:(NSString *)dbPath modelName:(NSString *)modelName
{
    self = [super init];
    if (self) {
        _dataBase = [[FMDatabase alloc] initWithPath:dbPath];
        if (![_dataBase open]) {
            return nil;
        }
        NSString* path = [[NSBundle mainBundle] pathForResource:modelName ofType:@"plist"];
        NSString* md5 = [DZGlobals fileMD5:path];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath] || (![md5 isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:dbPath]])) {
            if ([_dataBase constructDataBaseModel:modelName]) {
                [[NSUserDefaults standardUserDefaults] setObject:md5 forKey:dbPath];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }
    return self;
}


@end
