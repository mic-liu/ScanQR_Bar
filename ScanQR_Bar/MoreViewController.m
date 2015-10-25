//
//  MoreViewController.m
//  ScanQR_Bar
//
//  Created by LiuMingchuan on 15/10/25.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import "MoreViewController.h"
#import "XMCodeGenerator.h"
#import "XMScanCodeFromPhotoLib.h"

@interface MoreViewController (){
    UIImageView *imgView;
    UITextView *txtView;
    UILabel *lblPlaceHolder;
    UIButton *btnOne;
    UIButton *btnTwo;
    UIButton *btnThree;
    XMCodeGenerator *codeGenerator;
    XMScanCodeFromPhotoLib *scanCodeFromPhotoLib;
}

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    dispatch_async(dispatch_get_main_queue(), ^{
        imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        imgView.center = CGPointMake(self.view.center.x, 214);
        imgView.layer.cornerRadius = 10;
        imgView.layer.borderColor = [UIColor blackColor].CGColor;
        imgView.layer.borderWidth = 1;
        [self.view addSubview:imgView];
        
        txtView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 300, 50)];
        txtView.delegate = self;
        txtView.center = CGPointMake(imgView.center.x, imgView.center.y+200/2+100/2+20);
        txtView.layer.borderColor = [UIColor blackColor].CGColor;
        txtView.layer.borderWidth = 1;
        txtView.layer.cornerRadius = 10;
        [self.view addSubview:txtView];
        lblPlaceHolder = [[UILabel alloc]initWithFrame:txtView.bounds];
        [txtView addSubview:lblPlaceHolder];
        lblPlaceHolder.enabled = NO;
        lblPlaceHolder.text = @"输入生成信息/输出扫描信息";
        lblPlaceHolder.textAlignment = NSTextAlignmentCenter;
        lblPlaceHolder.textColor = [UIColor grayColor];
        
        btnOne = [UIButton buttonWithType:UIButtonTypeSystem];
        [btnOne addTarget:self action:@selector(createQR) forControlEvents:UIControlEventTouchUpInside];
        [btnOne setTitle:@"生成二维码" forState:UIControlStateNormal];
        btnOne.frame = CGRectMake(0, 0, 200, 30);
        btnOne.center = CGPointMake(self.view.center.x, txtView.center.y+50+20+15);
        [self.view addSubview:btnOne];
        
        btnTwo = [UIButton buttonWithType:UIButtonTypeSystem];
        [btnTwo addTarget:self action:@selector(createBar) forControlEvents:UIControlEventTouchUpInside];
        [btnTwo setTitle:@"生成条形码" forState:UIControlStateNormal];
        btnTwo.frame = CGRectMake(0, 0, 200, 30);
        btnTwo.center = CGPointMake(self.view.center.x, btnOne.center.y+15+20);
        [self.view addSubview:btnTwo];

        btnThree = [UIButton buttonWithType:UIButtonTypeSystem];
        [btnThree addTarget:self action:@selector(scanQRFromPhotoLib) forControlEvents:UIControlEventTouchUpInside];
        [btnThree setTitle:@"扫描相册二维码" forState:UIControlStateNormal];
        btnThree.frame = CGRectMake(0, 0, 200, 30);
        btnThree.center = CGPointMake(self.view.center.x, btnTwo.center.y+15+20);
        [self.view addSubview:btnThree];
        
        codeGenerator = [[XMCodeGenerator alloc]init];
        scanCodeFromPhotoLib = [[XMScanCodeFromPhotoLib alloc]init];
    });
    
}

- (void) createQR {
    NSString *str = txtView.text;
    if (![str isEqualToString:@""]) {
        imgView.layer.cornerRadius = 10;
        imgView.bounds = CGRectMake(0, 0, imgView.bounds.size.width, imgView.bounds.size.width);
        imgView.image = [codeGenerator generateQRCodeImage:str withWidth:imgView.bounds.size.width];
    }
}

- (void) createBar {
    NSString *str = txtView.text;
    if (![str isEqualToString:@""]) {
        imgView.layer.cornerRadius = 0;
        imgView.bounds = CGRectMake(0, 0, imgView.bounds.size.width, imgView.bounds.size.width/2);
        imgView.center = imgView.center;
        imgView.image = [codeGenerator generateBarCodeImage:str withSize:CGSizeMake(imgView.bounds.size.width, imgView.bounds.size.width/2)];
    }
}

- (void) scanQRFromPhotoLib {
    [scanCodeFromPhotoLib decodeQRCode:self];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    lblPlaceHolder.text = @"";
    txtView.text = [scanCodeFromPhotoLib getDecodeStr:info];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        lblPlaceHolder.text = @"输入生成信息/输出扫描信息";
    } else {
        lblPlaceHolder.text = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
