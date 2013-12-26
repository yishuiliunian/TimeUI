//
//  DZActionView.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-18.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZCustomeView.h"
#import "DZActionContentView.h"
#import "DZActionItemView.h"

@interface DZActionView : DZCustomeView
@property (nonatomic, strong, readonly) DZActionContentView* actionContentView;
- (instancetype) initWithItems:(NSArray*)items;
@end
