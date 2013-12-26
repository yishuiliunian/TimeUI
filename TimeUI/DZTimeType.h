//
//  DZTimeType.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const kDZKeyIdentifiy = @"identifiy";
static NSString* const kDZKeyName = @"name";
static NSString* const kDZKeyDetail = @"detail";

@interface DZTimeType : NSObject
@property (nonatomic, strong) NSString* identifiy;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* detail;
@property (nonatomic, strong) NSDate* createDate;
@property (nonatomic, strong) NSString* imageAvatarGuid;
@property (nonatomic, strong, readonly) UIImage* imageAvatar;
@end
