//
//  DZEditServerHostViewController.h
//  TimeUI
//
//  Created by stonedong on 14-3-30.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZEditServerHostViewController : UIViewController


@property (nonatomic, weak) IBOutlet UITextField* serverTextField;
@property (nonatomic, weak) IBOutlet UITextField* portField;
@property (nonatomic, weak) IBOutlet UILabel* serverHostLabel;

- (IBAction)textFiedValueChanged:(id)sender;

- (IBAction)loadDefaults:(id)sender;
- (IBAction)setServerAndPort:(id)sender;
@end
