//
//  XMCodeGenerator.m
//  OriginAPIForQRScanner
//
//  Created by LiuMingchuan on 15/10/24.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import "XMCodeGenerator.h"

@implementation XMCodeGenerator

/**
 *  生成二维码图片
 *
 *  @param str   需要生成图片的内容
 *  @param width 二维码的宽度
 *
 *  @return 二维码图片
 */
- (UIImage *)generateQRCodeImage:(NSString *)str withWidth:(CGFloat)width{
    if (__IPHONE_OS_VERSION_MAX_ALLOWED<__IPHONE_8_0) {
        return [UIImage imageNamed:@"icon"];
    }
    return [self convertCIImageToUIImage:[self createCIImageForStr:str codeType:XMQRCodeFilter] withSize:CGSizeMake(width, width)];
}

/**
 *  生成条形码图片
 *
 *  @param str   需要生成图片的内容
 *  @param size  条形码大小
 *
 *  @return 条形码
 */
- (UIImage *)generateBarCodeImage:(NSString *)str withSize:(CGSize)size {
    if (__IPHONE_OS_VERSION_MAX_ALLOWED<__IPHONE_8_0) {
        return [UIImage imageNamed:@"icon"];
    }
    return [self convertCIImageToUIImage:[self createCIImageForStr:str codeType:XMBarCodeFilter] withSize:size];
}

/**
 *  根据内容生成CIImage
 *
 *  @param str 需要生成图片的内容
 *
 *  @return CIImage
 */
- (CIImage *)createCIImageForStr:(NSString *)str codeType:(XMFilterType)type{
    NSData *strData = [str dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:XMLFilterTypeStr(type)];
    
    //设置内容
    [filter setValue:strData forKey:@"inputMessage"];
    //纠错级别
    if (type == 0) {
        [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    } else if (type == 1) {
        [filter setValue:@"M" forKey:@"inputQuietSpace"];
    }
    
    
    
    return filter.outputImage;
}

/**
 *  将CIImage转换为UIImage
 *
 *  @param qrCIImage CIImage
 *  @param width     宽度
 *
 *  @return UIImage
 */
- (UIImage *)convertCIImageToUIImage:(CIImage *)qrCIImage withSize:(CGSize)size{
    CGRect area = CGRectIntegral(qrCIImage.extent);
    CGFloat scale = MIN(size.width/CGRectGetWidth(area), size.height/CGRectGetHeight(area));
    size_t w = CGRectGetWidth(area)*scale;
    size_t h = CGRectGetHeight(area)*scale;
    
    CGColorSpaceRef csRef = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, w, h, 8, 0, csRef, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [ciContext createCGImage:qrCIImage fromRect:area];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, area, bitmapImage);
    
    CGImageRef image = CGBitmapContextCreateImage(bitmapRef);
    CGColorSpaceRelease(csRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [[UIImage imageWithCGImage:image] copy];
}

/**
 *  绘制指定颜色的二维码
 *
 *  @param str   内容
 *  @param width 宽度
 *  @param red   红 0-255
 *  @param green 绿 0-255
 *  @param blue  蓝 0-255
 *
 *  @return 图片
 */
-(UIImage *)generateQRCodeImage:(NSString *)str withWidth:(CGFloat)width colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    return [self makeCustomColorImage:[self generateQRCodeImage:str withWidth:width] withRed:red andGreen:green andBlue:blue];
}

/**
 *  绘制指定颜色的条形码
 *
 *  @param str   内容
 *  @param size  大小
 *  @param red   红 0-255
 *  @param green 绿 0-255
 *  @param blue  蓝 0-255
 *
 *  @return 图片
 */
- (UIImage *)generateBarCodeImage:(NSString *)str withSize:(CGSize)size colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    return [self makeCustomColorImage:[self generateBarCodeImage:str withSize:size] withRed:red andGreen:green andBlue:blue];
}


/**
 *  释放容纳图片的内存空间
 */
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

/**
 *  将生成的图片转为自定义的颜色
 *
 *  @param image 要转换的图片
 *  @param red   红 0-255
 *  @param green 绿 0-255
 *  @param blue  蓝 0-255
 *
 *  @return 自定义颜色的图片
 */
- (UIImage*)makeCustomColorImage:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    //横、纵像素数
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    //每一行像素点占用字节数，每个像素点的ARGB四个通道各占8个bit（0-255）的空间
    size_t bytesPerRow = imageWidth * 4;
    //整张图片占用字节数
    size_t bytesImage = bytesPerRow *imageHeight;
    //分配足够空间容纳图片
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesImage);
    //创建依赖于设备的RBG通道
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //创建CoreGraphic的图形上下文，描述了rgbImageBuf指向内存空间需要绘制的图像的一些绘制参数
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    //将图片rgbImageBuf绘制到指定的上下文
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0xCCCCCC00){
            // 转换成自定义的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;//0~255
            ptr[1] = blue;//0~255
        } else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;//背景透明
        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

@end
