//
//  DZMessageContainerView.m
//  TimeUI
//
//  Created by Stone Dong on 13-12-14.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZMessageContainerView.h"
#import "DZImageCache.h"

static NSDate* date = nil;

NSDate* lastDate()
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        date = [NSDate date];
    });
    return date;
}

void showLastDate()
{
    NSLog(@"time is %f", [lastDate() timeIntervalSinceNow]);
    date = [NSDate date];
    
}
@interface DZMessageContainerView ()
{
    NSMutableArray* _messagesQueue;
}
@end

@implementation DZMessageContainerView

- (UIImage*) imageByMessageType:(DZMessageType)type
{
    NSString* imageName = nil;
    switch (type) {
        case DZMessageTypeError:
            imageName = @"icon-error";
            break;
        case DZMessageTypeSuccess:
            imageName = @"icon-success";
            break;
        default:
            imageName = @"icon-info";
            break;
    }
    return DZCachedImageByName(imageName);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        DZMessageView* messageView = [[DZMessageView alloc] init];
        [self setContentView:messageView];
        _messageView = messageView;
        _messagesQueue = [NSMutableArray new];
    }
    return self;
}
- (UIView*) parentView
{
    return [UIApplication sharedApplication].keyWindow;
}

- (void) showWithAnimation:(BOOL)animation
{
    [self showWithAnimation:animation start:^{
        self.contentView.frame = CGRectMake(10, 10, 10, 10);
    } animationBlock:^{
        self.contentView.frame = CGRectMake(20, 20, 20, 20);
    } complete:^{
        
    }];
}

- (void) showNextMessage
{
    if (!self.isVisible || self.superview == nil) {
        return;
    }
    showLastDate();
    if (_messagesQueue.count == 0) {
        [self hideWithAnimation:YES];
    }
    else
    {
        DZMessage* message = _messagesQueue.firstObject;
        [_messagesQueue removeObject:message];
        [self showMessageInContainerView:message withAnimaiton:YES];
    }
}
- (void) showMessageInContainerView:(DZMessage*)message withAnimaiton:(BOOL)animation
{
    if (!self.isVisible || self.superview == nil) {
        [_messageView.layer removeAllAnimations];
        return;
    }
    void(^startAnimation)(void) = ^(void) {
        _messageView.frame = CGRectMake(0, - 50, CGRectGetWidth(self.superview.frame), 50);
        _messageView.textLabel.text = message.text;
        _messageView.imageView.image = [self imageByMessageType:message.type];
    };
    
    void(^animationBlock)(void) = ^(void) {
        _messageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.superview.frame), 50);
    };
    
    void(^completeBlock)(void) = ^(void) {
        double delayInSeconds = message.showTime;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self showNextMessage];
        });
    };
    
    startAnimation();
    if (animation) {
        [UIView animateWithDuration:DZAnimationDefualtDuration animations:animationBlock completion:^(BOOL finished) {
            if (finished) {
                completeBlock();
            }
        }];
    }
    else
    {
        animationBlock();
        completeBlock();
    }
}
- (void) showMessage:(DZMessage*)message withAnimation:(BOOL)animation
{
    if (!self.isVisible) {
        showLastDate();
        _messageView.backgroundColor = [UIColor orangeColor];
        [self showWithAnimation:animation start:^{
            _messageView.frame = CGRectMake(0, - 50, CGRectGetWidth(self.superview.frame), 50);
            _messageView.textLabel.text = message.text;
            _messageView.imageView.image = [self imageByMessageType:message.type];
        } animationBlock:^{
            _messageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.superview.frame), 50);
        } complete:^{
            double delayInSeconds = message.showTime;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self showNextMessage];
            });
        }];
    }
    else
    {
        [_messagesQueue addObject:message];
    }
}

- (void) hideWithAnimation:(BOOL)aimation
{
    [_messagesQueue removeAllObjects];
    [_messageView.layer removeAllAnimations];
    [self hideWithAnimation:aimation start:^{
        
    } animationBlock:^{
       _messageView.frame = CGRectMake(0, - 50, CGRectGetWidth(self.superview.frame), 50);
    } complete:^{
        
    }];
}
- (void) showText:(NSString*)text withType:(DZMessageType)type
{
    DZMessage* errorMessage = [DZMessage new];
    errorMessage.text = text;
    errorMessage.type = type;
    [self showMessage:errorMessage withAnimation:YES];
}

- (void) showErrorText:(NSString*)text
{
    [self showText:text withType:DZMessageTypeError];
}

- (void) showSuccessText:(NSString *)text
{
    [self showText:text withType:DZMessageTypeSuccess];
}

- (void) showWarningText:(NSString*)text
{
    [self showText:text withType:DZMessageTypeWarning];
}

- (void) showInfoText:(NSString*)text
{
    [self showText:text withType:DZMessageTypeInfo];
}


@end
