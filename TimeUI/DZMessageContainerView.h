//
//  DZMessageContainerView.h
//  TimeUI
//
//  Created by Stone Dong on 13-12-14.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZCustomeView.h"
#import "DZMessageView.h"
#import "DZMessage.h"

@interface DZMessageContainerView : DZCustomeView
@property (nonatomic, strong, readonly) DZMessageView* messageView;
- (void) showText:(NSString*)text withType:(DZMessageType)type;
- (void) showErrorText:(NSString*)text;
- (void) showSuccessText:(NSString *)text;
- (void) showWarningText:(NSString*)text;
- (void) showInfoText:(NSString*)text;
@end
