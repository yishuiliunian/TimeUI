//
//  DZLoginViewController.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-6.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZLoginViewController.h"
#import "DZThemeManager.h"
#import "DZRegisterAccountOperation.h"

@interface DZLoginViewController () < DZRegisterAccountDelegate>
{
    BOOL _running;
}
@end

@implementation DZLoginViewController

- (void) registerAccountOperation:(DZRegisterAccountOperation *)op failedWithError:(NSError *)error
{
    self.loginBtn.enabled  = YES;
}

- (void) registerAccountOperation:(DZRegisterAccountOperation *)op successWithUserInfo:(NSDictionary *)userInfo
{
    self.loginBtn.enabled  = YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _running = NO;
    }
    return self;
}

- (void) handleLoginAction:(id)sender
{
    [DZRegisterAccountOperation runRegiserOperatioWithDelegate:self userEmail:self.emailTextField.text password:self.passwordTextField.text];
    _running = YES;
    self.loginBtn.enabled = NO;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(handleLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    self.title = @"登陆";
}
@end
