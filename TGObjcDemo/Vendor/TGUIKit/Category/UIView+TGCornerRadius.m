//
//  UIView+TGCornerRadius.m
//  TGObjcDemo
//
//  Created by hanghang on 2022/11/30.
//

#import "UIView+TGCornerRadius.h"

@implementation UIView (TGCornerRadius)

- (void)setCornerRadius:(CGSize)radiusSize corner:(UIRectCorner)corner
{
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:radiusSize];
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

///圆角边框
- (void)setCorners:(UIRectCorner)corners radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
    
    if (borderWidth > 0 && borderColor != nil) {
        CAShapeLayer *borderLayer = [CAShapeLayer layer];
        borderLayer.frame = self.bounds;
        borderLayer.path = path.CGPath;
        borderLayer.lineWidth = borderWidth;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        borderLayer.strokeColor = borderColor.CGColor;
        [self.layer addSublayer:borderLayer];
    }
}


@end
