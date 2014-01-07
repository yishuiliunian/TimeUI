//
//  DZAccountViewController.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-6.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZAccountViewController.h"

@interface DZAccountViewController ()
{
    UIImageView* _passwordImageView ;
    UIImageView* _emailImageView;
}
@end

@implementation DZAccountViewController

- (void) loadViewCSS:(id)cssValue forKey:(NSString*)key
{
    if ([key isEqualToString:@"btn_login"]) {
        [_loginBtn setBackgroundImage:cssValue forState:UIControlStateNormal];
    } else if ([key isEqualToString:@"email"]) {
        _emailImageView.image = cssValue;
    } else if ([key isEqualToString:@"password"]) {
        _passwordImageView.image = cssValue;
    } else if ([key isEqualToString:@"textfield_backgroud"]) {
        _emailTextField.background = cssValue;
        _passwordTextField.background = cssValue;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _emailTextField                 = [[UITextField alloc] init];
    _passwordTextField              = [[UITextField alloc] init];
    
    _emailTextField.leftViewMode    = UITextFieldViewModeAlways;
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    _emailImageView                 = [UIImageView new];
    _passwordImageView              = [UIImageView new];
    _emailTextField.leftView        = _emailImageView;
    _passwordTextField.leftView     = _passwordImageView;
    
    _emailImageView.contentMode = UIViewContentModeCenter;
    _passwordImageView.contentMode = UIViewContentModeCenter;
    
    [self.view addSubview:_emailTextField];
    [self.view addSubview:_passwordTextField];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:_loginBtn];
    
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    self.navigationItem.leftBarButtonItem = item;
	// Do any additional setup after loading the view.
}
- (void ) dismiss
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void) viewWillLayoutSubviews
{
    _emailTextField.frame             = CGRectMake(10, 60 + 20, CGRectGetWidth(self.view.frame) - 20, 50);
    _emailTextField.leftView.frame    = CGRectMake(0, 0, 60, 44);
    _passwordTextField.frame          = CGRectOffset(_emailTextField.frame, 0, CGRectGetHeight(_emailTextField.frame) + 30);
    _passwordTextField.leftView.frame = CGRectMake(0, 0, 60, 44);
    _loginBtn.frame = CGRectOffset(_passwordTextField.frame, 0, CGRectGetHeight(_passwordTextField.frame) + 40);
}

- (void) viewDidLayoutSubviews
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DZThemeLoadCSS;
}
@end
