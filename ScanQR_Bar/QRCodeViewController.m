//
//  QRCodeViewController.m
//  ScanQR_Bar
//
//  Created by LiuMingchuan on 15/10/25.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import "QRCodeViewController.h"
#import "XMScannerView.h"

@interface QRCodeViewController (){
    XMScannerView *qrScannerView;
}

@end

@implementation QRCodeViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [qrScannerView startScan];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [qrScannerView stopScan];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize size = self.view.frame.size;
    CGSize cropSize = CGSizeMake(200, 200);
    qrScannerView = [[XMScannerView alloc]initWithScanCropRect:CGRectMake((size.width-cropSize.width)/2, 128, cropSize.width, cropSize.height) scanCodeType:XMCodeTypeQRCode frame:self.view.bounds];
    [self.view addSubview:qrScannerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
