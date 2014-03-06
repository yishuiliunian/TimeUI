//
//  DZSyncOperation.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-17.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZAccount.h"
@interface DZSyncOperation : NSOperation
@property (nonatomic, strong) DZAccount* account;

+ (void) syncAccount:(DZAccount*)account;
@end
