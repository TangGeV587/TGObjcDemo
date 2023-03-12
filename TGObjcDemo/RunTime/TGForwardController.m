//
//  TGForwardController.m
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/15.
//

#import "TGForwardController.h"



@implementation TGDog 

#pragma mark - 快速转发
/** 返回未识别消息重定向的对象
    指定对象去接受这个消息
 */
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(climbAction)) {
        return [[TGCat alloc] init];
    }
    return [super forwardingTargetForSelector:aSelector];
}

#pragma mark - 慢速转发

//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//    if (aSelector == @selector(climbAction)) {
//        return [NSMethodSignature methodSignatureForSelector:aSelector];
//    }
//    return  [super methodSignatureForSelector:aSelector];
//}

@end

@implementation TGCat

- (void)climbAction {
    
    NSLog(@"%s",__func__);
}

@end

@interface TGForwardController ()

@end

@implementation TGForwardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = @"消息转发";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    TGDog *dog = [[TGDog alloc] init];
    [dog performSelector:@selector(climbAction)];
}


@end
