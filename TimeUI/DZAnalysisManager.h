//
//  DZAnalysisManager.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-20.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZAnalysisModels.h"

#define DZShareAnalysisManager [DZAnalysisManager shareManager]


@interface DZAnalysisManager : NSObject
+ (DZAnalysisManager*) shareManager;
- (void) triggleCommand:(NSString*)command;
- (DZAnalysisWeekModel*) weekModelForType:(DZTimeType*)type;
- (void) triggleAnaylysisWeekWithType:(DZTimeType*)type;
- (void) addWeekModel:(DZAnalysisWeekModel*)midek withType:(DZTimeType*)type;

//
- (void) triggleAnaylysisTimeCount;
- (int) numberOfTimeForType:(DZTimeType*)type;

//
- (NSTimeInterval) timeCostOfType:(DZTimeType*)type;
@end
