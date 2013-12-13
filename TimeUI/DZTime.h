//
//  DZTime.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-10.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZTime : NSObject
@property (nonatomic, strong) NSString* guid;
@property (nonatomic, strong) NSDate* begin;
@property (nonatomic, strong) NSDate* end;
@property (nonatomic, strong) NSString* typeId;
@property (nonatomic, strong) NSString* detail;

- (NSDictionary*) parseDayCost;
@end
