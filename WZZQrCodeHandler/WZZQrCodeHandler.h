//
//  WZZQrCodeHandler.h
//  fff3
//
//  Created by 王泽众 on 2018/3/28.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface WZZQrCodeHandler : NSObject

/**
 转换二维码

 @param string 文本
 @return 二维码
 */
+ (UIImage *)qrCodeWithString:(NSString *)string;

/**
 转换二维码

 @param string 文本
 @param logo 图标
 @return 二维码
 */
+ (UIImage *)qrCodeWithString:(NSString *)string
                         logo:(UIImage *)logo;

/**
 将二维码嵌入到图片中

 @param qrCode 二维码
 @param image 图片，必须含有矩形镂空部分，二维码会自动识别到镂空部分
 @return 合成图
 */
+ (UIImage *)makeQrCode:(UIImage *)qrCode
                toImage:(UIImage *)image;

/**
 用qrcode合成

 @param image 上层图片
 @param backImage 背景图片
 @param frameBlock 图片大小回调，得到图片大小返回位置
 @return 合成图
 */
+ (UIImage *)remixImage:(UIImage *)image
            toBackImage:(UIImage *)backImage
           frameOfImage:(CGRect(^)(CGSize upImageSize))frameBlock;

@end
