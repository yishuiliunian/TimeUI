//
//  DZChartViewController.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-11.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZAstirFrameViewController.h"
#import "DZTimeType.h"
@interface DZChartViewController : DZAstirFrameViewController
- (void) showLineChartForType:(DZTimeType*)type;
@end
