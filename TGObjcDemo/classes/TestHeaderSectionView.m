//
//  TestHeaderSectionView.m
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/4.
//

#import "TestHeaderSectionView.h"

@interface TestHeaderSectionView ()

@property (nonatomic , strong) UILabel *contentL;

@end

@implementation TestHeaderSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.contentL];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentL.frame = self.contentView.bounds;
}

#pragma mark setter

- (void)setContent:(NSString *)content {
    _content = content;
    self.contentL.text = content;
}

#pragma mark lazy

- (UILabel *)contentL {
    if (_contentL == nil) {
        _contentL = [[UILabel alloc] init];
        _contentL.text = @"footerLabel";
        _contentL.backgroundColor = [UIColor orangeColor];
        _contentL.textColor = [UIColor blueColor];
    }
    return _contentL;
}

@end
