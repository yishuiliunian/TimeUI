//
//  DZReloadTypesNI.h
//  TimeUI
//
//  Created by stonedong on 14-6-23.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

DEFINE_NOTIFICATION_MESSAGE(DidReloadTypes)

@protocol DZReloadTypesNI <NSObject>
- (void) globalDidReloadTypes;
@end
