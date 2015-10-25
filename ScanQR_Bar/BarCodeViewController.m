//
//  BarCodeViewController.m
//  ScanQR_Bar
//
//  Created by LiuMingchuan on 15/10/25.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import "BarCodeViewController.h"
#import "XMScannerView.h"

@interface BarCodeViewController (){
    XMScannerView *barScannerView;
}

@end

@implementation BarCodeViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [barScannerView startScan];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [barScannerView stopScan];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize size = self.view.frame.size;
    CGSize cropSize = CGSizeMake(250, 150);
    barScannerView = [[XMScannerView alloc]initWithScanCropRect:CGRectMake((size.width-cropSize.width)/2, 160, cropSize.width, cropSize.height) scanCodeType:XMCodeTypeBarCode frame:self.view.bounds];
    [self.view addSubview:barScannerView];
    [barScannerView startScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
