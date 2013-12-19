//
//  DZActionContentView.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-18.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZActionItemView.h"
@interface DZActionContentView : UIView
@property (nonatomic, assign, readonly) float height;
@property (nonatomic, strong) NSArray* items;
- (instancetype) initWithItems:(NSArray*)items;
@end
