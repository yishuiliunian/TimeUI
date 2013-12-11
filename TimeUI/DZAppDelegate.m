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
@implementation DZAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DZAppConfigure initApp];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    DZDragViewController* dragVC = [[DZDragViewController alloc] init];
    
    DZAstirFrameViewController* v1 = [DZAstirFrameViewController new];
    v1.view.backgroundColor = [UIColor redColor];
    
    UIViewController* v2 = [UIViewController new];
    v2.view.backgroundColor = [UIColor blueColor];
    
    UIViewController* v3 = [UIViewController new];
    v3.view.backgroundColor = [UIColor greenColor];
    
    dragVC.topViewController = v2;
    dragVC.bottomViewController = [DZChartViewController new];
    dragVC.centerViewController = [[DZCenterButtonViewController alloc] init];
    self.window.rootViewController = dragVC;
    //
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
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
