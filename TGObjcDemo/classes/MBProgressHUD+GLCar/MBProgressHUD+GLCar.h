//
//  MBProgressHUD+GLCar.h
//  GLCoreKit-Example
//
//  Created by zhiyong.kuang on 2018/9/5.
//  Copyright © 2018年 zhiyong.kuang. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import "SPActivityIndicatorView.h"

@interface MBProgressHUD (GLCar)


+ (instancetype)gl_showHUDAddedTo:(UIView *)view animated:(BOOL)animated;

+ (nullable MBProgressHUD *)gl_HUDForView:(UIView *)view;

- (instancetype)gl_initWithView:(UIView *)view;

+ (MBProgressHUD *)gl_showText:(NSString *)text icon:(NSString *)icon view:(UIView *)view hudOffset:(CGPoint )hudOffset;

@property (assign, nonatomic) SPActivityIndicatorAnimationType gl_modeType;


@end
