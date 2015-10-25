//
//  MainViewController.m
//  ScanQR_Bar
//
//  Created by LiuMingchuan on 15/10/25.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.title = @"二维码扫描";
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    switch (tabBarController.selectedIndex) {
        case 0:
            self.title = @"二维码扫描";
            break;
        case 1:
            self.title = @"条形码扫描";
            break;
        case 2:
            self.title = @"生成器";
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
