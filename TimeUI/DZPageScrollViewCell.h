//
//  DZPageScrollViewCell.h
//  QQPicShow
//
//  Created by Stone Dong on 13-10-17.
//  Copyright (c) 2013年 Tencent SNS Terminal Develope Center. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 * 为按页滑动的布局方式提供内容View
 */

@interface DZPageScrollViewCell : UIView
{
    UIView* _contentView;
}
- (instancetype) initWithReuseIdentifier:(NSString*)identifier;
- (void) setContentView:(UIView *)contentView;
- (void) prepareReuse;
@end
