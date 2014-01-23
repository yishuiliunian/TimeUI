//
//  DZChartsViewController.m
//  TimeUI
//
//  Created by Stone Dong on 14-1-20.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZChartsViewController.h"
#import "DZTimeControl.h"
#import "DZNumberLabel.h"



@interface DZChartsViewController ()
{
    DZTimeControl* _timeControl;
    DZNumberLabel* _numberLabel;
}
@end

@implementation DZChartsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) loadViewCSS:(id)cssValue forKey:(NSString *)key
{
    if ([key isEqualToString:@"time_drag_bg"]) {
        _timeControl.dragBackgroundImageView.backgroundColor = [UIColor colorWithPatternImage:cssValue];
    }
    else if ([key isEqualToString:@"time_drag_item"])
    {
        _timeControl.dragItemImageView.image = cssValue;
    }
    else if ([key isEqualToString:@"control_bg"])
    {
        UIImage* image = cssValue;
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
        _timeControl.labelsBackgroundImageView.image = image;
    } else if ([key isEqualToString:@"time_bottom"])
    {
        _timeControl.bottomLabel.font = cssValue;
    }
    else if ([key isEqualToString:@"type_size"])
    {
        _timeControl.typeLabel.font = cssValue;
    }
    else if ([key isEqualToString:@"time_bottom_color"])
    {
        _timeControl.bottomLabel.textColor = cssValue;
    }
}

- (void) loadControls
{
    _timeControl = [DZTimeControl new];
    [self.view addSubview:_timeControl];
    
    _numberLabel = [DZNumberLabel new];
    [self.view addSubview:_numberLabel];
    _timeControl.bottomLabel.text = NSLocalizedString(@"Click Save", nil);
    _timeControl.bottomLabel.textAlignment = NSTextAlignmentCenter;
    _timeControl.bottomLabel.textColor = [UIColor blueColor];
    _timeControl.typeLabel.textAlignment = NSTextAlignmentRight;
    _timeControl.typeLabel.text = @"睡大觉";
}

- (void) viewWillLayoutSubviews
{
    _timeControl.frame = CGRectMake(0, 20, CGRectVCWidth, 150);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadControls];
    
	// Do any additional setup after loading the view.
}
- (void) handleSet
{
    static int  i = 0;
    _numberLabel.number = i++ %9;
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(handleSet) userInfo:nil  repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
