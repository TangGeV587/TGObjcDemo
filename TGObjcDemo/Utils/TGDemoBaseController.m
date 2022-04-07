//
//  TGDemoBaseController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/2.
//

#import "TGDemoBaseController.h"

@interface TGDemoBaseController ()

@end

@implementation TGDemoBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialUI];
}

- (void)initialUI {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

- (CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

@end
