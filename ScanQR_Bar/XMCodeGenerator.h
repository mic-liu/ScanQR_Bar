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
@end
