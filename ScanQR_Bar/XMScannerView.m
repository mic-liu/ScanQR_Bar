//
//  XMScannerView.m
//  OriginAPIForQRScanner
//
//  Created by LiuMingchuan on 15/10/24.
//  Copyright © 2015年 LMC. All rights reserved.
//
#define LAYSER_ANIMATION_KEY @"layer_animation"
#import "XMScannerView.h"

@implementation XMScannerView
{
    //扫描识别区域
    CGRect outPutInterest;
    
    //扫描区域
    CGRect scanCropRect;
    
    //扫码类型
    ScanCodeType scanCodeType;
    
    //预览区域大小
    CGSize previewSize;
    
    //绘制预览maskview的各个点
    CGPoint p1,p2,p3,p4,p5,p6,p7,p8,p9;
    
    //扫描会话控制
    AVCaptureSession *session;
    
    //遮罩图层
    CAShapeLayer *maskViewLayer;
    
    //扫描动画
    CABasicAnimation *laserAnimation;
    
    //扫描动画图层
    CAShapeLayer *laserLayer;

}

/**
 *  初始化
 *
 *  @param cropRect 扫描识别区域
 *  @param codeType 扫码类型
 *  @param frame    预览视图框架
 *
 *  @return 试图实例
 */
- (UIView *)initWithScanCropRect:(CGRect)cropRect scanCodeType:(ScanCodeType)codeType frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        scanCropRect = cropRect;
        scanCodeType = codeType;
        previewSize = frame.size;
        [self makeCropViewMaskLayer];
        [self makeOutPutInterestRect];
    }
    return self;
}

/**
 *  开始扫描
 */
- (void)startScan {
//#if !TARGET_IPHONE_SIMULATOR
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self alertViewWithTitle:@"错误" message:@"😢未检测到可用相机😢" handler:nil];
        return;
    }
//#endif
    if (__IPHONE_OS_VERSION_MAX_ALLOWED<__IPHONE_7_0) {
        [self alertViewWithTitle:@"错误" message:@"😢手机版本过低😢\n需要7.0以上版本" handler:nil];

//        [self alertViewWithInfo:@"😢手机版本过低😢" handler:nil];
        return;
    }
    
#if !TARGET_IPHONE_SIMULATOR
    if (!session) {
        [self prepareForScan];
    }
    if (!session.isRunning) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [session startRunning];
        });
    }
#endif
    [self startScanAnination];
}

/**
 *  停止扫描
 */
- (void)stopScan {
    if (session) {
        [session stopRunning];
        [self stopScanAnimation];
    }
}

/**
 *  创建扫描区透视区
 */
