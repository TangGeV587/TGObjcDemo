//
//  UIView+TGHUD.h
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/6.
//

#import <UIKit/UIKit.h>

@protocol TGHUDProtocol  <NSObject>
- (void)hideAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated afterDelay:(NSTimeInterval)delay;
@end

typedef NS_ENUM(NSInteger, TGHUDStyle) {
    TGHUDStyleLight,        // default style, white HUD with black text, HUD background will be blurred
    TGHUDStyleDark,         // black HUD and white text, HUD background will be blurred
    TGHUDStyleCustom        // uses the fore- and background color properties
};

typedef NS_ENUM(NSInteger, TGHUDAnimation) {
    /// Opacity animation
    TGHUDAnimationFade,
    /// Opacity + scale animation (zoom in when appearing zoom out when disappearing)
    TGHUDAnimationZoom,
    /// Opacity + scale animation (zoom out style)
    TGHUDAnimationZoomOut,
    /// Opacity + scale animation (zoom in style)
    TGHUDAnimationZoomIn
};

@interface TGHUDDefaultConfig : NSObject


@property(nonatomic,assign)TGHUDStyle style;
@property(nonatomic,assign)TGHUDAnimation animation;
@property(nonatomic,assign)CGFloat cornerRadius;

@property(nonatomic,assign)CGFloat duration;

@property(nonatomic,strong)UIColor* contentColor;
@property(nonatomic,strong)UIColor* contentBackgroundColor;


@property(nonatomic,strong)UIFont* font;
@property(nonatomic,strong)id position;

@property(nonatomic,strong)UIImage* infoImage;
@property(nonatomic,strong)UIImage* successImage;
@property(nonatomic,strong)UIImage* errorImage;
@property(nonatomic,assign)BOOL imageRenderingByContentColor;

+ (TGHUDDefaultConfig*)sharedConfig;
@end


extern const NSString * TGHUDPositionTop;
extern const NSString * TGHUDPositionCenter;
extern const NSString * TGHUDPositionBottom;


@interface UIView (TGHUD)



- (void)tg_makeToast:(NSString *)message;

- (void)tg_makeToast:(NSString *)message
            duration:(NSTimeInterval)duration
            position:(id)position;



- (void)tg_makeToast:(NSString *)message
            duration:(NSTimeInterval)duration
            position:(id)position
               image:(UIImage *)image;


- (void)tg_hideToast;


- (void)tg_makeInfoToast:(NSString *)message;
- (void)tg_makeSuccessToast:(NSString *)message;
- (void)tg_makeErrorToast:(NSString *)message;

- (UIView<TGHUDProtocol> *)tg_makeLoading:(NSString *)message;
@end
