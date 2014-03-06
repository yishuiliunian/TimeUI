//
//  DZSettingSectionModel.h
//  TimeUI
//
//  Created by Stone Dong on 14-1-26.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZSettingSectionModel : NSObject
DEFINE_PROPERTY_STRONG_NSString(header);
DEFINE_PROPERTY_STRONG_NSString(footer);
DEFINE_PROPERTY_STRONG(NSArray*, settings);
@end
