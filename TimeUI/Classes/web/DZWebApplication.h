//
//  DZWebApplication.h
//  TimeUI
//
//  Created by stonedong on 14-4-4.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZWebApplication : NSObject
@property (nonatomic, strong) NSString* appId;

- (instancetype) initWithAppID:(NSString*)appID;
@end
