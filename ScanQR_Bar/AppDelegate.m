//
//  AppDelegate.m
//  ScanQR_Bar
//
//  Created by LiuMingchuan on 15/10/25.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "QRCodeViewController.h"
#import "BarCodeViewController.h"
#import "MoreViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    QRCodeViewController *qrVC = [[QRCodeViewController alloc]init];
    qrVC.tabBarItem.title = @"二维码";
    qrVC.tabBarItem.image = [[UIImage imageNamed:@"qr_code"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    BarCodeViewController *barVC = [[BarCodeViewController alloc]init];
    barVC.tabBarItem.title = @"条形码";
    barVC.tabBarItem.image = [[UIImage imageNamed:@"bar_code"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    MoreViewController *moreVC = [[MoreViewController alloc]init];
    moreVC.tabBarItem .title = @"更多";
    moreVC.tabBarItem.image = [[UIImage imageNamed:@"more"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    MainViewController *mainTabVC = [[MainViewController alloc]init];
    mainTabVC.tabBar.tintColor = [UIColor brownColor];
    mainTabVC.viewControllers = @[qrVC,barVC,moreVC];
    UINavigationController *rootVC = [[UINavigationController alloc]initWithRootViewController:mainTabVC];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
