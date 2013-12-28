//
//  DZTimeType.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZObject.h"
static NSString* const SJKTypeGuid = @"guid";
static NSString* const SJKTypeIdentify = @"identify";
static NSString* const SJKTypeName = @"name";
static NSString* const SJKTypeDetail = @"detail";
static NSString* const SJKTypeCrateDate = @"create_date";
static NSString* const SJKTypeImageAvatarGuid = @"avatar_guid";
static NSString* const SJKTypeFinished = @"finished";
static NSString* const SJKTypeUserGuid = @"user_guid";


@interface DZTimeType : DZObject

@property (nonatomic, strong) NSString* guid;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* detail;
@property (nonatomic, strong) NSDate* createDate;
@property (nonatomic, strong) NSString* imageAvatarGuid;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) BOOL localChanged;
@property (nonatomic, strong) NSString* otherInfos;
@property (nonatomic, strong) NSString* userGuid;
@property (nonatomic, strong, readonly) UIImage* imageAvatar;
- (instancetype) initGenGUID;
@end
