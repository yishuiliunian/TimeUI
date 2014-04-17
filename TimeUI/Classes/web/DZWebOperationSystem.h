//
//  DZWebOperationSystem.h
//  TimeUI
//
//  Created by stonedong on 14-4-4.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DZWebDefaultOS [DZWebOperationSystem defaultOS]

@interface DZWebOperationSystem : NSObject
+ (DZWebOperationSystem*) defaultOS;
- (BOOL) isWebApplicationRequst:(NSURL *)url;
@end
