//
//  DZMessageCenter.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-14.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZMessageCenter.h"
#import "DZSingletonFactory.h"
#import "DZMessageContainerView.h"
@interface DZMessageCenter()
@property (nonatomic, weak) DZMessageContainerView* massageContainerView;
@end
@implementation DZMessageCenter

+ (DZMessageCenter*) shareCenter
{
    return DZSingleForClass([DZMessageCenter class]);
}

- (void) showMessage:(NSString*)massage withType:(DZMessageType) type
{
    if (self.massageContainerView) {
        [self.massageContainerView showText:massage withType:type];
    }
    else
    {
        DZMessageContainerView* containerView = [DZMessageContainerView new];
        [containerView showText:massage withType:type];
        self.massageContainerView = containerView;
    }
}
- (void) showInfoMessage:(NSString *)Message
{
    [self showMessage:Message withType:DZMessageTypeInfo];
}

- (void) showErrorMessage:(NSString *)Message
{
    [self showMessage:Message withType:DZMessageTypeError];
}

- (void) showWarningMessage:(NSString *)Message
{
    [self showMessage:Message withType:DZMessageTypeWarning];
}

- (void) showSuccessMessage:(NSString *)Message
{
    [self showMessage:Message withType:DZMessageTypeSuccess];
}


@end
