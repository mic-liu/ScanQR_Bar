//
//  XMScanCodeFromPhotoLib.m
//  OriginAPIForQRScanner
//
//  Created by LiuMingchuan on 15/10/25.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import "XMScanCodeFromPhotoLib.h"

@implementation XMScanCodeFromPhotoLib {
    UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate> *viewCtrl;
    CIDetector *detector;
}

/**
 *  打开相册选取要是别的图片
 *
 *  @param viewController 当前的视图控制器
 */
-(void)decodeQRCode:(UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate> *)viewController {
    viewCtrl = (UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate> *)viewController;
    detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImagePickerController *pickerVC = [[UIImagePickerController alloc]init];
            pickerVC.delegate = viewCtrl;
            pickerVC.allowsEditing = NO;
            [viewCtrl presentViewController:pickerVC animated:YES completion:nil];
        });
    }
}

/**
 *  获取扫描的结果
 *
 *  @param info 扫描返回的图片，取得结果
 *
 *  @return 扫描的结果
 */
-(NSString *)getDecodeStr:(NSDictionary<NSString *,id> *)info {
    [viewCtrl dismissViewControllerAnimated:YES completion:nil];
    UIImage *img =  [info objectForKey:UIImagePickerControllerOriginalImage];
    CIImage *cimg = [CIImage imageWithCGImage:img.CGImage];
    NSMutableString *mutStr = [[NSMutableString alloc]init];
    for (CIQRCodeFeature *feature in [detector featuresInImage:cimg]) {
        [mutStr appendString:feature.messageString];
    }
    if (![mutStr isEqualToString:@""]) {
        return mutStr;
    }
    return @"";
}
@end
