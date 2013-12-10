//
//  DZAccountManager.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZAccount.h"
#define DZActiveAccount [[DZAccountManager shareManager] activeAccount]

@interface DZAccountManager : NSObject
+ (DZAccountManager*) shareManager;
- (DZAccount*) activeAccount;
@end
