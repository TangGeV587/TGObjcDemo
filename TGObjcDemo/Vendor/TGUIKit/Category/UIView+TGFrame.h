//
//  UIView+TGFrame.h
//  TGObjcDemo
//
//  Created by hanghang on 2022/11/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TGFrame)

@property (nonatomic) CGFloat tg_centerX;
@property (nonatomic) CGFloat  tg_centerY;

@property (nonatomic) CGFloat  tg_x;
@property (nonatomic) CGFloat tg_y;

@property (nonatomic) CGFloat  tg_top;
@property (nonatomic) CGFloat tg_bottom;
@property (nonatomic) CGFloat tg_right;
@property (nonatomic) CGFloat tg_left;

@property (nonatomic) CGFloat tg_width;
@property (nonatomic) CGFloat tg_height;

@property (nonatomic,readonly) CGFloat tg_maxY;

@property (nonatomic,readonly) CGFloat tg_maxX;

@property (nonatomic) CGPoint tg_origin;
@property (nonatomic) CGSize  tg_size;     

@end

NS_ASSUME_NONNULL_END
