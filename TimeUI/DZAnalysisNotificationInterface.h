//
//  DZAnalysisNotificationInterface.h
//  TimeUI
//
//  Created by Stone Dong on 14-2-11.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DZAnalysisNotificationInterface <NSObject>

@end



//
DEFINE_NOTIFICATION_MESSAGE(parase_count);
@protocol DZAnalysisCountNI<NSObject>
- (void) parasedCount:(int ) cout forKey:(NSString*)key;
@end