//
//  DZSelecteTypeInterface.h
//  TimeUI
//
//  Created by Stone Dong on 14-2-11.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

DEFINE_NOTIFICATION_MESSAGE(selectedType);

@class DZTimeType;
@protocol DZSelecteTypeInterface <NSObject>
- (void) didSelectedTimeType:(DZTimeType*)timetype;
@end
