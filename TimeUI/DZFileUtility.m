//
//  DZFileUtility.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZFileUtility.h"

@implementation DZFileUtility
+(NSString*) documentsPath
{
    static NSString* documentDirectory= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == documentDirectory) {
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentDirectory = [paths objectAtIndex:0];
        }
    });
	return documentDirectory;
}

+ (NSString*) userDocumentsPath:(NSString *)userId
{
    return [[DZFileUtility documentsPath] stringByAppendingPathComponent:userId];
}
+ (BOOL) ensurePathExists:(NSString*)path
{
	BOOL b = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
	{
		NSError* err = nil;
		b = [[NSFileManager defaultManager]  createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
		if (!b)
		{
            //            DDLogError(err.description);
		}
	}
	return b;
}
+ (BOOL) ensureFileExists:(NSString*)path
{
    if (![[NSFileManager defaultManager]  fileExistsAtPath:path]) {
        return [[NSFileManager defaultManager]  createFileAtPath:path contents:nil attributes:nil];
    }
    return YES;
}

+ (id) jsonObjectFromResourcesByName:(NSString *)name type:(NSString*)type error:(NSError *__autoreleasing *)error
{
    NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    NSData* data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:error];
}

+ (BOOL) removeFile:(NSString *)path error:(NSError *__autoreleasing *)error
{
    return ([[NSFileManager defaultManager] removeItemAtPath:path error:error]);
}
@end
