//
//  DZFileUtility.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZFileUtility : NSObject
+(NSString*) documentsPath;
+ (NSString*) userDocumentsPath:(NSString*)userId;
+ (BOOL) ensurePathExists:(NSString*)path;
+ (id) jsonObjectFromResourcesByName:(NSString *)name type:(NSString*)type error:(NSError *__autoreleasing *)error;

+ (BOOL) removeFile:(NSString*)path error:(NSError* __autoreleasing*)error;
@end
