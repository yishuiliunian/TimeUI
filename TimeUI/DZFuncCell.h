//
//  DZFuncCell.h
//  TimeUI
//
//  Created by stonedong on 14-6-20.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZParallelTableViewCell.h"
#import "DZBackgroudLabel.h"
@interface DZFuncCell : DZParallelTableViewCell
DEFINE_PROPERTY_STRONG(DZBackgroudLabel*,nameLabel);
DEFINE_PROPERTY_STRONG(DZBackgroudLabel*, contentDetailLabel);
DEFINE_PROPERTY_STRONG_UIImageView(installIndicateImageView);
@end
