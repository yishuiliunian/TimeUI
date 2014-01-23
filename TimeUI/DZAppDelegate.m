//
//  DZAppDelegate.m
//  TimeUI
//
//  Created by Stone Dong on 13-11-12.
//  Copyright (c) 2013年 Stone Dong. All rights reserved.
//

#import "DZAppDelegate.h"
#import "DZDragViewController.h"
#import "DZAstirFrameViewController.h"
#import "DZAppConfigure.h"
#import "DZCenterButtonViewController.h"
#import "DZChartViewController.h"
#import "DZTypesViewController.h"
#import "DZTableViewController.h"
#import "DZNetworkManager.h"
#import "DZTokenManager.h"
#import "DZAccountManager.h"
#import "DZSyncOperation.h"
#import "DZShakeRecognizedWindow.h"
//
#import "DZLineChartViewController.h"
#import "DZChartsViewController.h"

#import "DZProgramDefines.h"
#import "DZMainViewController.h"


@interface DZAppDelegate () <DZRegisterAccountDelegate>
DEFINE_PROPERTY_ASSIGN_Float(hello);
DEFINE_PROPERTY_STRONG_UILabel(label);
@end

@implementation DZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    [DZAppConfigure initApp];
    self.window = [[DZShakeRecognizedWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    


//    self.window.rootViewController = dragVC;
    //
    DZTypesViewController* typesVC = [[DZTypesViewController alloc] init];
    
    DZLineChartViewController* lineChat1 = [[DZLineChartViewController alloc] init];
    DZLineChartViewController* lineChat2 = [[DZLineChartViewController alloc] init];
    DZLineChartViewController* lineChat3 = [[DZLineChartViewController alloc] init];

    DZChartsViewController* chartsVC = [[DZChartsViewController alloc] initWithChartControllers:@[lineChat1, lineChat2, lineChat3]];
    
    DZMainViewController* mainViewController = [[DZMainViewController alloc] init];
    mainViewController.chartsViewController = chartsVC;
    mainViewController.typesViewController = typesVC;
    self.window.rootViewController = mainViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    DZAccount* account = DZActiveAccount;
//    [DZRegisterAccountOperation runRegiserOperatioWithDelegate:self userEmail:account.email password:account.password];
    
    return YES;
}

- (void) registerAccountOperation:(DZRegisterAccountOperation *)op failedWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

- (void) registerAccountOperation:(DZRegisterAccountOperation *)op successWithUserInfo:(NSDictionary *)userInfo
{
    NSLog(@"register success");
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
