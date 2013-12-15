//
//  DZMessageCenter.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-14.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TSMessage.h>
#define DZMessageShareCenter [DZMessageCenter shareCenter]

@interface DZMessageCenter : NSObject
+ (DZMessageCenter*) shareCenter;
- (void) showErrorMessage:(NSString*)Message;
- (void) showSuccessMessage:(NSString *)Message;
- (void) showWarningMessage:(NSString*)Message;
- (void) showInfoMessage:(NSString*)Message;
@end
