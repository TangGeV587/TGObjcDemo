//
//  UIView+TGFrame.m
//  TGObjcDemo
//
//  Created by hanghang on 2022/11/30.
//

#import "UIView+TGFrame.h"

@implementation UIView (TGFrame)

- (CGFloat)tg_x{
    return self.frame.origin.x;
}

- (void)setTg_x:(CGFloat)tg_x{
    CGRect frame = self.frame;
    frame.origin.x = tg_x;
    self.frame = frame;
}

- (CGFloat)tg_y{
    return self.frame.origin.y;
}

-(void)setTg_y:(CGFloat)tg_y{
    CGRect frame = self.frame;
    frame.origin.y = tg_y;
    self.frame = frame;
}

- (CGFloat)tg_top
{
    return self.frame.origin.y;
}

- (void)setTg_top:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)tg_right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setTg_right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - self.frame.size.width;
    self.frame = frame;
}

- (CGFloat)tg_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setTg_bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)tg_left
{
    return self.frame.origin.x;
}

- (void)setTg_left:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)tg_width
{
    return self.frame.size.width;
}

- (void)setTg_width:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)tg_height
{
    return self.frame.size.height;
}

- (void)setTg_height:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

#pragma mark - Shortcuts for positions

- (CGFloat)tg_centerX {
    return self.center.x;
}

- (void)setTg_centerX:(CGFloat)tg_centerX{
    self.center = CGPointMake(tg_centerX, self.center.y);
}

- (CGFloat)tg_centerY {
    return self.center.y;
}

- (void)setTg_centerY:(CGFloat)tg_centerY{
    self.center = CGPointMake(self.center.x, tg_centerY);
}


- (CGFloat)tg_maxX{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)tg_maxY{
    return CGRectGetMaxY(self.frame);
}

- (CGPoint)tg_origin {
    return self.frame.origin;
}

- (void)setTg_origin:(CGPoint)tg_origin {
    CGRect frame = self.frame;
    frame.origin = tg_origin;
    self.frame = frame;
}

- (CGSize)tg_size {
    return self.frame.size;
}

- (void)setTg_size:(CGSize)tg_size {
    CGRect frame = self.frame;
    frame.size = tg_size;
    self.frame = frame;
}


@end
