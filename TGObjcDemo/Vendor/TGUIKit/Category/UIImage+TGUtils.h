//
//  UIImage+TGUtils.h
//  TGObjcDemo
//
//  Created by hanghang on 2022/11/30.
//

#import <UIKit/UIKit.h>


@interface UIImage (TGUtils)

/**
 @brief 通过指定颜色生成一张图片

 @param color 颜色
 @return 创建的图片
 */
+ (UIImage *)tg_imageWithColor:(UIColor *)color;

/**
 @brief 通过指定颜色生成一张图片

 @param color 颜色
 @param size 尺寸
 @return 创建的图片
 */
+ (UIImage *)tg_imageWithColor:(UIColor *)color withSize:(CGSize)size;
+ (UIImage *)tg_imageWithColor:(UIColor *)color rect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius;
+ (UIImage *)tg_imageWithColor:(UIColor *)color rect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius cornerPosition:(UIRectCorner)position borderWidth:(CGFloat)borderWidth;
/**
 画出一张圆形图片

 @param color 颜色
 @param size 尺寸
 @return 返回一张圆形图片
 */
+ (UIImage *)tg_circleImageWithColor:(UIColor *)color withSize:(CGSize)size;

/**
 画出一张圆形图片

 @param color 图片背景颜色
 @param size 圆形图片尺寸
 @param name 图片上水印的文字内容
 @return 返回一张圆形图片
 */
+ (UIImage *)tg_circleImageWithColor:(UIColor *)color withSize:(CGSize)size withName:(NSString *)name;

/**
 @brief 群组二维码图片生成

 @param data 群组数据
 @param width 生产二维码图片的宽度
 @return 生成的二维码图片
 */
+ (UIImage *)tg_imageWithQRCodeData:(NSString *)data imageWidth:(CGFloat)width;

/**
 根据视频文件的一个地址获取第一帧图

 @param videoURL 视频文件的地址
 @return 返回第一针图
 */
+ (UIImage *)tg_getVideoImage:(NSString *)videoURL;

/**
 传入一个view截取截取生成一张图片

 @param shotView 传入要截图的view
 @return 返回一张图片
 */
+ (UIImage *)tg_screenshotWithView:(UIView *)shotView;

/**
 传入一个view截取截取生成一张图片

 @param shotView 传入要截图的view
 @param shotSize 截取的范围
 @return 返回一张图片
 */
+ (UIImage *)tg_screenshotWithView:(UIView *)shotView shotSize:(CGSize)shotSize;

/**
 @brief 压缩图片

 @param image 待压缩图片
 @param viewsize 需要压缩图片的size
 @return 压缩后图片
 */
+ (UIImage *)tg_compressImage:(UIImage *)image withSize:(CGSize)viewsize;


/**
 根据scale等比例压缩当前图片并返回新图片

 @param img 原始图片
 @param scale 压缩比例
 @return 新图片
 */
+ (UIImage *)tg_scaleImg:(UIImage *)img scale:(float)scale;

/**
 @brief 转换图片方向

 @param aImage 原始图片
 @return 转换后生成的目标图片
 */
+ (UIImage *)tg_fixOrientation:(UIImage *)aImage;

+ (UIImage *)tg_imageWithLinearGradientStartColor:(UIColor *)startColor endColor:(UIColor *)endColor size:(CGSize)size vertical:(BOOL)isVertical;


-(UIImage *)tg_updateImageWithTintColor:(UIColor*)color alpha:(CGFloat)alpha rect:(CGRect)rect;

/** 图片置灰*/
-(UIImage *)tg_grayImage;


//裁剪图片
+ (UIImage *)tg_handleImage:(UIImage *)originalImage withSize:(CGSize)size;

+ (UIImage *)tg_trimImageWithImage:(UIImage *)image;

/**
 *  压缩图片到指定尺寸大小
 *
 *  @param image 原始图片
 *  @param size  目标大小
 *
 *  @return 生成图片
 */
+ (UIImage *)tg_compressOriginalImage:(UIImage *)image toSize:(CGSize)size;

/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的压缩后的图片
 */
+ (UIImage *)tg_compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;


/** 等比压缩图片到指定大小 */
+ (UIImage *)tg_compressPropertyImageForSize:(UIImage *)sourceImage targetSize:(CGSize)size;


- (UIImage*)tg_imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage*)tg_imageCorrectedForCaptureOrientation;
- (UIImage*)tg_imageCorrectedForCaptureOrientation:(UIImageOrientation)imageOrientation;
- (UIImage*)tg_imageByScalingNotCroppingForSize:(CGSize)targetSize;

@end

