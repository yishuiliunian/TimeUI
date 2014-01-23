//
//  DZProgramDefines.h
//  TimeUI
//
//  Created by Stone Dong on 14-1-21.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *
 * 定义字符串
 */
#define DEFINE_NSString(str)  static NSString* const kDZ##str = @""#str;

#define DEFINE_PROPERTY(mnmKind, type , name) @property (nonatomic, mnmKind)  type  name
#define DEFINE_PROPERTY_ASSIGN(type, name) DEFINE_PROPERTY(assign, type, name)
#define DEFINE_PROPERTY_ASSIGN_Float(name) DEFINE_PROPERTY_ASSIGN(float, name)
#define DEFINE_PROPERTY_ASSIGN_INT64(name) DEFINE_PROPERTY_ASSIGN(int64_t, name)
#define DEFINE_PROPERTY_ASSIGN_INT32(name) DEFINE_PROPERTY_ASSIGN(int32_t, name)
#define DEFINE_PROPERTY_ASSIGN_INT16(name) DEFINE_PROPERTY_ASSIGN(int16_t, name)
#define DEFINE_PROPERTY_ASSIGN_INT8(name) DEFINE_PROPERTY_ASSIGN(int8_t, name)
#define DEFINE_PROPERTY_ASSIGN_Double(name) DEFINE_PROPERTY_ASSIGN(double, name)


#define DEFINE_PROPERTY_STRONG(type, name) DEFINE_PROPERTY(strong, type, name)
#define DEFINE_PROPERTY_STRONG_UILabel(name) DEFINE_PROPERTY_STRONG(UILabel*, name)
#define DEFINE_PROPERTY_STRONG_NSString(name) DEFINE_PROPERTY_STRONG(NSString*, name)
#define DEFINE_PROPERTY_STRONG_UIImageView(name) DEFINE_PROPERTY_STRONG(UIImageView*, name)



#define INIT_SUBVIEW(sView, class, name) name = [[class alloc] init]; [sView addSubview:name];
#define INIT_SUBVIEW_UIImageView(sView, name) INIT_SUBVIEW(sView, UIImageView, name)
#define INIT_SUBVIEW_UILabel(sView, name) INIT_SUBVIEW(sView, UILabel, name)

#define INIT_SELF_SUBVIEW(class, name) INIT_SUBVIEW(self, class , name)
#define INIT_SELF_SUBVIEW_UIImageView(name) INIT_SUBVIEW_UIImageView(self, name)
#define INIT_SELF_SUBVIEW_UILabel(name) INIT_SUBVIEW_UILabel(self, name)



@interface DZProgramDefines : NSObject

@end
