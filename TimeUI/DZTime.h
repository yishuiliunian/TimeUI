//
//  DZTime.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const DZTimeKeyDeviceGuid = @"deviceGuid";
static NSString* const DZTimeKeyUserGuid   = @"userGuid";
static NSString* const DZTimeKeyGuid       = @"guid";
static NSString* const DZTimeKeyBegin      = @"dateBegin";
static NSString* const DZTimeKeyEnd        = @"dateEnd";
static NSString* const DZTimeKeyTypeGuid     = @"typeGuid";
static NSString* const DZTimeKeyDetail     = @"detail";
@interface DZTime : NSObject
@property (nonatomic, strong) NSString* deviceGuid;
@property (nonatomic, strong) NSString* userGuid;
@property (nonatomic, strong) NSString* guid;
@property (nonatomic, strong) NSDate* dateBegin;
@property (nonatomic, strong) NSDate* dateEnd;
@property (nonatomic, strong) NSString* typeGuid;
@property (nonatomic, strong) NSString* detail;
- (NSDictionary*) toJsonObject;
- (NSDictionary*) parseDayCost;
@end
