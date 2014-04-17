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

typedef void(^SettingsValueChangedBlock)(NSString* key, id value);

@interface DZSettingModel : NSObject
DEFINE_PROPERTY_STRONG_NSString(identify);
DEFINE_PROPERTY_STRONG_NSString(name);
DEFINE_PROPERTY_STRONG(id, value);
@property (nonatomic,strong, readonly) NSString* cellIdentify;
@property (nonatomic, assign) DZSettingModelType type;
@property (nonatomic, strong) SettingsValueChangedBlock valueChangedBlock;

- (instancetype) initWithIdentify:(NSString*)identifer
                             name:(NSString*)name
                             type:(DZSettingModelType)type
                     defaultValue:(id)value
                     changedBlock:(SettingsValueChangedBlock)block;
@end
