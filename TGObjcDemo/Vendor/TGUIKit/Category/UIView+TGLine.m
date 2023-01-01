//
//  UIView+TGLine.m
//  TGObjcDemo
//
//  Created by hanghang on 2022/11/30.
//

#import "UIView+TGLine.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>

static char tg_line_left_key;
static char tg_line_right_key;
static char tg_line_top_key;
static char tg_line_bottom_key;

static char tg_line_position_key;

static char tg_line_width_key;

static char tg_line_color_key;

static char tg_line_edgeInsets_key;

static char tg_line_leftEdgeInsets_key;
static char tg_line_topEdgeInsets_key;
static char tg_line_rightEdgeInsets_key;
static char tg_line_bottomEdgeInsets_key;

@implementation UIView (TGLine)

-(void)tg_showLintWithPosition:(TGViewLinePosition)position{
    if (self.tg_position != position) {
        self.tg_position = position;
        [self tg_updatePosition];
    }
}

-(void)tg_updatePosition{
    TGViewLinePosition position = self.tg_position;
    
    if (position & TGViewLinePositionTop) {
        if (!self.tg_topLine) {
            self.tg_topLine = [self tg_getLineView];
            [self addSubview:self.tg_topLine];
        }
        [self updateTopLintConstraints];
    }
    else{
        if (self.tg_topLine) {
            [self.tg_topLine removeFromSuperview];
            self.tg_topLine = nil;
        }
    }
    
    if (position & TGViewLinePositionLeft) {
        if (!self.tg_leftLine) {
            self.tg_leftLine = [self tg_getLineView];
            [self addSubview:self.tg_leftLine];
        }
        [self updateLeftLintConstraints];
    }
    else{
        if (self.tg_leftLine) {
            [self.tg_leftLine removeFromSuperview];
            self.tg_leftLine = nil;
        }
    }
    
    if (position & TGViewLinePositionBottom) {
        if (!self.tg_bottomLine) {
            self.tg_bottomLine = [self tg_getLineView];
            [self addSubview:self.tg_bottomLine];
        }
        [self updateBottomLintConstraints];
    }
    else{
        if (self.tg_bottomLine) {
            [self.tg_bottomLine removeFromSuperview];
            self.tg_bottomLine = nil;
        }
    }
    
    if (position & TGViewLinePositionRight) {
        if (!self.tg_rightLine) {
            self.tg_rightLine = [self tg_getLineView];
            [self addSubview:self.tg_rightLine];
        }
        [self updateRightLintConstraints];
    }
    else{
        if (self.tg_rightLine) {
            [self.tg_rightLine removeFromSuperview];
            self.tg_rightLine = nil;
        }
    }
}

- (UIView*)tg_getLineView{
    UIView* lineV = [UIView new];
    lineV.backgroundColor = self.tg_lineColor;
    lineV.translatesAutoresizingMaskIntoConstraints = NO;
    return lineV;
}
#pragma mark- posititon
- (void)setTg_position:(TGViewLinePosition)tg_position{
    objc_setAssociatedObject(self, &tg_line_position_key, [NSNumber numberWithInteger:tg_position], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TGViewLinePosition)tg_position{
    NSNumber* positionNum = objc_getAssociatedObject(self, &tg_line_position_key);
    return [positionNum integerValue];;
}


#pragma mark- left
- (void)setTg_leftLine:(UIView *)tg_leftLine{
    objc_setAssociatedObject(self, &tg_line_left_key, tg_leftLine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView*)tg_leftLine{
    UIView* lineV = objc_getAssociatedObject(self, &tg_line_left_key);
    return lineV;
}
-(void)updateLeftLintConstraints{
    if (self.tg_leftLine && self.tg_leftLine.superview) {
        UIEdgeInsets edge = UIEdgeInsetsZero;
        if (!UIEdgeInsetsEqualToEdgeInsets(self.tg_lineLeftEdgeInsets, UIEdgeInsetsZero)) {
            edge = self.tg_lineLeftEdgeInsets;
        }else{
            edge = self.tg_lineEdgeInsets;
        }
        [self.tg_leftLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(edge.left);
            make.width.mas_equalTo(self.tg_lineWidth);
            make.top.equalTo(self).offset(edge.top);
            make.bottom.equalTo(self).offset(-edge.bottom);
        }];
    }
}

#pragma mark- right
- (void)setTg_rightLine:(UIView *)tg_rightLine{
    objc_setAssociatedObject(self, &tg_line_right_key, tg_rightLine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView*)tg_rightLine{
    UIView* lineV = objc_getAssociatedObject(self, &tg_line_right_key);
    return lineV;
}
-(void)updateRightLintConstraints{
    if (self.tg_rightLine && self.tg_rightLine.superview) {
        UIEdgeInsets edge = UIEdgeInsetsZero;
        if (!UIEdgeInsetsEqualToEdgeInsets(self.tg_lineRightEdgeInsets, UIEdgeInsetsZero)) {
            edge = self.tg_lineRightEdgeInsets;
        }else{
            edge = self.tg_lineEdgeInsets;
        }
        [self.tg_rightLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-edge.right);
            make.width.mas_equalTo(self.tg_lineWidth);
            make.top.equalTo(self).offset(edge.top);
            make.bottom.equalTo(self).offset(-edge.bottom);
        }];
    }
}

