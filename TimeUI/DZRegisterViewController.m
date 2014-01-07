//
//  DZRegisterViewController.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-6.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZRegisterViewController.h"
#import "DZRegisterAccountOperation.h"
#import "DZMessageCenter.h"
#import "DZAccount.h"
@interface DZRegisterViewController () <DZRegisterAccountDelegate>
{
    BOOL _running;

}
@end

@implementation DZRegisterViewController
- (void) registerAccountOperation:(DZRegisterAccountOperation *)op failedWithError:(NSError *)error
{
    self.loginBtn.enabled  = YES;
    [DZMessageShareCenter showErrorMessage:error.localizedDescription];
    [self setAllControlsEnable:YES];
}

- (void) registerAccountOperation:(DZRegisterAccountOperation *)op successWithUserInfo:(NSDictionary *)userInfo
{
    self.loginBtn.enabled  = YES;
    [DZMessageShareCenter showSuccessMessage:@"注册成功"];
    [self setAllControlsEnable:YES];
    NSString* userGuid = userInfo[@"userguid"];
    DZAccount* account = [[DZAccount alloc] init];
    account.identifiy = userGuid;
    account.email = _email;
    account.password = _password;
    account.isLogin = YES;
    [account synchronize];
    
    DZAccount* b = [[DZAccount alloc] initWithEmail:_email];
    
    
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

- (void) handleActionWithEmail:(NSString *)email password:(NSString *)password
{
    [DZRegisterAccountOperation runRegiserOperatioWithDelegate:self userEmail:email password:password];
    [self setAllControlsEnable:NO];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.loginBtn setTitle:@"注册" forState:UIControlStateNormal];
    self.title = @"注册";
}

@end
