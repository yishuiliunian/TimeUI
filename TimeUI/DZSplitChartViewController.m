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
    tapPress.numberOfTapsRequired = 2;
    [self.splitChartView.avatarImageView addGestureRecognizer:tapPress];
    
    
    NSArray* array = [DZ24Analysis chartNodes];
    for (DZChartNode* node  in array) {
        [self.splitChartView addChartNode:node];
    }
    // Do any additional setup after loading the view.
    
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareCurrent)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
}

- (void) dismiss
{
    [self.pdSuperViewController popViewControllerAnimated:YES];
}
- (void) shareCurrent
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    id<ISSContent> publishContent = [ShareSDK content:@"时间都去哪儿了？时间猎手，捕获时间，抓住那些匆匆溜走的岁月。"
                                       defaultContent:@"时间都去哪儿了？时间猎手，捕获时间，抓住那些匆匆溜走的岁月。"
                                                image:[ShareSDK pngImageWithImage:image]
                                                title:@"分享自时间猎手" url:@"www.baidu.com" description:@"" mediaType:SSPublishContentMediaTypeNews];
    
   
    
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:nil arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:NSLocalizedString(@"TEXT_SHARE_TITLE", @"内容分享")
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:nil
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSString* s = [NSString stringWithFormat:@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]];
                                    NSLog(@"%@",s);
                                }
                            }];

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
