//
//  XMScanCodeFromPhotoLib.h
//  OriginAPIForQRScanner
//
//  Created by LiuMingchuan on 15/10/25.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XMScanCodeFromPhotoLib : NSObject

/**
 *  打开相册选取要是别的图片
 *
 *  @param viewController 当前的视图控制器
 */
- (void)decodeQRCode:(id)viewController;

/**
 *  获取扫描的结果
 *
 *  @param info 扫描返回的图片，取得结果
 *
 *  @return 扫描的结果
 */
- (NSString *)getDecodeStr:(NSDictionary<NSString *,id> *)info;

@end
