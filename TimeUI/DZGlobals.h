//
//  DZGlobals.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZGlobals : NSObject
+ (NSString*) fileMD5:(NSString*)path;
+(NSString*) genGUID;
@end
