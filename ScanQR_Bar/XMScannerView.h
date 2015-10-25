//
//  XMScannerView.h
//  OriginAPIForQRScanner
//
//  Created by LiuMingchuan on 15/10/24.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
/**
 *  扫码类型
 */
typedef enum{
    XMCodeTypeQRCode = 0x1001//二维码
    ,XMCodeTypeBarCode = 0x1002//条形码
}ScanCodeType;

@interface XMScannerView : UIView<AVCaptureMetadataOutputObjectsDelegate>

/**
 *  初始化
 *
 *  @param cropRect 扫描识别区域
 *  @param codeType 扫码类型
 *  @param frame    预览视图框架
 *
 *  @return 试图实例
 */
- (UIView *)initWithScanCropRect:(CGRect)cropRect scanCodeType:(ScanCodeType)codeType frame:(CGRect)frame;

/**
 *  开始扫描
 */
- (void)startScan;

/**
 *  停止扫描
 */
- (void)stopScan;

@end
