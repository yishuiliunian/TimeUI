//
//  DZDBManager.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZTimeDBInterface.h"

#define DZActiveTimeDataBase [[DZDBManager shareManager] timeDBInterface]

@class DZAccount;

@interface DZDBManager : NSObject
+ (DZDBManager*) shareManager;

- (id<DZTimeDBInterface>) timeDBInterface;
- (id<DZTimeDBInterface>) timeDBInterfaceForAccount:(DZAccount*)account;
@end
