//
//  DZEditTimeSegemntViewController.m
//  TimeUI
//
//  Created by Stone Dong on 14-2-14.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZEditTimeSegemntViewController.h"
#import "DZTime.h"
@interface DZEditTimeSegemntViewController ()

@end

@implementation DZEditTimeSegemntViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadView
{
    NSArray* array =[DZActiveTimeDataBase allTimes];
    DZTime* time = array.firstObject;
    float max = 0;
    for (DZTime* each  in array) {
        if (ABS([each.dateBegin timeIntervalSinceDate:each.dateEnd]) > max ) {
            max = ABS([each.dateBegin timeIntervalSinceDate:each.dateEnd]);
            time = each;
        }
    }
    _editSegmentView = [[DZEditTimeSegmentView alloc] initWithTime:time];
    _editSegmentView.backgroundColor = [UIColor whiteColor];
    self.view = _editSegmentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
