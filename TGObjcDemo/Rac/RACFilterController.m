//
//  RACFilterController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/6.
//

#import "RACFilterController.h"
#import <ReactiveObjC.h>

@interface RACFilterController ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation RACFilterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.textField];
    [self testFilter];
}

- (void)testSkip {
    // 跳跃 ： 如下，skip传入2 跳过前面两个值
    // 实际用处： 在实际开发中比如 后台返回的数据前面几个没用，我们想跳跃过去，便可以用skip
    
    RACSubject *subject = [RACSubject subject];
    [[subject skip:2] subscribeNext:^(id x) {
        NSLog(@"--- %@", x);
    }];
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
}

//订阅值去重
- (void)distinctUntilChanged {
    RACSubject *subject = [RACSubject subject];
    [[subject distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        NSLog(@"--- %@", x);
    }];
    
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@2]; //不会被订阅
    
}

//订阅前面几个值
- (void)testTake {
    RACSubject *subject = [RACSubject subject];
    [[subject take:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"--- %@", x);
    }];
    
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@2];
}

// takeLast:订阅后面的几个值，必须是发送完的
- (void)testTakeLast {
    
    RACSubject *subject = [RACSubject subject];
    [[subject takeLast:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"--- %@", x);
    }];
    
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
    [subject sendCompleted];
}

//给takeUntil传的是哪个信号，那么当这个信号发送信号或sendCompleted，就不能再接受源信号的内容了。
- (void)testTakeUntil {
    
    RACSubject *subject = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];
    [[subject takeUntil:subject2] subscribeNext:^(id x) {
        NSLog(@"xxx---- %@", x);
    }];
    // 发送信号
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject2 sendNext:@3];  // 1
//    [subject2 sendCompleted]; // 或2
    [subject sendNext:@4];
}

// ignore: 忽略掉一些值
- (void)testIgnore {
    //ignore:忽略一些值
    //ignoreValues:表示忽略所有的值
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    // 2.忽略一些值
    RACSignal *ignoreSignal = [subject ignore:@2]; // ignoreValues:表示忽略所有的值
    // 3.订阅信号
    [ignoreSignal subscribeNext:^(id x) {
        NSLog(@"--- %@", x);
    }];
    // 4.发送数据
    [subject sendNext:@1];
    [subject sendNext:@2];
    [subject sendNext:@3];
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.frame = CGRectMake(0, 200, 300, 30);
        _textField.backgroundColor = [UIColor greenColor];
    }
    return _textField;
}

- (void)testFilter {
    
    [[self.textField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return value.length > 5;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"----- %@",x);
    }];
    
}

@end
