//
//  MBProgressHUD+GLCar.m
//  GLCoreKit-Example
//
//  Created by zhiyong.kuang on 2018/9/5.
//  Copyright © 2018年 zhiyong.kuang. All rights reserved.
//

#import "MBProgressHUD+GLCar.h"
#import <Masonry/Masonry.h>
#import <objc/runtime.h>

static char glcar_mbhud_mode_key;


@implementation MBProgressHUD (GLCar)

+ (instancetype)gl_showHUDAddedTo:(UIView *)view animated:(BOOL)animated{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    [hud gl_configStyle];
    return hud;
}

+ (nullable MBProgressHUD *)gl_HUDForView:(UIView *)view{
    MBProgressHUD* hud = [MBProgressHUD HUDForView:view];
    [hud gl_configStyle];
    return hud;
}

- (instancetype)gl_initWithView:(UIView *)view{
    [self initWithView:view];
    [self gl_configStyle];
    return self;
}

-(void)gl_configStyle{
    self.contentColor = [UIColor whiteColor];
    self.label.textColor = [UIColor whiteColor];
    self.detailsLabel.textColor = [UIColor whiteColor];
    self.bezelView.style = UIBlurEffectStyleDark;
    self.bezelView.backgroundColor =  [UIColor blackColor];
}

-(void)updateModeView{
    self.mode = MBProgressHUDModeCustomView;
    
    
    self.customView = ({
        SPActivityIndicatorView *activityIndicatorView = [[SPActivityIndicatorView alloc] initWithType:self.gl_modeType tintColor:[UIColor whiteColor]];

        
        [activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(75, 35));
        }];
        [activityIndicatorView startAnimating];
        activityIndicatorView;
    });
    
}

- (void)setGl_modeType:(SPActivityIndicatorAnimationType)gl_modeType{
    objc_setAssociatedObject(self, &glcar_mbhud_mode_key, [NSNumber numberWithInteger:gl_modeType], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self updateModeView];
}

- (SPActivityIndicatorAnimationType)gl_modeType{
    NSNumber* value = objc_getAssociatedObject(self, &glcar_mbhud_mode_key);
    if (!value) {
        return 0;
    }
    return [value integerValue];
}

+ (MBProgressHUD *)gl_showText:(NSString *)text icon:(NSString *)icon view:(UIView *)view hudOffset:(CGPoint )hudOffset {
    if (view == nil){
        NSArray* windowArray = [UIApplication sharedApplication].windows;
        for (UIWindow* win in windowArray) {
            if (win.hidden) {
                continue;
            }
            if (!CGRectEqualToRect(win.bounds, [UIScreen mainScreen].bounds)) {
                continue;
            }
            view = win;
            break;
        }
        
        if (!view) {
            view = [[UIApplication sharedApplication] keyWindow];
        }
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.contentColor = [UIColor sw_colorWithHexStr:@"#262433"];
    
    hud.label.text = text;
    // 判断是否显示图片
    if (icon == nil) {
        hud.mode = MBProgressHUDModeText;
    }else{
        // 设置图片
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]];
        img = img == nil ? [UIImage imageNamed:icon] : img;
        hud.customView = [[UIImageView alloc] initWithImage:img];
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
    }
    hud.bezelView.color = [UIColor blackColor];
//    hud.bezelView.style = UIBlurEffectStyleDark;
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.textColor = [UIColor whiteColor];
    hud.offset = hudOffset;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 指定时间之后再消失
    [hud hideAnimated:YES afterDelay:1.5];
    return hud;
}

@end
