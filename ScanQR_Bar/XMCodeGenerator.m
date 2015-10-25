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

@end
