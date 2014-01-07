//
//  DZTimeType.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTimeType.h"

#import <NSDate-TKExtensions.h>
#import "NSDate+SSToolkitAdditions.h"
#import "DZAccountManager.h"
#import "NSError+dz.h"
#import "NSDictionary+DecodeJSON.h"
@implementation DZTimeType


- (void) commonInit
{
    _otherInfos = @"";
    _detail = @"";
    _imageAvatarGuid = @"";
    _isFinished = NO;
    _localChanged = YES;
}

- (NSString*) userGuid
{
    return DZActiveAccount.identifiy;
}
- (instancetype) initGenGUID
{
    self = [super initGenGUID];
    if (self) {
        _createDate = [NSDate date];
        _localChanged = YES;
        [self commonInit];
    }
    return self;
}
- (id) init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void) setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:SJKTypeDetail]) {
        _detail = value;
    }
    else if ([key isEqualToString:SJKTypeName])
    {
        _name = value;
    }
}


- (NSDictionary*) toJsonObject
{
    NSMutableDictionary* json = [NSMutableDictionary new];
    json[SJKTypeGuid] = self.guid;
    json[SJKTypeName] = self.name;
    if (self.detail) {
        json[SJKTypeDetail] = self.detail;
    }
    json[SJKTypeCrateDate] = [self.createDate TKISO8601String];
    if (self.imageAvatarGuid) {
        json[SJKTypeImageAvatarGuid] = self.imageAvatarGuid;
    }
    json[SJKTypeFinished] = @(self.isFinished);
    json[SJKTypeUserGuid] = self.userGuid;
    json[SJKTypeOtherInfos] = self.otherInfos;
    return json;
}

- (BOOL) decodeFromJSONObject:(NSError *__autoreleasing *)error
{
    return NO;
}

- (BOOL) decodeFromJSONObject:(NSDictionary *)dic error:(NSError *__autoreleasing *)error
{
    self.guid =  dic[SJKTypeGuid];
    if (!self.guid) {
        if (error != NULL) {
            *error = [NSError dzParseErrorWithKey:@"GUID"];
        }
        return NO;
    }
    self.createDate =  [dic decodeDateWithKey:SJKTypeCrateDate error:error];
    if (*error) {
        return NO;
    }
    self.isFinished = [dic decodeBOOLWithKey:SJKTypeFinished error:error];
    self.name = [dic decodeStringWithKey:SJKTypeName error:error];
    if (*error) {
        return NO;
    }
    self.otherInfos = [dic decodeStringWithKey:SJKTypeOtherInfos error:error];
    if (*error) {
        self.otherInfos = @"";
    }
    self.detail = [dic decodeStringWithKey:SJKTypeDetail error:error];
    if (*error) {
        self.detail = @"";
    }
    return YES;
}
@end
