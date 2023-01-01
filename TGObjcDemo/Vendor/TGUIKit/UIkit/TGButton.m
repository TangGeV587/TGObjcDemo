//
//  TGButton.m
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/1.
//

#import "TGButton.h"
#import <Masonry/Masonry.h>

@interface TGButton ()

@property(nonatomic,strong)UIImageView* glImageView;
@property(nonatomic,strong)UIImageView* glBackgroundImageView;

@property(nonatomic,strong)UILabel* glTitleLabel;
@property(nonatomic,strong)NSMutableDictionary* valueDictionary;
@property(nonatomic,assign)BOOL shouldReLayout;
@property(nonatomic,assign)BOOL shouldReConfigContent;

@property(nonatomic,assign)NSInteger setupUINum;
@property(nonatomic,assign)NSInteger configContentUINum;

@end

@implementation TGButton

-(instancetype)init{
    self = [self initWithStyle:TGButtonStyleTitleRight];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithStyle:(TGButtonStyle)style{
    self =[super init];
    if (self) {
        self.style = style;
        
        _contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
        self.space = 0;
        self.valueDictionary = [NSMutableDictionary dictionaryWithCapacity:20];
        [self addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
        [self setNeedReLayout];;
    }
    return self;
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"highlighted"];
    [self removeObserver:self forKeyPath:@"selected"];
    [self removeObserver:self forKeyPath:@"enabled"];
    [self removeObserver:self forKeyPath:@"state"];
}

- (void)setTitle:(nullable NSString *)title forState:(UIControlState)state{
    if (!title) {
        return;
    }
    [self.valueDictionary setValue:title forKey:[NSString stringWithFormat:@"title_%ld",state]];
    if (state == self.state) {
        [self setNeedReConfigContent];
    }
}
- (void)setTitleColor:(nullable UIColor *)color forState:(UIControlState)state{
    if (!color) {
        return;
    }
    [self.valueDictionary setValue:color forKey:[NSString stringWithFormat:@"titleColor_%ld",state]];
    if (state == self.state) {
        [self setNeedReConfigContent];
    }
}

- (void)setImageName:(nullable NSString *)imageName forState:(UIControlState)state{
    if (!imageName) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage* image = [UIImage imageNamed:imageName];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setImage:image forState:state];
        });
        
    });
    
}

- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state{
    if (!image) {
        return;
    }
    [self.valueDictionary setValue:image forKey:[NSString stringWithFormat:@"image_%ld",state]];
    if (state == self.state) {
        [self setNeedReConfigContent];
    }
}
- (void)setBackgroundImage:(nullable UIImage *)image forState:(UIControlState)state{
    if (!image) {
        return;
    }
    [self.valueDictionary setValue:image forKey:[NSString stringWithFormat:@"backgroundImage_%ld",state]];
    if (state == self.state) {
        [self setNeedReConfigContent];
    }
}
- (void)setBackgroundImageColor:(nullable UIColor *)imageColor forState:(UIControlState)state{
    if (!imageColor) {
        return;
    }
    [self.valueDictionary setValue:imageColor forKey:[NSString stringWithFormat:@"backgroundImageColor_%ld",state]];
    if (state == self.state) {
        [self setNeedReConfigContent];
    }
}
- (void)setBackgroundColor:(nullable UIColor *)color forState:(UIControlState)state{
    if (!color) {
        return;
    }
    [self.valueDictionary setValue:color forKey:[NSString stringWithFormat:@"backgroundColor_%ld",state]];
    if (state == self.state) {
        [self setNeedReConfigContent];
    }
}
- (void)setAttributedTitle:(nullable NSAttributedString *)title forState:(UIControlState)state{
    if (!title) {
        return;
    }
    [self.valueDictionary setValue:title forKey:[NSString stringWithFormat:@"attrTitle_%ld",state]];
    if (state == self.state) {
        [self setNeedReConfigContent];
    }
}

- (nullable NSString *)titleForState:(UIControlState)state{
    NSString* key = [NSString stringWithFormat:@"title_%ld",state];
    id value = [self.valueDictionary valueForKey:key];

    if (!value && state != UIControlStateNormal) {
        return [self.valueDictionary valueForKey:@"title_0"];
    }
    return value;
}
- (nullable UIColor *)titleColorForState:(UIControlState)state{
    NSString* key = [NSString stringWithFormat:@"titleColor_%ld",state];
    id value = [self.valueDictionary valueForKey:key];
    if (!value && state != UIControlStateNormal) {
        return [self.valueDictionary valueForKey:@"titleColor_0"];
    }
    return value;
}

