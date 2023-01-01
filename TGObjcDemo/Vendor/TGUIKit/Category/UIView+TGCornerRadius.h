//
//  UIView+TGCornerRadius.h
//  TGObjcDemo
//
//  Created by hanghang on 2022/11/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TGCornerRadius)

- (void)setCornerRadius:(CGSize)radiusSize corner:(UIRectCorner)corner;
///圆角边框
- (void)setCorners:(UIRectCorner)corners radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

@end

NS_ASSUME_NONNULL_END
