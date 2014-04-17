//
//  DZWebPlugin.h
//  TimeUI
//
//  Created by stonedong on 14-4-4.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFINE_Handle_JS_Requst_Function(x) -(void)handleWebRequest_##x:(NSDictionary*)params

@interface DZWebPlugin : NSObject
+ (NSString*) version;
+ (NSString*) detail;
+ (NSString*) moduleName;
@end
