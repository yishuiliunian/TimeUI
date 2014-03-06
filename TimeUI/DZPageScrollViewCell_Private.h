//
//  DZPageScrollViewCell_Private.h
//  QQPicShow
//
//  Created by Stone Dong on 13-10-17.
//  Copyright (c) 2013年 Tencent SNS Terminal Develope Center. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZPageScrollViewCell.h"

@interface DZPageScrollViewCell ()
@property (nonatomic, assign) NSString* resueIdentifier;
@property (nonatomic, assign) NSUInteger index;
- (void) prepareReuse;
@end
