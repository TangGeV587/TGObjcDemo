//
//  UIImage+TGUtils.m
//  TGObjcDemo
//
//  Created by hanghang on 2022/11/30.
//

#import "UIImage+TGUtils.h"
#import <AVFoundation/AVFoundation.h>
#import <SDWebImage/SDWebImage.h>

@implementation UIImage (TGUtils)

//颜色创建图片
+ (UIImage *)tg_imageWithColor:(UIColor *)color {
    return [[self class] tg_imageWithColor:color withSize:CGSizeMake(1.0, 1.0)];
}

+ (UIImage *)tg_imageWithColor:(UIColor *)color withSize:(CGSize)size {

    return [[self class] tg_imageWithColor:color rect:CGRectMake(0, 0, size.width, size.height) cornerRadius:0];
}

+ (UIImage *)tg_imageWithColor:(UIColor *)color rect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius{
    
    return [[self class] tg_imageWithColor:color rect:rect cornerRadius:cornerRadius cornerPosition:UIRectCornerAllCorners borderWidth:0];
}
+ (UIImage *)tg_imageWithColor:(UIColor *)color rect:(CGRect)rect cornerRadius:(CGFloat)cornerRadius cornerPosition:(UIRectCorner)position borderWidth:(CGFloat)borderWidth{
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0);
//    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:position cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CGContextAddPath(context, path.CGPath);
    
    if (borderWidth > 0) {
        CGContextSetLineWidth(context, borderWidth);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextStrokePath(context);
    }else{
        CGContextFillPath(context);
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 生成圆角图片
+ (UIImage *)tg_circleImageWithColor:(UIColor *)color withSize:(CGSize)size {
    return [self tg_circleImageWithColor:color withSize:size withName:nil];
}

#pragma mark - 生成插入文字的圆角图片
+ (UIImage *)tg_circleImageWithColor:(UIColor *)color withSize:(CGSize)size withName:(NSString *)name {
    CGFloat minW = MIN(size.width, size.height);
    CGSize tempSize = CGSizeMake(minW, minW);
    CGRect rect = (CGRect){CGPointZero, tempSize};
    //    UIGraphicsBeginImageContext(tempSize);
    UIGraphicsBeginImageContextWithOptions(tempSize, NO, [UIScreen mainScreen].scale);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ref, [color CGColor]);
    CGContextFillEllipseInRect(ref, rect);
    if (!CGContextIsPathEmpty(ref)) CGContextClip(ref);
    if (name.length > 0) {
        if (name.length > 2) name = [name substringWithRange:NSMakeRange(name.length - 2, 2)];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentCenter;
        NSDictionary *dict = @{
            NSParagraphStyleAttributeName : style,
            NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
            NSForegroundColorAttributeName : [UIColor whiteColor]
        };
        CGSize fontSize = [name sizeWithAttributes:dict];
        [name drawInRect:(CGRect){(tempSize.width - fontSize.width) / 2, (tempSize.height - fontSize.height) / 2, fontSize}
            withAttributes:dict];
    }
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)tg_imageWithQRCodeData:(NSString *)data imageWidth:(CGFloat)width {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSString *info = data;
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    CIImage *outputImage = [filter outputImage];
    return [[self class] tg_createNonInterpolatedUIImageFormCIImage:outputImage withSize:width];
}

/** 根据CIImage生成指定大小的UIImage */
+ (UIImage *)tg_createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));

    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo) kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);

    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

+ (UIImage *)tg_getVideoImage:(NSString *)videoURL {
    NSString *fileNoExtStr = [videoURL stringByDeletingPathExtension];
    NSString *imagePath = [NSString stringWithFormat:@"%@.jpg", fileNoExtStr];
    UIImage *returnImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
    if (returnImage) {
        return returnImage;
    }

    NSDictionary *opts =
        [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:opts];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    gen.maximumSize = CGSizeMake(360.0f, 480.0f);
    NSError *error = nil;
    CGImageRef image = [gen copyCGImageAtTime:CMTimeMake(1, 1) actualTime:NULL error:&error];
    returnImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    [UIImageJPEGRepresentation(returnImage, 0.6) writeToFile:imagePath atomically:YES];
    if (returnImage) {
        return returnImage;
    }
    return nil;
}

#pragma mark - 截图