- (nullable UIImage *)imageForState:(UIControlState)state{
    NSString* key = [NSString stringWithFormat:@"image_%ld",state];
    id value = [self.valueDictionary valueForKey:key];
    if (!value && state != UIControlStateNormal) {
        return [self.valueDictionary valueForKey:@"image_0"];
    }
    return value;
}
- (nullable UIImage *)backgroundImageForState:(UIControlState)state{
    NSString* key = [NSString stringWithFormat:@"backgroundImage_%ld",state];
    id value = [self.valueDictionary valueForKey:key];
    if (!value && state != UIControlStateNormal) {
        return [self.valueDictionary valueForKey:@"backgroundImage_0"];
    }
    return value;
}
- (nullable UIColor *)backgroundImageColorForState:(UIControlState)state{
    NSString* key = [NSString stringWithFormat:@"backgroundImageColor_%ld",state];
    id value = [self.valueDictionary valueForKey:key];
    if (!value && state != UIControlStateNormal) {
        return [self.valueDictionary valueForKey:@"backgroundImageColor_0"];
    }
    return value;
}
- (nullable UIColor *)backgroundColorForState:(UIControlState)state{
    NSString* key = [NSString stringWithFormat:@"backgroundColor_%ld",state];
    id value = [self.valueDictionary valueForKey:key];
    if (!value && state != UIControlStateNormal) {
        return [self.valueDictionary valueForKey:@"backgroundColor_0"];
    }
    return value;
}
- (nullable NSAttributedString *)attributedTitleForState:(UIControlState)state{
    NSString* key = [NSString stringWithFormat:@"attrTitle_%ld",state];
    id value = [self.valueDictionary valueForKey:key];
    if (!value && state != UIControlStateNormal) {
        return [self.valueDictionary valueForKey:@"attrTitle_0"];
    }
    return value;
}
- (UIImage*) createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


-(void)configContent{
    
    if (!self.shouldReConfigContent) {
        return;
    }
    self.shouldReConfigContent = NO;
    
//    self.configContentUINum++;
//    NSLog(@"kzy_num_configContentUI:%ld",self.configContentUINum);
    if (self.valueDictionary.count == 0) {
        return;
    }
    NSAttributedString* attrStr = [self attributedTitleForState:self.state];
    if (attrStr) {
        self.titleLabel.attributedText = attrStr;
    }else{
        NSString* title = [self titleForState:self.state];
        if (title) {
            self.titleLabel.text = title;
        }
        
    }
    UIColor* textColor = [self titleColorForState:self.state];
    if (textColor) {
        self.titleLabel.textColor = textColor;
    }
    UIImage* image = [self imageForState:self.state];
    if (image) {
        self.imageView.image = image;
        
        if (CGSizeEqualToSize(self.imageSize, CGSizeZero)) {
            CGFloat scale = image.size.height/image.size.width;
            __weak typeof(self.imageView)weakImage = self.imageView;
            [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(weakImage.mas_width).multipliedBy(scale);
            }];
        }
        
        
    }
    
    UIImage* bimage = [self backgroundImageForState:self.state];
    if (bimage) {
        self.glBackgroundImageView.image = bimage;
    }
    else if ([self backgroundImageColorForState:self.state]){
        UIColor *backImageColor = [self backgroundImageColorForState:self.state];
        if (backImageColor) {
            self.glBackgroundImageView.image = [self createImageWithColor:backImageColor];
        }
    }
    UIColor* backColor = [self backgroundColorForState:self.state];
    if (backColor) {
        self.backgroundColor = backColor;
    }
    
//    [self setNeedReLayout];
}

#pragma mark- KVO
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context{
    [self setNeedReConfigContent];
}

- (void)setNeedReLayout{
    self.shouldReLayout = YES;
    [self setNeedsLayout];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(layoutIfNeeded) object:nil];
    [self performSelector:@selector(layoutIfNeeded) withObject:nil afterDelay:0.1f];
