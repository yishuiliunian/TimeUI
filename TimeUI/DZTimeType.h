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
static NSString* const SJKTypeName = @"Name";
static NSString* const SJKTypeDetail = @"Detail";
static NSString* const SJKTypeCrateDate = @"CreateDate";
static NSString* const SJKTypeImageAvatarGuid = @"AvatarGuid";
static NSString* const SJKTypeFinished = @"Finished";
static NSString* const SJKTypeUserGuid = @"UserGuid";
static NSString* const SJKTypeOtherInfos = @"OtherInfos";

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
