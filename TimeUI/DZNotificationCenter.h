//
//  DZNotificationCenter.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-15.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^DZDecodeNotificationBlock)(id observer, NSDictionary* userInfo);

@class DZNotificationCenter;
@protocol DZNotificationInitDelegaete <NSObject>
- (DZDecodeNotificationBlock) decodeNotification:(NSString*)message forCenter:(DZNotificationCenter*)center;
@end

@interface DZNotificationCenter : NSObject
@property (nonatomic, weak) id<DZNotificationInitDelegaete> delegate;
+ (DZNotificationCenter*) defaultCenter;
- (void) addDecodeNotificationBlock:(DZDecodeNotificationBlock)block forMessage:(NSString*)message;
- (void) addObserver:(id)observer forKey:(NSString*)key;
- (void) removeObserver:(id)observer;
- (void) removeObserver:(NSObject *)observer forMessage:(NSString*)key;
- (void) postMessage:(NSString*)message userInfo:(NSDictionary*)userInfo;
@end


#define DZDefaultNotificationCenter [DZNotificationCenter defaultCenter]