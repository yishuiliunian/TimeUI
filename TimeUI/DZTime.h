//
//  DZTime.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZObject.h"


static NSString* const DZTimeKeyDeviceGuid = @"DeviceGUID";
static NSString* const DZTimeKeyUserGuid   = @"UserGUID";
static NSString* const DZTimeKeyGuid       = @"Guid";
static NSString* const DZTimeKeyBegin      = @"DateBegin";
static NSString* const DZTimeKeyEnd        = @"DateEnd";
static NSString* const DZTimeKeyTypeGuid   = @"TypeGUID";
static NSString* const DZTimeKeyDetail     = @"Detail";

static NSString* const SJKTimeKeyDeviceGuid = @"DeviceGUID";
static NSString* const SJKTimeKeyUserGuid   = @"UserGUID";
static NSString* const SJKTimeKeyGuid       = @"Guid";
static NSString* const SJKTimeKeyBegin      = @"DateBegin";
static NSString* const SJKTimeKeyEnd        = @"DateEnd";
static NSString* const SJKTimeKeyTypeGuid   = @"TypeGUID";
static NSString* const SJKTimeKeyDetail     = @"Detail";



@interface DZTime : DZObject
@property (nonatomic, strong) NSString* deviceGuid;
@property (nonatomic, strong) NSString* userGuid;
@property (nonatomic, strong) NSDate* dateBegin;
@property (nonatomic, strong) NSDate* dateEnd;
@property (nonatomic, strong) NSString* typeGuid;
@property (nonatomic, strong) NSString* detail;
@property (nonatomic, assign) BOOL localChanged;

@property (nonatomic, strong, readonly) NSString* typeName;


- (instancetype) initWithType:(DZTimeType*)type begin:(NSDate*)begin end:(NSDate*)end detal:(NSString*)detail;

- (NSDictionary*) toJsonObject;
- (NSDictionary*) parseDayCost;
@end
