//
//  DZChangedTypesNI.h
//  TimeUI
//
//  Created by stonedong on 14-4-4.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

DEFINE_NOTIFICATION_MESSAGE(TypesChanged);

DEFINE_NSString(TypesChangedAdd);
DEFINE_NSString(TypesChangedRemove);
DEFINE_NSString(TypesChangedModified);


@class DZTimeType;
@protocol DZChangedTypesNI <NSObject>
- (void) handleMessageDidAddType:(DZTimeType*)type;
- (void) handleMessageDidRemoveType:(DZTimeType*)type;
- (void) handleMessageDidMofifiedType:(DZTimeType *)type;
@end
