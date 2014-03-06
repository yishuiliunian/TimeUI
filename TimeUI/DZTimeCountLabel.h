//
//  DZTimeCountLabel.h
//  TimeUI
//
//  Created by Stone Dong on 14-1-26.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZTimeCountLabel : UIView
@property (nonatomic, assign) CFTimeInterval beginTimeOffset;
- (void) start;
- (void) restart;
- (void) stop;
- (void) reset;
@end
