//
//  DZRegisterAccountOperation.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-17.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DZRegisterAccountOperation;
@protocol DZRegisterAccountDelegate <NSObject>
- (void) registerAccountOperation:(DZRegisterAccountOperation*)op failedWithError:(NSError*)error;
- (void) registerAccountOperation:(DZRegisterAccountOperation *)op successWithUserInfo:(NSDictionary*)userInfo;
@end


@interface DZRegisterAccountOperation : NSOperation
@property (nonatomic, weak) id <DZRegisterAccountDelegate> delegate;
+ (void) runRegiserOperatioWithDelegate:(id<DZRegisterAccountDelegate>)delegate userEmail:(NSString*)email password:(NSString*)passwrod;
- (instancetype) initWithDelegate:(id<DZRegisterAccountDelegate>)delegate userEmail:(NSString*)email password:(NSString*)passwrod;
@end
