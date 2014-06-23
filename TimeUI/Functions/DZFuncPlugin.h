//
//  DZFuncPlugin.h
//  TimeUI
//
//  Created by stonedong on 14-6-18.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DZFuncPluginNomarl,
    DZFuncPluginViewController
}DZFuncPluginType;

#ifdef __cplusplus
extern "C" {
#endif
    DZFuncPluginType DecodeIntToFuncPluginType(int i);
#ifdef __colusplus
}
#endif

DEFINE_DZ_EXTERN_STRING(kFuncName);
DEFINE_DZ_EXTERN_STRING(kFuncClassName);
DEFINE_DZ_EXTERN_STRING(kFuncDetail);
DEFINE_DZ_EXTERN_STRING(kFuncType);
DEFINE_DZ_EXTERN_STRING(kFuncDetailImage);
@interface DZFuncPlugin : NSObject
DEFINE_PROPERTY_STRONG_NSString(name);
DEFINE_PROPERTY_STRONG_NSString(className);
DEFINE_PROPERTY_STRONG_NSString(detail);
DEFINE_PROPERTY_ASSIGN(DZFuncPluginType, type);
DEFINE_PROPERTY_STRONG_NSString(detailImage);
@end
