//
//  DZCommandThread.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-20.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DZCommandQueue;
@interface DZCommandThread : NSThread
@property (nonatomic, weak  ) DZCommandQueue  * commandQueue;
@end
