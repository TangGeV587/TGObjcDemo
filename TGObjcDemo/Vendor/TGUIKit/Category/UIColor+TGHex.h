//
//  UIColor+TGHex.h
//  TGObjcDemo
//
//  Created by hanghang on 2022/11/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (TGHex)

+ (UIColor*)tg_colorWithRGB:(NSUInteger)hex alpha:(CGFloat)alpha;

+ (UIColor *)tg_colorWithHexStr:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)tg_colorWithHexStr:(NSString *)color alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
