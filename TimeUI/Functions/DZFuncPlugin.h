//
//  DZFuncPlugin.h
//  TimeUI
//
//  Created by stonedong on 14-6-18.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
DEFINE_DZ_EXTERN_STRING(kFuncName);
DEFINE_DZ_EXTERN_STRING(kFuncClassName);
DEFINE_DZ_EXTERN_STRING(kFuncDetail);

@interface DZFuncPlugin : NSObject
DEFINE_PROPERTY_STRONG_NSString(name);
DEFINE_PROPERTY_STRONG_NSString(className);
DEFINE_PROPERTY_STRONG_NSString(detail);
@end
