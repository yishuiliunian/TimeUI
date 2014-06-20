//
//  DZPieChartNode.h
//  TimeUI
//
//  Created by stonedong on 14-6-18.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZChartNode.h"
@interface DZPieChartNode : NSObject
@property (nonatomic, strong) DZChartNode* chartNode;
@property (nonatomic, strong) NSString* key;
@property (nonatomic, assign) int64_t value;
@property (nonatomic, assign) BOOL isSpecial;
@property (nonatomic, strong, readonly) CAShapeLayer* shapeLayer;
- (instancetype) initWithChartNode:(DZChartNode*)node;
@end