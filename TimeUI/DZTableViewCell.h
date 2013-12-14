//
//  DZTableViewCell.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZCellActionsView.h"
@interface DZTableViewCell : UIView
{
    UIView* _contentView;
}
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) DZCellActionsView* actionsView;
@property (nonatomic, strong) UIView* selectedBackgroudView;
@property (nonatomic, assign) BOOL isSelected;
- (instancetype) initWithIdentifiy:(NSString*)identifiy;
@end