+ (UIImage *)tg_screenshotWithView:(UIView *)shotView {
    return [self tg_screenshotWithView:shotView shotSize:shotView.frame.size];
}

+ (UIImage *)tg_screenshotWithView:(UIView *)shotView shotSize:(CGSize)shotSize {
    UIImage *img = nil;
    UIGraphicsBeginImageContext(shotSize);
    [shotView.layer renderInContext:UIGraphicsGetCurrentContext()];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
#pragma mark - 压缩图片
+ (UIImage *)tg_compressImage:(UIImage *)image withSize:(CGSize)viewsize {
    CGFloat imgHWScale = image.size.height / image.size.width;
    CGFloat viewHWScale = viewsize.height / viewsize.width;
    CGRect rect = CGRectZero;
    if (imgHWScale > viewHWScale) {
        rect.size.height = viewsize.width * imgHWScale;
        rect.size.width = viewsize.width;
        rect.origin.x = 0.0f;
        rect.origin.y = (viewsize.height - rect.size.height) * 0.5f;
    } else {
        CGFloat imgWHScale = image.size.width / image.size.height;
        rect.size.width = viewsize.height * imgWHScale;
        rect.size.height = viewsize.height;
        rect.origin.y = 0.0f;
        rect.origin.x = (viewsize.width - rect.size.width) * 0.5f;
    }
    UIGraphicsBeginImageContext(viewsize);
    [image drawInRect:rect];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UIImage *)tg_scaleImg:(UIImage *)img scale:(float)scale {
    UIGraphicsBeginImageContext(CGSizeMake(img.size.width * scale, img.size.height * scale));
    [img drawInRect:CGRectMake(0, 0, img.size.width * scale, img.size.height * scale)];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

#pragma mark - 调整图片的旋转角度
+ (UIImage *)tg_fixOrientation:(UIImage *)aImage {
    if (aImage.imageOrientation == UIImageOrientationUp) return aImage;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height, CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage), CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.height, aImage.size.width), aImage.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height), aImage.CGImage);
            break;
    } // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


+ (UIImage *)tg_imageWithLinearGradientStartColor:(UIColor *)startColor endColor:(UIColor *)endColor size:(CGSize)size vertical:(BOOL)isVertical{
    
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //创建CGMutablePathRef
    
    //绘制渐变
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat locations[] = { 0.0,1.0 };//这个是两种颜色的位置
    //        CGFloat locations[] = { 0.0, 0.5,1.0 };//这个是三种颜色的位置
    //      NSArray *colors = @[(__bridge id)startColor,(__bridge id)[UIColor blueColor].CGColor,(__bridge id)endColor];//渐变颜色的种类，要和上边的locations对应；
    
    NSArray *colors = @[(__bridge id)startColor.CGColor,(__bridge id)endColor.CGColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    //        CGRect pathRect = CGPathGetBoundingBox(path);
    
    //具体方向可根据需求修改
    
    //        CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMinY(pathRect));
    
    //        CGPoint endPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMaxY(pathRect));
    
    CGPoint startPoint = CGPointMake(0,0);
    CGPoint endPoint = CGPointMake(0,size.height);
    if (!isVertical) {
        endPoint = CGPointMake(size.width,0);
    }
    
    CGContextSaveGState(context);
    //    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    //注意释放CGMutablePathRef
    
    
    //从Context中获取图像，并显示在界面上
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}



-(UIImage *)tg_updateImageWithTintColor:(UIColor*)color alpha:(CGFloat)alpha rect:(CGRect)rect
{
    CGRect imageRect = CGRectMake(.0f, .0f, self.size.width, self.size.height);
    
    // 启动图形上下文
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    // 获取图片上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    // 利用drawInRect方法绘制图片到layer, 是通过拉伸原有图片
    [self drawInRect:imageRect];
    // 设置图形上下文的填充颜色
    CGContextSetFillColorWithColor(contextRef, [color CGColor]);
    // 设置图形上下文的透明度
    CGContextSetAlpha(contextRef, alpha);
    // 设置混合模式
    CGContextSetBlendMode(contextRef, kCGBlendModeSourceAtop);
    // 填充当前rect
    CGContextFillRect(contextRef, rect);
    
    // 根据位图上下文创建一个CGImage图片，并转换成UIImage
    CGImageRef imageRef = CGBitmapContextCreateImage(contextRef);
    UIImage *tintedImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    // 释放 imageRef，否则内存泄漏
    CGImageRelease(imageRef);
    // 从堆栈的顶部移除图形上下文
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

-(UIImage *)tg_grayImage
{
    int bitmapInfo = kCGImageAlphaNone;
    int width = self.size.width;
    int height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), self.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}


+ (UIImage *)tg_handleImage:(UIImage *)originalImage withSize:(CGSize)size {
    CGSize originalsize = [originalImage size];
    NSLog(@"改变前图片的宽度为%f,图片的高度为%f",originalsize.width,originalsize.height);
    
    //原图长宽均小于标准长宽的，不作处理返回原图
    if (originalsize.width<size.width && originalsize.height<size.height)
    {
        return originalImage;
    }
    
    //原图长宽均大于标准长宽的，按比例缩小至最大适应值
    else if(originalsize.width>size.width && originalsize.height>size.height)
    {
        CGFloat rate = 1.0;
        CGFloat widthRate = originalsize.width/size.width;
        CGFloat heightRate = originalsize.height/size.height;
        
        rate = widthRate>heightRate?heightRate:widthRate;
        
        CGImageRef imageRef = nil;
        
        if (heightRate>widthRate)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height*rate/2, originalsize.width, size.height*rate));//获取图片整体部分
        }
        else
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width*rate/2, 0, size.width*rate, originalsize.height));//获取图片整体部分
        }
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
        
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        
        return standardImage;
    }
    
    //原图长宽有一项大于标准长宽的，对大于标准的那一项进行裁剪，另一项保持不变
    else if(originalsize.height>size.height || originalsize.width>size.width)
    {
        CGImageRef imageRef = nil;
        
        if(originalsize.height>size.height)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height/2, originalsize.width, size.height));//获取图片整体部分
        }
        else if (originalsize.width>size.width)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width/2, 0, size.width, originalsize.height));//获取图片整体部分
        }
        
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
        
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        
        return standardImage;
    }
    
    //原图为标准长宽的，不做处理
    else
    {
        return originalImage;
    }
}

