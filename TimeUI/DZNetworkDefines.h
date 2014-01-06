//
//  DZNetworkDefines.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-15.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#ifndef TimeUI_DZNetworkDefines_h
#define TimeUI_DZNetworkDefines_h
/**
 *  Http 方法
 */
static NSString* const HttpMethodPost                  = @"POST";
static NSString* const HttpMethodGet                   = @"GET";

/**
 *  通用参数
 */
static NSString* const DZServerCommonKeyMethod         = @"method";
static NSString* const DZServerCommonKeyAppVersion     = @"app_version";
static NSString* const DZServerCommonKeyClientType     = @"client_type";
static NSString* const DZServerCommonKeyData           = @"datas";
static NSString* const DZServerCommonKeyToken          = @"token";
static NSString* const DZServerCommonKeyDeviceIdentify = @"devicekey";

/**
 *  服务器方法
 */

static NSString* const DZServerMethodRegiserUser    = @"user.register";
static NSString* const DZServerMethodUserLogin      = @"user.login";
static NSString* const DZServerMethodTokenUpdate    = @"token.update";
static NSString* const DZServerMethodUpdateTime     = @"time.update";
static NSString* const DZServerMethodVersionsGetAll = @"version.get_all";
static NSString* const DZServerMethodGetTimes       = @"time.get";
static NSString* const DZServerMethodUpdateType     = @"type.update";
static NSString* const DZServerMethodGetTypes       = @"type.get_all";

#endif
