//
//  DZSwitchCell.h
//  TimeUI
//
//  Created by stonedong on 14-7-12.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DZSwitchCell;
@protocol DZSwitchCellDelegate <NSObject>

- (void) switchCell:(DZSwitchCell*)cell didChangedEnable:(BOOL)enable;

@end

@interface DZSwitchCell : UITableViewCell
DEFINE_PROPERTY_WEAK(id<DZSwitchCellDelegate>, delegate);
DEFINE_PROPERTY_STRONG_UILabel(titleLabel);
DEFINE_PROPERTY_ASSIGN(BOOL, enabled);
@end
