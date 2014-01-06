//
//  DZTimeType.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZObject.h"

/**
 *  json key 定义
 */
static NSString* const SJKTypeGuid = @"Guid";
static NSString* const SJKTypeIdentify = @"identify";
static NSString* const SJKTypeName = @"name";
static NSString* const SJKTypeDetail = @"detail";
static NSString* const SJKTypeCrateDate = @"create_date";
static NSString* const SJKTypeImageAvatarGuid = @"avatar_guid";
static NSString* const SJKTypeFinished = @"finished";
static NSString* const SJKTypeUserGuid = @"user_guid";
static NSString* const SJKTypeOtherInfos = @"other_infos";

/**
 *  时间类型
 */
@interface DZTimeType : DZObject
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* detail;
@property (nonatomic, strong) NSDate* createDate;
@property (nonatomic, strong) NSString* imageAvatarGuid;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) BOOL localChanged;
@property (nonatomic, strong) NSString* otherInfos;
@property (nonatomic, strong) NSString* userGuid;
@property (nonatomic, strong, readonly) UIImage* imageAvatar;

@end
