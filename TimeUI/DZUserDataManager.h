//
//  DZUserDataManager.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZUserDataManager : NSObject
+ (DZUserDataManager*) shareManager;
- (void) setUserData:(id)data forKey:(NSString*)key user:(NSString*)identify;
- (id) userDataForKey:(NSString*)key user:(NSString*)identify;
- (void) setActiveUserData:(id)data forKey:(NSString*)key;
- (id) activeUserDataForKey:(NSString*)key;


//
- (void) moveSettingsFrom:(DZAccount*)origin aim:(DZAccount*)account;
@end