+ (UIImage *)tg_trimImageWithImage:(UIImage *)image {
    
    //imageView的宽高比
    CGFloat imageViewWidthHeightRatio = [UIScreen mainScreen].bounds.size.width / ([UIScreen mainScreen].bounds.size.width * 0.6);
    //屏幕分辨率
//        CGFloat imageScale = [[UIScreen mainScreen] scale];
    
    CGFloat imageScale = 1;
    
    CGFloat imageWith = image.size.width*imageScale;
    
    CGFloat imageHeight =image.size.height*imageScale;
    
    //image的宽高比
    CGFloat imageWidthHeightRatio =imageWith/imageHeight;
    
    CGImageRef imageRef = nil;
    
    CGRect rect;
    
    NSLog(@"\nimageWith === %f\nimageHeight === %f\nImageView宽高比 == %f\nimageScale == %f",imageWith,imageHeight,imageViewWidthHeightRatio,imageScale);
    
    
    if (imageWidthHeightRatio>imageViewWidthHeightRatio) {
        
        rect = CGRectMake((imageWith-imageHeight*imageViewWidthHeightRatio)/2, 0, imageHeight*imageViewWidthHeightRatio, imageHeight);
        
    }else if (imageWidthHeightRatio<imageViewWidthHeightRatio) {
        
        rect = CGRectMake(0, (imageHeight-imageWith/imageViewWidthHeightRatio)/2, imageWith, imageWith/imageViewWidthHeightRatio);
        
    }else {
        rect = CGRectMake(0, 0, imageWith, imageHeight);
    }
    
    imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *res = [UIImage imageWithCGImage:imageRef scale:imageScale orientation:UIImageOrientationUp];
    
    /**
     一定要，千万要release，否则等着内存泄露吧，稍微高清点的图一张图就是几M内存，很快App就挂了
     */
    CGImageRelease(imageRef);
    
    return res;
}


/**
 *  压缩图片到指定尺寸大小
 *
 *  @param image 原始图片
 *  @param size  目标大小
 *
 *  @return 生成图片
 */
+ (UIImage *)tg_compressOriginalImage:(UIImage *)image toSize:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return returnImage;
}

