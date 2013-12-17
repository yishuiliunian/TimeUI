//
//  NSError+dz.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-16.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (dz)
+ (NSError*) dzErrorWithCode:(int)code message:(NSString*)message;
@end