//    [self layoutIfNeeded];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(layoutIfNeeded) object:nil];
//    [self performSelector:@selector(layoutIfNeeded) withObject:nil afterDelay:0.1f];

}
- (void)setNeedReConfigContent{
    self.shouldReConfigContent = YES;
    [self setNeedsLayout];
//    [self layoutIfNeeded];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(layoutIfNeeded) object:nil];
    [self performSelector:@selector(layoutIfNeeded) withObject:nil afterDelay:0.1f];
//    [self layoutIfNeeded];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self setupUI];
    [self configContent];
}

-(void)setupUI{
    if (!self.shouldReLayout) {
        return;
    }
//    self.setupUINum++;
//    NSLog(@"kzy_num_setupUINum:%ld",self.setupUINum);
    self.shouldReLayout= NO;
    [self addSubview:self.glBackgroundImageView];
    [self addSubview:self.glImageView];
    [self addSubview:self.glTitleLabel];
    
    [self.glBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backgroundImageEdgeInsets.left);
        make.right.mas_equalTo(-self.backgroundImageEdgeInsets.right);
        make.top.mas_equalTo(self.backgroundImageEdgeInsets.top);
        make.bottom.mas_equalTo(-self.backgroundImageEdgeInsets.bottom);
    }];
    __weak typeof(self)weakSelf = self;
    switch (self.style) {
        case TGButtonStyleTitleLeft:
        {
            [self.glTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf.contentEdgeInsets.left).priorityHigh();;
                make.top.mas_equalTo(weakSelf.contentEdgeInsets.top).priorityHigh();;
                make.centerY.mas_equalTo(0);
                make.bottom.mas_equalTo(-weakSelf.contentEdgeInsets.bottom).priorityHigh();;
                if (!CGSizeEqualToSize(weakSelf.titleSize, CGSizeZero)) {
                    make.size.mas_equalTo(weakSelf.titleSize);
                }
            }];
            [self.glImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.glTitleLabel.mas_right).offset(weakSelf.space).priorityHigh();
                make.top.mas_equalTo(weakSelf.contentEdgeInsets.top).priorityHigh();
                make.centerY.mas_equalTo(0);
                make.bottom.mas_equalTo(-weakSelf.contentEdgeInsets.bottom).priorityHigh();
                make.right.mas_equalTo(-weakSelf.contentEdgeInsets.right).priorityHigh();
                if (!CGSizeEqualToSize(weakSelf.imageSize, CGSizeZero)) {
                    make.width.mas_equalTo(weakSelf.imageSize.width);
                    make.height.mas_equalTo(weakSelf.imageSize.height);
                }
            }];
            
            
            break;
        }
        case TGButtonStyleTitleTop:
        {
            [self.glTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf.contentEdgeInsets.left).priorityHigh();
                make.top.mas_equalTo(weakSelf.contentEdgeInsets.top).priorityHigh();
                make.centerX.mas_equalTo(0);
                make.right.mas_equalTo(-weakSelf.contentEdgeInsets.right).priorityHigh();
                if (!CGSizeEqualToSize(weakSelf.titleSize, CGSizeZero)) {
                    make.size.mas_equalTo(weakSelf.titleSize);
                }
            }];
            [self.glImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf.contentEdgeInsets.left).priorityHigh();
                make.right.mas_equalTo(-weakSelf.contentEdgeInsets.right).priorityHigh();
                make.centerX.mas_equalTo(0);
                make.top.mas_equalTo(weakSelf.glTitleLabel.mas_bottom).offset(weakSelf.space).priorityHigh();
                make.bottom.mas_equalTo(-weakSelf.contentEdgeInsets.bottom).priorityHigh();
                if (!CGSizeEqualToSize(weakSelf.imageSize, CGSizeZero)) {
                    make.width.mas_equalTo(weakSelf.imageSize.width);
                    make.height.mas_equalTo(weakSelf.imageSize.height);
                }
            }];
            break;
        }
        case TGButtonStyleTitleBottom:
        {
            [self.glImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf.contentEdgeInsets.left).priorityHigh();
                make.top.mas_equalTo(weakSelf.contentEdgeInsets.top).priorityHigh();
                make.centerX.mas_equalTo(0);
                make.right.mas_equalTo(-weakSelf.contentEdgeInsets.right).priorityHigh();
                if (!CGSizeEqualToSize(weakSelf.imageSize, CGSizeZero)) {
                    make.width.mas_equalTo(weakSelf.imageSize.width);
                    make.height.mas_equalTo(weakSelf.imageSize.height);
                }
            }];
            
            [self.glTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf.contentEdgeInsets.left).priorityHigh();;
                make.right.mas_equalTo(-weakSelf.contentEdgeInsets.right).priorityHigh();;
                make.centerX.mas_equalTo(0);
                make.top.mas_equalTo(weakSelf.glImageView.mas_bottom).offset(weakSelf.space).priorityHigh();;
                make.bottom.mas_equalTo(-weakSelf.contentEdgeInsets.bottom).priorityHigh();
                
                if (!CGSizeEqualToSize(weakSelf.titleSize, CGSizeZero)) {
                    make.size.mas_equalTo(weakSelf.titleSize);
                }
            }];
            
            break;
        }
        case TGButtonStyleTitleRight:
        {
            [self.glImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf.contentEdgeInsets.left).priorityHigh();
                make.top.mas_equalTo(weakSelf.contentEdgeInsets.top).priorityHigh();
                make.bottom.mas_equalTo(-weakSelf.contentEdgeInsets.bottom).priorityHigh();
                make.centerY.mas_equalTo(0);
                if (!CGSizeEqualToSize(weakSelf.imageSize, CGSizeZero)) {
                    make.width.mas_equalTo(weakSelf.imageSize.width);
                    make.height.mas_equalTo(weakSelf.imageSize.height);
                }
            }];
            
            [self.glTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.glImageView.mas_right).offset(weakSelf.space).priorityHigh();
                make.top.mas_equalTo(weakSelf.contentEdgeInsets.top).priorityHigh();
                make.bottom.mas_equalTo(-weakSelf.contentEdgeInsets.bottom).priorityHigh();
                make.right.mas_equalTo(-weakSelf.contentEdgeInsets.right).priorityHigh();
                make.centerY.mas_equalTo(0);
                
                if (!CGSizeEqualToSize(weakSelf.titleSize, CGSizeZero)) {
                    make.size.mas_equalTo(weakSelf.titleSize);
                }
            }];
            
            break;
        }
        default:
            break;
    }
     
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)sizeToFit{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}
#pragma mark setter and getter
-(UIImageView*)glImageView{
    if (!_glImageView) {
        _glImageView = [[UIImageView alloc]init];
//        _glImageView.backgroundColor = [UIColor yellowColor];
        _glImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _glImageView;
}

-(UIImageView*)glBackgroundImageView{
    if (!_glBackgroundImageView) {
        _glBackgroundImageView = [[UIImageView alloc]init];
        _glBackgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _glBackgroundImageView;
}
-(UIImageView*)backgroundImageView{
    return self.glBackgroundImageView;
}

-(UIImageView*)imageView{
    return self.glImageView;
}
-(UILabel*)glTitleLabel{
    if (!_glTitleLabel) {
        _glTitleLabel = [[UILabel alloc]init];
        _glTitleLabel.font = [UIFont systemFontOfSize:15.f];
        _glTitleLabel.textAlignment = NSTextAlignmentCenter;
//        _glTitleLabel.backgroundColor = [UIColor redColor];
        _glTitleLabel.textColor = [UIColor blackColor];
    }
    return _glTitleLabel;
}

-(UILabel*)titleLabel{
    return self.glTitleLabel;
}

-(void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets{
    if (!UIEdgeInsetsEqualToEdgeInsets(_contentEdgeInsets, contentEdgeInsets)) {
        _contentEdgeInsets = contentEdgeInsets;
        [self setNeedReLayout];
    }
}
-(void)setSpace:(CGFloat)space{
    if (_space != space) {
        _space = space;
        [self setNeedReLayout];
    }
}

-(void)setImageSize:(CGSize)imageSize{
    _imageSize = imageSize;
    [self setNeedReLayout];
}

-(NSString*)currentTitle{
    return [self titleForState:self.state];
}
-(UIImage*)currentImage{
    return [self imageForState:self.state];
}
-(UIImage*)currentBackgroundImage{
    return [self backgroundImageForState:self.state];
}



@end
