//
//  DZSettingModel.h
//  TimeUI
//
//  Created by Stone Dong on 14-1-26.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DZSettingModelTypeLabel,
    DZSettingModelTypeSwitch,
}DZSettingModelType;

@interface DZSettingModel : NSObject
DEFINE_PROPERTY_STRONG_NSString(name);
DEFINE_PROPERTY_STRONG(id, value);
@property (nonatomic,strong, readonly) NSString* cellIdentify;
@property (nonatomic, assign) DZSettingModelType type;
- (UITableViewCell*) createTableViewCell;
@end
