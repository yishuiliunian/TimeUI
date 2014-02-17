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
#import "DZTokenManager.h"
#import "DZAccountManager.h"

@interface DZLoginViewController ()
{
    BOOL _running;
}
@end

@implementation DZLoginViewController



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
    [[DZTokenManager shareManager] appleToken:email password:password response:^(NSString *token, NSString *userGuid, NSError *error) {
        if (error) {
            [DZMessageShareCenter showErrorMessage:error.localizedDescription];
        }
        else
        {
            DZAccount* account = [[DZAccount alloc] init];
            account.identifiy = userGuid;
            account.email = _email;
            account.password = _password;
            account.isLogin = YES;
            [account synchronize];
            [DZMessageShareCenter showSuccessMessage:@"登陆成功！"];
            [[DZAccountManager shareManager] registerActiveAccount:account];
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    } ];
    
}
- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    self.title = @"登陆";
}
@end
