//
//  UINavigationController+TGAutorotate.m
//  TGObjcDemo
//
//  Created by hanghang on 2022/11/30.
//

#import "UINavigationController+TGAutorotate.h"

@implementation UINavigationController (TGAutorotate)

//当前界面是否开启自动转屏
- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

//返回支持的旋转方向
- (NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

//返回进入界面默认显示方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}


@end


@implementation UITabBarController (TGAutorotate)

- (BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

@end
