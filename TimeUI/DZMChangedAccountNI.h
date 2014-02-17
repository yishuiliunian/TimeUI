//
//  DZMChangedAccountNI.h
//  TimeUI
//
//  Created by Stone Dong on 14-2-17.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

DEFINE_NOTIFICATION_MESSAGE(changed_account);

@class DZAccount;
@protocol DZMChangedAccountNI <NSObject>
- (void) didChangedAccount:(DZAccount*)oldAccount toAccount:(DZAccount*)otherAccount;
@end
