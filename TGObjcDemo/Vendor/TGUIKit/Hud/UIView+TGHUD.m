//
//  UIView+TGHUD.m
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/6.
//

#import "UIView+TGHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>

NSString * TGHUDPositionTop                       = @"TGHUDPositionTop";
NSString * TGHUDPositionCenter                    = @"TGHUDPositionCenter";
NSString * TGHUDPositionBottom                    = @"TGHUDPositionBottom";

#define TGHUD_DEFAULT_DURATION 1.5f

#define TGHUD_UNSET_VALUE 9999


@implementation TGHUDDefaultConfig

+ (TGHUDDefaultConfig*)sharedConfig
{
    //Singleton instance
    static TGHUDDefaultConfig *__TGHUDConfig;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __TGHUDConfig = [[self alloc] init];
        __TGHUDConfig.style = TGHUDStyleDark;
        __TGHUDConfig.animation = TGHUD_UNSET_VALUE;
        __TGHUDConfig.cornerRadius = TGHUD_UNSET_VALUE;
        __TGHUDConfig.duration = TGHUD_DEFAULT_DURATION;
        __TGHUDConfig.imageRenderingByContentColor = NO;
        __TGHUDConfig.position = TGHUDPositionCenter;
        
    });
    
    return __TGHUDConfig;
}

-(UIImage*)infoImage{
    if (!_infoImage) {
        _infoImage = [UIImage imageNamed:@"tg_toast_info"];
    }
    return _infoImage;
}

-(UIImage*)successImage{
    if (!_successImage) {
        _successImage = [UIImage imageNamed:@"tg_toast_success"];
    }
    return _successImage;
}

-(UIImage*)errorImage{
    if (!_errorImage) {
        _errorImage = [UIImage imageNamed:@"tg_toast_error"];
    }
    return _errorImage;
}
- (void)setStyle:(TGHUDStyle)style{
    _style = style;
    if (_style == TGHUDStyleDark) {
        self.contentBackgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
        self.contentColor = [UIColor whiteColor];
    }

}
@end

@implementation UIView (TGHUD)

#pragma mark - Helpers

- (MBProgressHUD*)tg_makeHUD{
    
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    }
    

    //设置等待框背景色为黑色
    if ([TGHUDDefaultConfig sharedConfig].contentBackgroundColor) {
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = [TGHUDDefaultConfig sharedConfig].contentBackgroundColor;
    }
    
    if ([TGHUDDefaultConfig sharedConfig].contentColor) {
        hud.contentColor = [TGHUDDefaultConfig sharedConfig].contentColor;
    }
    
    if ([TGHUDDefaultConfig sharedConfig].font) {
        hud.label.font = [TGHUDDefaultConfig sharedConfig].font;
    }
    if ([TGHUDDefaultConfig sharedConfig].cornerRadius != TGHUD_UNSET_VALUE) {
        hud.bezelView.layer.cornerRadius = [TGHUDDefaultConfig sharedConfig].cornerRadius;
    }

    if ([TGHUDDefaultConfig sharedConfig].animation != TGHUD_UNSET_VALUE) {
        hud.animationType = [TGHUDDefaultConfig sharedConfig].animation;
    }
    
    hud.removeFromSuperViewOnHide = YES;
   
    
    return hud;
}

- (CGPoint)tg_centerPointForPosition:(id)point{
    
    UIEdgeInsets safeInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        safeInsets = self.safeAreaInsets;
    }
    
    CGFloat topPadding = safeInsets.top;
    CGFloat bottomPadding = safeInsets.bottom;
    
    if([point isKindOfClass:[NSString class]]) {
        if([point caseInsensitiveCompare:TGHUDPositionTop] == NSOrderedSame) {
            return CGPointMake(0,-MBProgressMaxOffset);
        } else if([point caseInsensitiveCompare:TGHUDPositionCenter] == NSOrderedSame) {
            return CGPointZero;
        }
    } else if ([point isKindOfClass:[NSValue class]]) {
        return [point CGPointValue];
    }
    
    // default to bottom
    return CGPointMake(0, MBProgressMaxOffset);
}



- (void)tg_makeToast:(NSString *)message{
    [self tg_makeToast:message duration:[TGHUDDefaultConfig sharedConfig].duration position:[TGHUDDefaultConfig sharedConfig].position];
}

- (void)tg_makeToast:(NSString *)message
            duration:(NSTimeInterval)duration
            position:(id)position{
    [self tg_makeToast:message duration:duration position:position image:nil];
}



- (void)tg_makeToast:(NSString *)message
            duration:(NSTimeInterval)duration
            position:(id)position
               image:(UIImage *)image{
    MBProgressHUD *hud = [self tg_makeHUD];


    if (image) {
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        if ([TGHUDDefaultConfig sharedConfig].imageRenderingByContentColor && [TGHUDDefaultConfig sharedConfig].contentColor) {
            imageView.image = [imageView.image imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
            imageView.tintColor = [TGHUDDefaultConfig sharedConfig].contentColor;
        }
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
    }else{
        hud.mode = MBProgressHUDModeText;
    }
   
    hud.label.text = message;
    hud.label.numberOfLines = 0;
    hud.offset = [self tg_centerPointForPosition:position];
    [hud hideAnimated:YES afterDelay:duration];
}

- (void)tg_makeInfoToast:(NSString *)message{
    [self tg_makeToast:message duration:[TGHUDDefaultConfig sharedConfig].duration position:TGHUDPositionCenter image:[TGHUDDefaultConfig sharedConfig].infoImage];
}
- (void)tg_makeSuccessToast:(NSString *)message{
    [self tg_makeToast:message duration:[TGHUDDefaultConfig sharedConfig].duration position:TGHUDPositionCenter image:[TGHUDDefaultConfig sharedConfig].successImage];
}
- (void)tg_makeErrorToast:(NSString *)message{
    [self tg_makeToast:message duration:[TGHUDDefaultConfig sharedConfig].duration position:TGHUDPositionCenter image:[TGHUDDefaultConfig sharedConfig].errorImage];
}

- (void)tg_hideToast{
    [MBProgressHUD hideHUDForView:self animated:YES];
}

- (MBProgressHUD*)tg_makeLoading:(NSString *)message{
    MBProgressHUD *hud = [self tg_makeHUD];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = message;
    hud.label.numberOfLines = 0;
    hud.offset = [self tg_centerPointForPosition:TGHUDPositionCenter];
    return hud;
}


@end
