//
//  DZAccount.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZAccount.h"
#import "DZFileUtility.h"

static NSString* const kDZDBName = @"time.db";

@implementation DZAccount

- (NSString*) documentsPath
{
    NSString* path = [DZFileUtility userDocumentsPath:self.identifiy];
    [DZFileUtility ensurePathExists:path];
    return path;
}

- (NSString*) timeDatabasePath
{
    return [self.documentsPath stringByAppendingPathComponent:kDZDBName];
}
@end
