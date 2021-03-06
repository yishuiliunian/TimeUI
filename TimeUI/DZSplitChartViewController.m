//
//  DZSplitChartViewController.m
//  TimeUI
//
//  Created by stonedong on 14-6-18.
//  Copyright (c) 2014年 Stone Dong. All rights reserved.
//

#import "DZSplitChartViewController.h"
#import "DZ24Analysis.h"
#import "DZChartNode.h"
#import <ShareSDK/ShareSDK.h>
#import "DZLocalNotificationCenter.h"

static NSString* const kBTTileCancel = @"取消";
static NSString* const kBTTileCamera = @"拍照";
static NSString* const kBTTileScrolls  = @"从相册选择";


@interface DZSplitChartViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UILabel* _avatarHolderLabel;
}
@end

@implementation DZSplitChartViewController
@synthesize splitChartView = _splitChartView;
- (DZSplitChartView*) splitChartView
{
    if (!_splitChartView) {
        _splitChartView = [[DZSplitChartView alloc] initWithFrame:CGRectLoadViewFrame];
    }
    return _splitChartView;
}

- (void) loadView
{
    self.view = self.splitChartView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) longPressHandle:(UITapGestureRecognizer*)longPR
{
    if (longPR.state == UIGestureRecognizerStateRecognized) {
        UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"选择头像"
                                                           delegate:self
                                                  cancelButtonTitle:kBTTileCancel destructiveButtonTitle:nil otherButtonTitles:kBTTileCamera,kBTTileScrolls, nil];
        [sheet showInView:self.view];
        
        _splitChartView.avatarHolderLabel.hidden = YES;
    }
}


- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString* buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    void(^ShowPicker)(UIImagePickerControllerSourceType) = ^(UIImagePickerControllerSourceType type) {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = type;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    };
    
    if ([buttonTitle isEqualToString:kBTTileScrolls]) {
        ShowPicker(UIImagePickerControllerSourceTypePhotoLibrary);
    } else if ([buttonTitle isEqualToString:kBTTileCamera]) {
        ShowPicker(UIImagePickerControllerSourceTypeCamera);
    }
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = info[UIImagePickerControllerOriginalImage];
    self.splitChartView.avatarImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.splitChartView.avatarImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* tapPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandle:)];
    tapPress.numberOfTapsRequired = 1;
    [self.splitChartView.avatarImageView addGestureRecognizer:tapPress];
    
    
    NSArray* array = [DZ24Analysis chartNodes];
    for (DZChartNode* node  in array) {
        [self.splitChartView addChartNode:node];
    }
    // Do any additional setup after loading the view.
    
//    
//    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareCurrent)];
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    //
    
}
- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}
- (void) dismiss
{
    [self.pdSuperViewController pdPopViewControllerAnimated:YES completion:^{
        
    }];
}
- (void) shareCurrent
{
    CGSize size = self.splitChartView.contentSize;
    size.width *= 2;
    size.height *=2;
    UIGraphicsBeginImageContext(self.splitChartView.contentSize);
    [self.splitChartView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK share:SSDKPlatformTypeQQ parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            
        }];
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
