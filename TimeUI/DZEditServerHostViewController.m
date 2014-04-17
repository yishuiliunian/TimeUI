//
//  DZEditServerHostViewController.m
//  TimeUI
//
//  Created by stonedong on 14-3-30.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZEditServerHostViewController.h"

@interface DZEditServerHostViewController () <UITextFieldDelegate>

@end

@implementation DZEditServerHostViewController

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
    self.serverTextField.text = [DZGlobalSettingsShareManager serverHost];
    self.portField.text = [DZGlobalSettingsShareManager serverPort];
    
    self.serverHostLabel.text = DZServerHost;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textFiedValueChanged:(id)sender
{
    NSString* serverText = self.serverTextField.text;
    NSString* portText = self.portField.text;
    self.serverHostLabel.text = DZServerWithHostAndPort(serverText, portText);
}

- (IBAction)loadDefaults:(id)sender
{
    self.serverTextField.text = kDZDefaultServerHost;
    self.portField.text = kDZDefaultServerPort;

    self.serverHostLabel.text = DZServerWithHostAndPort(kDZDefaultServerHost, kDZDefaultServerPort);
}
- (IBAction)setServerAndPort:(id)sender
{
    NSString* serverText = self.serverTextField.text;
    NSString* portText = self.portField.text;
    [DZGlobalSettingsShareManager setServerHost:serverText];
    [DZGlobalSettingsShareManager setServerPort:portText];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
