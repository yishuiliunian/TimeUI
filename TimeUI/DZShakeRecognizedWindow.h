//
//  DZShakeRecognizedWindow.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-19.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString* const DZShareNotificationMessage = @"DZShareNotificationMessage";

@protocol DZShareInterface
- (void) didGetShareMessage;
@end

@interface UIWindow (guid)
@property (nonatomic, assign, readonly) BOOL isShowGuidView;
- (void) triggleTeachGuideView;
@end

@interface DZShakeRecognizedWindow : UIWindow

@end