#pragma mark- top
- (void)setTg_topLine:(UIView *)tg_topLine{
    objc_setAssociatedObject(self, &tg_line_top_key, tg_topLine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView*)tg_topLine{
    UIView* lineV = objc_getAssociatedObject(self, &tg_line_top_key);
    return lineV;
}
-(void)updateTopLintConstraints{
    if (self.tg_topLine && self.tg_topLine.superview) {
        UIEdgeInsets edge = UIEdgeInsetsZero;
        if (!UIEdgeInsetsEqualToEdgeInsets(self.tg_lineTopEdgeInsets, UIEdgeInsetsZero)) {
            edge = self.tg_lineTopEdgeInsets;
        }else{
            edge = self.tg_lineEdgeInsets;
        }
        [self.tg_topLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(edge.top);
            make.height.mas_equalTo(self.tg_lineWidth);
            make.left.equalTo(self).offset(edge.left);
            make.right.equalTo(self).offset(-edge.right);
        }];
    }
}

#pragma mark- bottom
- (void)setTg_bottomLine:(UIView *)tg_bottomLine{
    objc_setAssociatedObject(self, &tg_line_bottom_key, tg_bottomLine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView*)tg_bottomLine{
    UIView* lineV = objc_getAssociatedObject(self, &tg_line_bottom_key);
    return lineV;
}
-(void)updateBottomLintConstraints{
    if (self.tg_bottomLine && self.tg_bottomLine.superview) {
        UIEdgeInsets edge = UIEdgeInsetsZero;
        if (!UIEdgeInsetsEqualToEdgeInsets(self.tg_lineBottomEdgeInsets, UIEdgeInsetsZero)) {
            edge = self.tg_lineBottomEdgeInsets;
        }else{
            edge = self.tg_lineEdgeInsets;
        }
        [self.tg_bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-edge.bottom);
            make.height.mas_equalTo(self.tg_lineWidth);
            make.left.equalTo(self).offset(edge.left);
            make.right.equalTo(self).offset(-edge.right);
        }];
    }
}

#pragma mark- lineWidth
- (void)setTg_lineWidth:(CGFloat)tg_lineWidth{
    objc_setAssociatedObject(self, &tg_line_width_key, [NSNumber numberWithFloat:tg_lineWidth], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)tg_lineWidth{
    NSNumber* lineWidthNum = objc_getAssociatedObject(self, &tg_line_width_key);

    if (lineWidthNum) {
        return [lineWidthNum floatValue];
    }else{
        return 1.0/[UIScreen mainScreen].scale;
    }
}

#pragma mark- lineColor
- (void)setTg_lineColor:(UIColor *)tg_lineColor{
    objc_setAssociatedObject(self, &tg_line_color_key, tg_lineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor*)tg_lineColor{
    UIColor* color = objc_getAssociatedObject(self, &tg_line_color_key);
    if (!color) {
        return [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    }
    return color;
}

#pragma mark- tg_line_edgeInsets_key
- (void)setTg_lineEdgeInsets:(UIEdgeInsets)tg_lineEdgeInsets{
    objc_setAssociatedObject(self, &tg_line_edgeInsets_key, [NSValue valueWithUIEdgeInsets:tg_lineEdgeInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)tg_lineEdgeInsets{
    NSValue* value = objc_getAssociatedObject(self, &tg_line_edgeInsets_key);
    if (!value) {
        return UIEdgeInsetsZero;
    }
    return [value UIEdgeInsetsValue];
}

#pragma mark- tg_line_edgeInsets_key


- (void)setTg_lineTopEdgeInsets:(UIEdgeInsets)tg_lineTopEdgeInsets{
    objc_setAssociatedObject(self, &tg_line_topEdgeInsets_key, [NSValue valueWithUIEdgeInsets:tg_lineTopEdgeInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)tg_lineTopEdgeInsets{
    NSValue* value = objc_getAssociatedObject(self, &tg_line_topEdgeInsets_key);
    if (!value) {
        return UIEdgeInsetsZero;
    }
    return [value UIEdgeInsetsValue];
}


- (void)setTg_lineLeftEdgeInsets:(UIEdgeInsets)tg_lineLeftEdgeInsets{
    objc_setAssociatedObject(self, &tg_line_leftEdgeInsets_key, [NSValue valueWithUIEdgeInsets:tg_lineLeftEdgeInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)tg_lineLeftEdgeInsets{
    NSValue* value = objc_getAssociatedObject(self, &tg_line_leftEdgeInsets_key);
    if (!value) {
        return UIEdgeInsetsZero;
    }
    return [value UIEdgeInsetsValue];
}


- (void)setTg_lineBottomEdgeInsets:(UIEdgeInsets)tg_lineBottomEdgeInsets{
    objc_setAssociatedObject(self, &tg_line_bottomEdgeInsets_key, [NSValue valueWithUIEdgeInsets:tg_lineBottomEdgeInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)tg_lineBottomEdgeInsets{
    NSValue* value = objc_getAssociatedObject(self, &tg_line_bottomEdgeInsets_key);
    if (!value) {
        return UIEdgeInsetsZero;
    }
    return [value UIEdgeInsetsValue];
}

- (void)setTg_lineRightEdgeInsets:(UIEdgeInsets)tg_lineRightEdgeInsets{
    objc_setAssociatedObject(self, &tg_line_rightEdgeInsets_key, [NSValue valueWithUIEdgeInsets:tg_lineRightEdgeInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)tg_lineRightEdgeInsets{
    NSValue* value = objc_getAssociatedObject(self, &tg_line_rightEdgeInsets_key);
    if (!value) {
        return UIEdgeInsetsZero;
    }
    return [value UIEdgeInsetsValue];
}


//绘制渐变色颜色的方法
- (void)setGradualBackgroundFromColor:(UIColor *)fColor toColor:(UIColor *)tColor{
    
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[fColor,tColor];
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0,@1];
    
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

@end
