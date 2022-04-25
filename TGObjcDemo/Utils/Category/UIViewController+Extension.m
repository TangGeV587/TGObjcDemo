//
//  UIViewController+Extension.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/24.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_instanceMethod([UIViewController class], @selector(viewDidLoad), @selector(TG_viewDidLoad));
    });
}

- (void)TG_viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    [self TG_viewDidLoad];
}

@end
