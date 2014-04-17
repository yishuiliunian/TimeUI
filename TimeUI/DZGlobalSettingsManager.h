//
//  DZGlobalSettingsManager.h
//  TimeUI
//
//  Created by stonedong on 14-3-30.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

DEFINE_DZ_EXTERN_STRING(kDZDefaultServerHost)
DEFINE_DZ_EXTERN_STRING(kDZDefaultServerPort)

#define DZGlobalSettingsShareManager [DZGlobalSettingsManager shareManager]


#ifdef __cplusplus 
extern "C" {
#endif
    NSString* DZServerWithHostAndPort(NSString* host, NSString* port);
#ifdef __cplusplus
}
#endif


#define DZServerHost DZServerWithHostAndPort([DZGlobalSettingsShareManager serverHost], [DZGlobalSettingsShareManager serverPort])
@interface DZGlobalSettingsManager : NSObject
+ (DZGlobalSettingsManager*) shareManager;

- (NSString*) serverHost;
- (void) setServerHost:(NSString*)str;
- (NSString*) serverPort;
- (void) setServerPort:(NSString*)port;
@end
