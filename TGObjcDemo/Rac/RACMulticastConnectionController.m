//
//  RACMulticastConnectionController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/2.
//

#import "RACMulticastConnectionController.h"
#import <ReactiveObjC.h>

@interface RACMulticastConnectionController ()

@end

@implementation RACMulticastConnectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
}
/**
 *  当有多个订阅者，但是我们只想发送一个信号的时候怎么办？这时我们就可以用RACMulticastConnection，来实现。代码示例如下
 */
- (void)testSubscribe1 { // 普通写法, 这样的缺点是：没订阅一次信号就得重新创建并发送请求，这样很不友好
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // didSubscribeblock中的代码都统称为副作用。
        // 发送请求---比如afn
        NSLog(@"发送请求啦");
        // 发送信号
        [subscriber sendNext:@"ws"];
        return nil;
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    //打印日志：
    /**
     2022-04-02 15:33:43.810679+0800 TGObjcDemo[1422:11206913] 发送请求啦
     2022-04-02 15:33:43.810799+0800 TGObjcDemo[1422:11206913] ws
     2022-04-02 15:33:43.810918+0800 TGObjcDemo[1422:11206913] 发送请求啦
     2022-04-02 15:33:43.811016+0800 TGObjcDemo[1422:11206913] ws
     2022-04-02 15:33:43.811117+0800 TGObjcDemo[1422:11206913] 发送请求啦
     2022-04-02 15:33:43.811217+0800 TGObjcDemo[1422:11206913] ws
     */
}

- (void)testRACMulticastConnection {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"发送请求啦");
        // 发送信号
        [subscriber sendNext:@"ws"];
        return nil;
    }];
    //2. 创建连接类
    RACMulticastConnection *connection = [signal publish];
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [connection.signal subscribeNext:^(id x) {
         NSLog(@"%@", x);
    }];
    [connection.signal subscribeNext:^(id x) {
         NSLog(@"%@", x);
    }];
    //3. 连接。只有连接了才会把信号源变为热信号
    [connection connect];
    
    //打印日志：
    /**
     2022-04-02 15:47:20.490941+0800 TGObjcDemo[1839:11220045] 发送请求啦
     2022-04-02 15:47:20.491057+0800 TGObjcDemo[1839:11220045] ws
     2022-04-02 15:47:20.491140+0800 TGObjcDemo[1839:11220045] ws
     2022-04-02 15:47:20.491224+0800 TGObjcDemo[1839:11220045] ws
     */
}

#pragma mark - 多次订阅，多次执行block
- (void)testRACMulticastConnection2 {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送信号
        NSLog(@"发送热门模块请求");
        [subscriber sendNext:@"1"];
        return nil;
    }];
    //订阅信号
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅1 : %@", x);
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅2 : %@", x);
    }];
}

#pragma mark - RACMulticastConnection

- (void)testRACMulticastConnection3 {
    // 1. 创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable* (id subscriber) {
        NSLog(@"发送热门模块请求");
        [subscriber sendNext:@1];
        return nil;
    }];
    
    // 2. 把信号转换成连接类
    RACMulticastConnection *signalConn = [signal publish];
    // 确定源信号的订阅者RACSubject
    //    RACMulticastConnection *signalConn = [signal multicast:[RACReplaySubject subject]];
    // 3. 多个订阅
    [signalConn.signal subscribeNext:^(id _Nullable x) {
        NSLog(@"订阅1 : %@", x);
    }];
    [signalConn.signal subscribeNext:^(id _Nullable x) {
        NSLog(@"订阅2 : %@", x);
    }];
    [signalConn.signal subscribeNext:^(id _Nullable x) {
        NSLog(@"订阅3 : %@", x);
    }];
    // 4. 连接
    [signalConn connect];
}

@end
