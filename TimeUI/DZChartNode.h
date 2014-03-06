//
//  DZChartNode.h
//  TimeUI
//
//  Created by Stone Dong on 14-1-8.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZChartNode : NSObject
@property (nonatomic, strong) NSString* key;
@property (nonatomic, assign) int64_t value;
@property (nonatomic, assign) BOOL isSpecial;
@end
