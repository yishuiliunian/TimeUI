//
//  DZAccountViewController.h
//  TimeUI
//
//  Created by Stone Dong on 14-1-6.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZAccountViewController : UIViewController <DZAppearanceInterface>
{
    NSString* _email;
    NSString* _password;
}
@property (nonatomic, strong, readonly) UITextField* emailTextField;
@property (nonatomic, strong, readonly) UITextField* passwordTextField;
@property (nonatomic, strong, readonly) UIButton* loginBtn;
- (void) setAllControlsEnable:(BOOL)enable;
- (void) handleActionWithEmail:(NSString*)email password:(NSString*)password;
- (void) handleActionEndWithError:(NSError*)error;
@end
