//
//  DZTypeCell.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-13.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZTableViewCell.h"

#define DZTypeCellHeight 90

@interface DZTypeCell : DZTableViewCell
@property (nonatomic, strong, readonly) UIImageView * typeImageView;
@property (nonatomic, strong, readonly) UILabel     * costLabel;
@property (nonatomic, strong,readonly ) UILabel     * nameLabel;
@property (nonatomic, strong, readonly) UILabel     * countLabel;
@end
