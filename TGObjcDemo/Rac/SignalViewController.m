//
//  SignalViewController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/2.
//

#import "SignalViewController.h"
#import <ReactiveObjC.h>

@interface SignalViewController ()

@end

@implementation SignalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupuI];
}

- (void)setupuI {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)testRACSignal2 {
    //创建一个信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送信号
        [subscriber sendNext:@"hello"];
        return nil;
    }];
    
    //订阅信号
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (void)testRACDisposeable {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"hello"];
        /*
         当订阅者发送了sendCompleted 或senfError 就'相当于'结束订阅了, 可以理解成订阅者就销毁了
         当订阅者没有被全局变量所引用时, sendNext 之后, 就'相当于'结束订阅了, 可以理解成订阅者就销毁了
         当订阅者被销毁后，不会再发送信号
         */
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"订阅者销毁了");
        }];
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}



- (void)testSignal1 {
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 3.发送信号
        [subscriber sendNext:@"ws"];
        // 4.取消信号，如果信号想要被取消，就必须返回一个RACDisposable
        // 信号什么时候被取消：1.自动取消，当一个信号的订阅者被销毁的时候机会自动取消订阅，2.手动取消，
        //block什么时候调用：一旦一个信号被取消订阅就会调用
        //block作用：当信号被取消时用于清空一些资源
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"取消订阅");
        }];
    }];
    // 2. 订阅信号
    //subscribeNext
    // 把nextBlock保存到订阅者里面
    // 只要订阅信号就会返回一个取消订阅信号的类
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        // block的调用时刻：只要信号内部发出数据就会调用这个block
        NSLog(@"======%@", x);
    }];
    // 取消订阅
    [disposable dispose];

}

- (void)testSignal {
    
    // 创建源信号
    RACSignal *sourceSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"hello, "];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"源信号被销毁, 这里进行收尾工作...");
        }];
    }];
    
    // 进行bind, 返回绑定信号
    RACSignal *bindSignal = [sourceSignal bind:^RACSignalBindBlock _Nonnull{
        RACSignalBindBlock bindBlock = ^RACSignal*(id value, BOOL *stop) {
            RACSignal *returnSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                // 修改值
                NSString *newValue = [NSString stringWithFormat:@"%@%@", value, @"ReacticeCocoa bind"];
                
                [subscriber sendNext:newValue];
                
                return [RACDisposable disposableWithBlock:^{
                    NSLog(@"返回信号被销毁, 这里进行收尾工作...");
                }];
            }];
            return returnSignal;
        };
        return bindBlock;
    }];
    // 订阅绑定信号
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收到信号传送的值: %@", x);
    } completed:^{
        NSLog(@"信号发送完毕");
    }];
}


@end
