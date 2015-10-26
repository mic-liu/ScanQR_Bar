//
//  XMCodeGenerator.h
//  OriginAPIForQRScanner
//
//  Created by LiuMingchuan on 15/10/24.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 筛选器类型
 */
typedef enum {
    XMQRCodeFilter = 0
    ,XMBarCodeFilter
}XMFilterType;
static NSArray *typeArray;
#define XMFilterTypeArray (typeArray == nil ? typeArray = [[NSArray alloc]initWithObjects:@"CIQRCodeGenerator",@"CICode128BarcodeGenerator",nil] : typeArray)
//使用筛选器类型获取类型字符串
#define XMLFilterTypeStr(type) ([XMFilterTypeArray objectAtIndex:type])

@interface XMCodeGenerator : NSObject<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/**
 *  生成二维码图像
 *
 *  @param str   需要转换的字符串
 *  @param width 生成图像的宽度
 *
 *  @return 生成的二维码图像
 */
- (UIImage *)generateQRCodeImage:(NSString *)str withWidth:(CGFloat)width;

/**
 *  生成条形码图片
 *
 *  @param str   需要生成图片的内容
 *  @param size  条形码大小
 *
 *  @return 生成的条形码图像
 */
- (UIImage *)generateBarCodeImage:(NSString *)str withSize:(CGSize)size;

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
- (UIImage *)generateQRCodeImage:(NSString *)str withWidth:(CGFloat)width colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

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
- (UIImage *)generateBarCodeImage:(NSString *)str withSize:(CGSize)size colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
@end
