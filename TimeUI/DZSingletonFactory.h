//
//  DZSingletonFactory.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DZShareSingleFactory [DZSingletonFactory shareFactory]

extern id  DZSingleForClass(Class class);

@interface DZSingletonFactory : NSObject

+ (DZSingletonFactory*) shareFactory;

- (id) shareInstanceFor:(Class)aclass;
- (id) shareInstanceFor:(Class)aclass category:(NSString*)key;
@end
