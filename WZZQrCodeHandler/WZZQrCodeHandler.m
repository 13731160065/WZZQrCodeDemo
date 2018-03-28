//
//  WZZQrCodeHandler.m
//  fff3
//
//  Created by 王泽众 on 2018/3/28.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZQrCodeHandler.h"

@implementation WZZQrCodeHandler

+ (UIImage *)qrCodeWithString:(NSString *)string {
    return [self qrCodeWithString:string logo:nil];
}

+ (UIImage *)qrCodeWithString:(NSString *)string logo:(UIImage *)logo {
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    // 3.将字符串转换成NSdata
    NSData *data  = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    CIImage * outCIImage = [filter outputImage];
//    UIImage * outImage = [UIImage imageWithCIImage:outCIImage];
    UIImage * outImage = [self _createUIImageFormCIImage:outCIImage withSize:300];
    
    if (logo) {
        //添加logo
        outImage = [self remixImage:logo
             toBackImage:outImage
            frameOfImage:^CGRect(CGSize imageSize) {
            CGFloat imgwd = imageSize.width/6;
            CGRect frame = CGRectMake(imageSize.width/2-imgwd/2, imageSize.height/2-imgwd/2, imgwd, imgwd);
            return frame;
        }];
    }
    
    return outImage;
}

//根据空白合成图
+ (UIImage *)makeQrCode:(UIImage *)qrCode
                toImage:(UIImage *)image {
    return nil;
}

//根据位置合成图
+ (UIImage *)remixImage:(UIImage *)image
            toBackImage:(UIImage *)backImage
           frameOfImage:(CGRect(^)(CGSize))frameBlock {
    CGSize backSize = CGSizeMake(backImage.size.width, backImage.size.height);
    //    if (backSize.width > 500) {
    backSize.height = 500/backSize.width*backSize.height;
    backSize.width = 500;
    //    }
    //背景
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backSize.width, backSize.height)];
    
    //底图
    UIImageView * imageV = [[UIImageView alloc] initWithFrame:backView.bounds];
    [backView addSubview:imageV];
    [imageV setImage:backImage];
    
    //二维码
    if (frameBlock) {
        CGRect frame = frameBlock(backView.bounds.size);
        UIImageView * qrV = [[UIImageView alloc] initWithFrame:frame];
        [backView addSubview:qrV];
        [qrV setImage:image];
    }
    
    UIImage * outImage = [self _remixImageWithImageView:backView];
    return outImage;
}

#pragma mark - 辅助方法
//CIImage转UIImage
+ (UIImage *)_createUIImageFormCIImage:(CIImage *)image
                             withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

/**
 将不同层压成一张
 */
+ (UIImage *)_remixImageWithImageView:(UIView *)remixImageView {
    //截取图片
    UIGraphicsBeginImageContextWithOptions(remixImageView.frame.size, NO, 10.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [remixImageView.layer renderInContext:ctx];
    UIImage *imgDraw = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgDraw;
}

@end