- (void)makeCropViewMaskLayer {
    /**
     *  下面是设定绘制maskview的各个点
     */
    p1 = CGPointZero;
    p2 = CGPointMake(previewSize.width, 0);
    p3 = CGPointMake(previewSize.width, previewSize.height);
    p4 = CGPointMake(0, previewSize.height);
    p5 = CGPointMake(0, scanCropRect.origin.y+scanCropRect.size.height);
    p6 = CGPointMake(scanCropRect.origin.x, p5.y);
    p7 = CGPointMake(scanCropRect.origin.x+scanCropRect.size.width, p6.y);
    p8 = CGPointMake(p7.x, scanCropRect.origin.y);
    p9 = scanCropRect.origin;
    
    /**
     *  绘制maskview
     */
    UIBezierPath *maskViewPath = [UIBezierPath bezierPath];
    [maskViewPath moveToPoint:p1];
    [maskViewPath addLineToPoint:p2];
    [maskViewPath addLineToPoint:p3];
    [maskViewPath addLineToPoint:p4];
    [maskViewPath addLineToPoint:p5];
    [maskViewPath addLineToPoint:p6];
    [maskViewPath addLineToPoint:p7];
    [maskViewPath addLineToPoint:p8];
    [maskViewPath addLineToPoint:p9];
    [maskViewPath addLineToPoint:p6];
    [maskViewPath addLineToPoint:p5];
    [maskViewPath closePath];
    maskViewLayer = [CAShapeLayer layer];
    maskViewLayer.frame = self.bounds;
    maskViewLayer.path = maskViewPath.CGPath;
    maskViewLayer.fillColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.7].CGColor;
    //添加到scannerview的layer中
    [self.layer insertSublayer:maskViewLayer atIndex:0];
    
    /**
     *  边角
     */
    CGFloat cornerLineLength = 15;
    UIBezierPath *cornerPath = [UIBezierPath bezierPath];
    [cornerPath moveToPoint:CGPointMake(p9.x, p9.y+cornerLineLength)];
    [cornerPath addLineToPoint:p9];
    [cornerPath addLineToPoint:CGPointMake(p9.x+cornerLineLength, p9.y)];
    
    [cornerPath moveToPoint:CGPointMake(p8.x, p8.y+cornerLineLength)];
    [cornerPath addLineToPoint:p8];
    [cornerPath addLineToPoint:CGPointMake(p8.x-cornerLineLength, p8.y)];
    
    [cornerPath moveToPoint:CGPointMake(p7.x, p7.y-cornerLineLength)];
    [cornerPath addLineToPoint:p7];
    [cornerPath addLineToPoint:CGPointMake(p7.x-cornerLineLength, p7.y)];
    
    [cornerPath moveToPoint:CGPointMake(p6.x, p6.y-cornerLineLength)];
    [cornerPath addLineToPoint:p6];
    [cornerPath addLineToPoint:CGPointMake(p6.x+cornerLineLength, p6.y)];
    
    UIBezierPath *linerPath = [UIBezierPath bezierPath];
    [linerPath moveToPoint:p6];
    [linerPath addLineToPoint:p7];
    [linerPath addLineToPoint:p8];
    [linerPath addLineToPoint:p9];
    [linerPath closePath];
    CGFloat innerLine = 8;
    CGPoint p9_1 = CGPointMake(p9.x+innerLine, p9.y+innerLine);
    [linerPath moveToPoint:CGPointMake(p9_1.x, p9_1.y+cornerLineLength)];
    [linerPath addLineToPoint:p9_1];
    [linerPath addLineToPoint:CGPointMake(p9_1.x+cornerLineLength, p9_1.y)];
    CGPoint p8_1 = CGPointMake(p8.x-innerLine, p8.y+innerLine);
    [linerPath moveToPoint:CGPointMake(p8_1.x, p8_1.y+cornerLineLength)];
    [linerPath addLineToPoint:p8_1];
    [linerPath addLineToPoint:CGPointMake(p8_1.x-cornerLineLength, p8_1.y)];
    CGPoint p7_1 = CGPointMake(p7.x-innerLine, p7.y-innerLine);
    [linerPath moveToPoint:CGPointMake(p7_1.x, p7_1.y-cornerLineLength)];
    [linerPath addLineToPoint:p7_1];
    [linerPath addLineToPoint:CGPointMake(p7_1.x-cornerLineLength, p7_1.y)];
    CGPoint p6_1 = CGPointMake(p6.x+innerLine, p6.y-innerLine);
    [linerPath moveToPoint:CGPointMake(p6_1.x, p6_1.y-cornerLineLength)];
    [linerPath addLineToPoint:p6_1];
    [linerPath addLineToPoint:CGPointMake(p6_1.x+cornerLineLength, p6_1.y)];
    
    CAShapeLayer *linerLayer = [CAShapeLayer layer];
    linerLayer.path = linerPath.CGPath;
    linerLayer.fillColor = [UIColor clearColor].CGColor;
    linerLayer.strokeColor = [UIColor greenColor].CGColor;
    linerLayer.lineWidth = 1;
    
    CAShapeLayer *cornerLayer = [CAShapeLayer layer];
    cornerLayer.path = cornerPath.CGPath;
    cornerLayer.fillColor = [UIColor clearColor].CGColor;
    cornerLayer.strokeColor = [UIColor whiteColor].CGColor;
    cornerLayer.lineWidth = 4;
    [maskViewLayer insertSublayer:linerLayer atIndex:0];
    [maskViewLayer insertSublayer:cornerLayer atIndex:1];
    
    UIBezierPath *laserPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, scanCropRect.size.width, 4)];
    laserLayer = [CAShapeLayer layer];
    laserLayer.frame = CGRectMake(p9.x, p9.y, scanCropRect.size.width, 4);
    laserLayer.path = laserPath.CGPath;
    laserLayer.fillColor = [UIColor yellowColor].CGColor;
    laserLayer.hidden = YES;
    
    [maskViewLayer insertSublayer:laserLayer atIndex:0];
    
    //扫描动画做成
    laserAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    laserAnimation.duration = 1.5;
    laserAnimation.repeatCount = MAXFLOAT;
    laserAnimation.fromValue = [NSValue valueWithCGPoint:laserLayer.position];
    laserAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(laserLayer.position.x, p6.y)];
    laserAnimation.autoreverses = YES;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didApplicationEnterBackGround) name:UIApplicationDidEnterBackgroundNotification object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(willApplicationEdterForeground) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
}

/**
 *  开始扫描动画
 */