/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的压缩后的图片
 */
+ (UIImage *)tg_compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    
    UIImage *newsImage = [UIImage imageWithData:data];
    
    return newsImage;
}


/** 等比压缩图片到指定大小 */
+ (UIImage *)tg_compressPropertyImageForSize:(UIImage *)sourceImage targetSize:(CGSize)size {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (UIImage*)tg_imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage* sourceImage = self;
    UIImage* newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        } else {
            scaleFactor = heightFactor; // scale to fit width
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {
        NSLog(@"could not scale image");
    }
    
    // pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)tg_imageCorrectedForCaptureOrientation:(UIImageOrientation)imageOrientation
{
    float rotation_radians = 0;
    bool perpendicular = false;
    
    switch (imageOrientation) {
        case UIImageOrientationUp :
            rotation_radians = 0.0;
            break;
            
        case UIImageOrientationDown:
            rotation_radians = M_PI; // don't be scared of radians, if you're reading this, you're good at math
            break;
            
        case UIImageOrientationRight:
            rotation_radians = M_PI_2;
            perpendicular = true;
            break;
            
        case UIImageOrientationLeft:
            rotation_radians = -M_PI_2;
            perpendicular = true;
            break;
            
        default:
            break;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width, self.size.height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Rotate around the center point
    CGContextTranslateCTM(context, self.size.width / 2, self.size.height / 2);
    CGContextRotateCTM(context, rotation_radians);
    
    CGContextScaleCTM(context, 1.0, -1.0);
    float width = perpendicular ? self.size.height : self.size.width;
    float height = perpendicular ? self.size.width : self.size.height;
    CGContextDrawImage(context, CGRectMake(-width / 2, -height / 2, width, height), [self CGImage]);
    
    // Move the origin back since the rotation might've change it (if its 90 degrees)
    if (perpendicular) {
        CGContextTranslateCTM(context, -self.size.height / 2, -self.size.width / 2);
    }
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)tg_imageCorrectedForCaptureOrientation
{
    return [self tg_imageCorrectedForCaptureOrientation:[self imageOrientation]];
}

- (UIImage*)tg_imageByScalingNotCroppingForSize:(CGSize)targetSize
{
    SDImageFormat format = [self sd_imageFormat];
    if (format == SDImageFormatGIF) {
        return [self GIFScaleTosize:targetSize];
    } else {
        return [self imageScaleToSize:targetSize];
    }
}

- (UIImage*)imageScaleToSize:(CGSize)targetSize {
    UIImage* sourceImage = self;
    UIImage* newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGSize scaledSize = targetSize;
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        // opposite comparison to imageByScalingAndCroppingForSize in order to contain the image within the given bounds
        if (widthFactor > heightFactor) {
            scaleFactor = heightFactor; // scale to fit height
        } else {
            scaleFactor = widthFactor; // scale to fit width
        }
        scaledSize = CGSizeMake(MIN(width * scaleFactor, targetWidth), MIN(height * scaleFactor, targetHeight));
    }
    
    // If the pixels are floats, it causes a white line in iOS8 and probably other versions too
    scaledSize.width = (int)scaledSize.width;
    scaledSize.height = (int)scaledSize.height;
    
    UIGraphicsBeginImageContext(scaledSize); // this will resize
    
    [sourceImage drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {
        NSLog(@"could not scale image");
    }
    
    // pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)GIFScaleTosize:(CGSize)targetSize {
    NSData *data = [self sd_imageDataAsFormat:SDImageFormatGIF];
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = self;
    }
    else {
        // images数组过大时内存会飙升，在这里限制下最大count
        NSInteger maxCount = 50;
        NSInteger interval = MAX((count + maxCount / 2) / maxCount, 1);
        
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i+=interval) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            if (!image) {
                continue;
            }
//            CGImageRef newImageRef = CGImageCreateWithImageInRect(image, cropRect);
            UIImage *newImage = [UIImage imageWithCGImage:image];
            newImage = [newImage imageScaleToSize:targetSize];
            [images addObject:newImage];

            CGImageRelease(image);
            duration += [self sd_frameDurationAtIndex:i source:source] * MIN(interval, 3);
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    CFRelease(source);
    return animatedImage;
}

- (float)sd_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    }
    else {
        
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

@end
