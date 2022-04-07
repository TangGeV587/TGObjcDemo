//
//  RACCombineController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/7.
//

#import "RACCombineController.h"
#import <ReactiveObjC.h>

@interface RACCombineController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation RACCombineController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = @"映射";
    [self.view addSubview:self.textField];
    [self.view addSubview:self.pwdTF];
    [self.view addSubview:self.loginBtn];
    [self testCombineLast];
}


//把多个信号聚合成一个信号,使用场景: 输入框都输入 登录按钮才可以点击
- (void)testCombineLast {
    
    RACSignal *combineSignal = [RACSignal combineLatest:@[self.textField.rac_textSignal,self.pwdTF.rac_textSignal] reduce:^id(NSString *account, NSString *pwd){
        //reduce用于信号发出的内容是元组，把信号发出元组的值聚合成一个值,reduce里的参数要和combineLatest数组里的一一对应。
        NSLog(@"--- %@ %@", account, pwd);
        return @(account.length && pwd.length);
    }];
    
    //    [combinSignal subscribeNext:^(id x) {
    //        self.loginBtn.enabled = [x boolValue];
    //    }];    // ----这样写有些麻烦，可以直接用RAC宏
    
    RAC(self.loginBtn,enabled) = combineSignal;
}

- (void)testZipWith {
    
    //创建信号
    RACSubject *subjectA = [RACSubject subject];
    RACSubject *subjectB = [RACSubject subject];
    //zipWith:把两个信号压缩成一个信号，可以理解为队列组 ，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元祖，才会触发压缩流的next事件。使用场景:当一个界面多个请求的时候，要等所有请求完成才更新UI
    [[subjectA zipWith:subjectB] subscribeNext:^(id  _Nullable x) {
        //所有的值都被包装成了元组
        NSLog(@"--- %@",x);
    }];
    // 元祖顺序与压缩的顺序有关[signalA zipWith:signalB]---先是A后是B
    [subjectA sendNext:@"111"];
    [subjectB sendNext:@"222"];
    
}

// 任何一个信号请求完成都会被订阅到
- (void)testMerge {
    //创建信号
    RACSubject *subjectA = [RACSubject subject];
    RACSubject *subjectB = [RACSubject subject];
    // merge:多个信号合并成一个信号，任何一个信号有新值就会调用
    [[subjectA merge:subjectB] subscribeNext:^(id  _Nullable x) {
        NSLog(@"----- %@",x);
    }];
    
    // 发送信号---交换位置则数据结果顺序也会交换
    [subjectB sendNext:@"bbbb"];
    [subjectA sendNext:@"xxxx"];
}

// then --- 用于连接两个信号，当第一个信号完成，才会连接then返回的信号
- (void)testThen {
    // 使用需求：有两部分数据：想让上部分先进行网络请求但是过滤掉数据，然后进行下部分的，拿到下部分数据
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"----发送上部分请求 A---afn");
        
        [subscriber sendNext:@"A"];
        [subscriber sendCompleted]; // 必须要调用sendCompleted方法！
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"--发送下部分请求 B--afn");
        [subscriber sendNext:@"B"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    // then:忽略掉第一个信号的值
    [[signalA then:^RACSignal * _Nonnull{
        // 返回的信号就是要组合的信号
        return signalB;
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"---- %@",x);
    }];
}


- (void)testContact {
    
    // concat----- 使用需求：有两部分数据：想让上部分先执行，完了之后再让下部分执行（都可获取值）
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"----发送上部分请求 A---afn");
        
        [subscriber sendNext:@"A"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"--发送下部分请求 B--afn");
        [subscriber sendNext:@"B"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    // concat:按顺序去链接
    //**-注意-**：concat，第一个信号必须要调用sendCompleted
    [[signalA concat:signalB] subscribeNext:^(id  _Nullable x) {
        NSLog(@"---- %@",x);
    }];
}


#pragma mark - action

- (void)loginAction {
    NSLog(@"登录");
}
#pragma mark - getter

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        CGFloat x = (self.screenWidth - 200) * 0.5;
        _textField.placeholder = @"请输入用户名";
        _textField.frame = CGRectMake(x, 200, 200, 30);
        _textField.backgroundColor = [UIColor greenColor];
    }
    return _textField;
}

- (UITextField *)pwdTF {
    if (_pwdTF == nil) {
        _pwdTF = [[UITextField alloc] init];
        CGFloat x = (self.screenWidth - 200) * 0.5;
        _pwdTF.frame = CGRectMake(x, 250, 200, 30);
        _pwdTF.placeholder = @"请输入密码";
        _pwdTF.backgroundColor = [UIColor greenColor];
    }
    return _pwdTF;
}

- (UIButton *)loginBtn {
    if (_loginBtn == nil) {
        _loginBtn = [[UIButton alloc] init];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _loginBtn.backgroundColor = [UIColor brownColor];
        CGFloat x = (self.screenWidth - 200) * 0.5;
        _loginBtn.frame = CGRectMake(x, 320, 200, 44);
        [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.enabled = NO;
    }
    return _loginBtn;
}


@end
