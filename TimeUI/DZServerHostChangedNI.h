//
//  DZServerHostChangedNI.h
//  TimeUI
//
//  Created by stonedong on 14-3-31.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

DEFINE_NOTIFICATION_MESSAGE(ServerHostDidChanged)


@protocol DZServerHostChangedNI <NSObject>
- (void) serverHostDidChanged;
@end
