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
@end
