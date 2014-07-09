//
//  DZTimeTrickManger.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DZTimeType;
@interface DZTimeTrickManger : NSObject
@property (nonatomic, strong, readonly) NSDate* lastTrickDate;
@property (nonatomic, assign, readonly) float alreadyCostTime;
@property (nonatomic, strong) DZTimeType* timeType;
+ (DZTimeTrickManger*) shareManager;
- (void) addTimeLogWithType:(DZTimeType*)type detail:(NSString*)detail;
- (void) addTimeWithDetail:(NSString*)detail;
- (void) restoreTrickDate:(NSDate*)date;
@end
