//
//  SubjectSubController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/3/28.
//

#import "SubjectSubController.h"

@interface SubjectSubController ()

@property(nonatomic, copy)UIButton *button;

@end

@implementation SubjectSubController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    [self buildUI];
}
- (void)buildUI {
    
    self.button.frame = CGRectMake(50, 100, 50, 30);
    self.view.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.button];
}

#pragma mark---lazy loading
- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] init];
        [_button setBackgroundColor:[UIColor grayColor]];
        [_button setTitle:@"pop" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(btnOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
#pragma mark -- btnOnClick
- (void)btnOnClick {
    
//    [self.subject sendNext:@"nnn"];
//    [self.subject sendCompleted];
    [self.subject sendNext:@"nyy"];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  总结：
 我们完全可以用RACSubject代替代理/通知，确实方便许多
 这里我们点击TwoViewController的pop的时候 将字符串"ws"传给了ViewController的button的title。
 步骤：
 // 1.创建信号
 RACSubject *subject = [RACSubject subject];
 
 // 2.订阅信号
 [subject subscribeNext:^(id x) {
 // block:当有数据发出的时候就会调用
 // block:处理数据
 NSLog(@"%@",x);
 }];
 
 // 3.发送信号
 [subject sendNext:value];
 **注意：~~**
 RACSubject和RACReplaySubject的区别
 RACSubject必须要先订阅信号之后才能发送信号， 而RACReplaySubject可以先发送信号后订阅.
 RACSubject 代码中体现为：先走TwoViewController的sendNext，后走ViewController的subscribeNext订阅
 RACReplaySubject 代码中体现为：先走ViewController的subscribeNext订阅，后走TwoViewController的sendNext
 可按实际情况各取所需。

 */

//RACBehaviorSubject

@end
