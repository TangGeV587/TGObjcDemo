//
//  TGButton.h
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/1.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TGButtonStyle) {
    TGButtonStyleTitleRight,
    TGButtonStyleTitleLeft,
    TGButtonStyleTitleTop,
    TGButtonStyleTitleBottom,
};

NS_ASSUME_NONNULL_BEGIN

@interface TGButton : UIControl

@property(nonatomic,assign)          UIEdgeInsets contentEdgeInsets;
@property(nonatomic,strong,readonly)   UILabel     *titleLabel;
@property(nonatomic,strong,readonly)   UIImageView     *imageView;
@property(nonatomic,strong,readonly)   UIImageView     *backgroundImageView;
@property(nonatomic,assign)          UIEdgeInsets backgroundImageEdgeInsets;

@property(nonatomic,assign)   CGFloat space;//default 5;
@property(nonatomic,assign)   CGSize titleSize;
@property(nonatomic,assign)   CGSize imageSize;
@property(nonatomic,assign)   TGButtonStyle style;

- (instancetype)initWithStyle:(TGButtonStyle)style;

- (void)setTitle:(nullable NSString *)title forState:(UIControlState)state;
- (void)setTitleColor:(nullable UIColor *)color forState:(UIControlState)state;
- (void)setImageName:(nullable NSString *)imageName forState:(UIControlState)state;
- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state;
- (void)setBackgroundImage:(nullable UIImage *)image forState:(UIControlState)state;
- (void)setBackgroundImageColor:(nullable UIColor *)imageColor forState:(UIControlState)state;
- (void)setBackgroundColor:(nullable UIColor *)imageColor forState:(UIControlState)state;

- (void)setAttributedTitle:(nullable NSAttributedString *)title forState:(UIControlState)state;


- (nullable NSString *)titleForState:(UIControlState)state;          // these getters only take a single state value
- (nullable UIColor *)titleColorForState:(UIControlState)state;
- (nullable UIImage *)imageForState:(UIControlState)state;
- (nullable UIImage *)backgroundImageForState:(UIControlState)state;
- (nullable UIColor *)backgroundImageColorForState:(UIControlState)state;
- (nullable UIColor *)backgroundColorForState:(UIControlState)state;
- (nullable NSAttributedString *)attributedTitleForState:(UIControlState)state;

@property(nullable, nonatomic,readonly,strong) NSString *currentTitle;             // normal/highlighted/selected/disabled. can return nil
@property(nullable, nonatomic,readonly,strong) UIImage  *currentImage;             // normal/highlighted/selected/disabled. can return nil
@property(nullable, nonatomic,readonly,strong) UIImage  *currentBackgroundImage;   // normal/highlighted/selected/disabled. can return nil

- (void)setNeedReLayout;


@end

NS_ASSUME_NONNULL_END
