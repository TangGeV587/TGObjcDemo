//
//  RACSubjectViewController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/3/25.
//

#import "RACSubjectViewController.h"
#import "SubjectSubController.h"
#import <ReactiveObjC.h>

@interface RACSubjectViewController ()

@property(nonatomic, copy) UIButton *button;

@end

@implementation RACSubjectViewController

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

- (void)testRACSubject {
    RACSubject *subject = [[RACSubject alloc] init];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"test1"];
    [subject sendNext:@"test2"];
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
    
    __weak typeof(self) weakSelf = self;
//    RACSubject *subject = [RACSubject subject];
//    [subject subscribeNext:^(NSString  *title) {
//
//        [weakSelf.button setTitle:title forState:UIControlStateNormal];
//    } completed:^{
//
//        NSLog(@"OK拉");
//    }];
    
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    [replaySubject subscribeNext:^(NSString  *title) {
        NSLog(@"---> %@",title);
        [weakSelf.button setTitle:title forState:UIControlStateNormal];

    } completed:^{
        NSLog(@"OK拉");
    }];
    
    SubjectSubController *subjectVC = [[SubjectSubController alloc] init];
    subjectVC.subject = replaySubject;
    [self.navigationController pushViewController:subjectVC animated:YES];
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
@end