- (void)startScanAnination {
    if (laserLayer) {
        [laserLayer addAnimation:laserAnimation forKey:LAYSER_ANIMATION_KEY];
        laserLayer.hidden = NO;
    }
}

/**
 *  结束扫描动画
 */
- (void)stopScanAnimation {
    if (laserLayer) {
        [laserLayer removeAnimationForKey:LAYSER_ANIMATION_KEY];
        laserLayer.hidden = YES;
    }
}

/**
 *  计算扫描区域
 */
- (void)makeOutPutInterestRect {
    /**
     *  下面是计算设备可以感知扫描的区域
     */
    //scannerview高宽比
    CGFloat rate1 = previewSize.height/previewSize.width;
    //扫描使用1920*1080高清模式，模式的高宽比
    CGFloat rate2 = 1920.0/1080.0;
    
    if (rate1 < rate2) {
        //设备实际扫描的高度
        CGFloat fixHeight = previewSize.width*rate2;
        //设备扫描高度高度出了屏幕，这是高度的一个偏移量，上下偏移量相等
        CGFloat fixPadding = (fixHeight-previewSize.height)/2;
        //计算scanner的扫描区域
        outPutInterest = CGRectMake((scanCropRect.origin.y+fixPadding)/fixHeight, scanCropRect.origin.x/previewSize.width, scanCropRect.size.height/previewSize.height, scanCropRect.size.width/previewSize.width);
    } else {
        //设备实际扫描的宽度
        CGFloat fixWidth = previewSize.height/rate2;
        //设备扫描宽度长出了屏幕，这是宽度的一个偏移量，左右偏移量相等
        CGFloat fixPadding = (fixWidth-previewSize.width)/2;
        //计算scanner的扫描范围
        outPutInterest = CGRectMake(scanCropRect.origin.y/previewSize.height, (scanCropRect.origin.x+fixPadding)/fixWidth, scanCropRect.size.height/previewSize.height, scanCropRect.size.width/previewSize.width);
    }
}

/**
 *  提示信息用弹出框
 *
 *  @param info 提示信息
 */
- (void)alertViewWithTitle:(NSString *)titile message:(NSString *)message handler:(void (^ __nullable)(UIAlertAction *action))handler {
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:titile message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:handler];
    [alertCtrl addAction:okAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self getSelfVC] presentViewController:alertCtrl animated:YES completion:nil];
    });
    
}

/**
 *  获取视图所在的视图控制器
 *
 *  @return 视图控制器
 */
- (UIViewController*)getSelfVC {
    id selfViewController = self;
    while (selfViewController) {
        selfViewController = ((UIResponder*)selfViewController).nextResponder;
        if ([selfViewController isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return selfViewController;
}

/**
 *  扫描的准备事项
 */
- (void)prepareForScan {
    //设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //输入
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //元数据输出
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    //元数据代理设定
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //扫描控制
    session = [[AVCaptureSession alloc]init];
    //设定扫描清晰度为1920*1080
    [session setSessionPreset:AVCaptureSessionPreset1920x1080];
    //扫描控制添加输入
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    //扫描控制添加输出
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    //设定元数据扫描感知的范围
    [output setRectOfInterest:outPutInterest];
    //设定感知二维码扫描
    if (scanCodeType == XMCodeTypeQRCode) {
        [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    } else {
        //设定感知条形码扫描
        [output setMetadataObjectTypes:@[AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeEAN13Code]];
    }
    //扫描预览图层
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //设定预览的框架为当前视图的边界
    previewLayer.frame = self.bounds;
    //将预览图层添加到当前视图
    [self.layer insertSublayer:previewLayer atIndex:0];
}

/**
 *  扫描完成代理实现
 *
 *  @param captureOutput   输出
 *  @param metadataObjects 元数据
 *  @param connection      连接
 */
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if ([metadataObjects count]>0) {
        [self stopScan];
        AVMetadataMachineReadableCodeObject *data = [metadataObjects objectAtIndex:0];
        NSString *scanResult = data.stringValue;
        [self alertViewWithTitle:@"扫描结果" message:scanResult handler:^(UIAlertAction *action) {
            [self startScan];
        }];
    }
}

/**
 *  程序进入后台停止动画 停止扫描
 */
- (void)didApplicationEnterBackGround {
    [laserLayer removeAnimationForKey:@"LaserAnimation"];
    if (session) {
        [session stopRunning];
    }
}

/**
 *  程序进去前台开始动画 开始扫描
 */
- (void)willApplicationEdterForeground {
    [laserLayer addAnimation:laserAnimation forKey:@"LaserAnimation"];
    if (session) {
        [session startRunning];
    }
}
@end
