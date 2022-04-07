//
//  RACCommondController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/6.
//

#import "RACCommondController.h"
#import <ReactiveObjC.h>

@interface RACCommondController ()

@end

@implementation RACCommondController

- (void)viewDidLoad {
    [super viewDidLoad];
    // RACCommand:RAC中用于处理事件的类，可以把事件如何处理，事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程，比如看事件有没有执行完毕
    // 使用场景：监听按钮点击，网络请求
    
}

- (void)test {
    //1、创建信号
    RACCommand *commond = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        //执行命令调用,input是执行命令传的参数
        NSLog(@"--- %@",input);
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"执行命令产生的数据"];
            return nil;
        }];
    }];
    
    
    //2.执行命令产生的数据
    
    //=============方式1======================
    //执行命令,这里用的是replaySubject 可以先发送命令再订阅
//    RACSignal *signal = [commond execute:@3];
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"---- %@",x);
//    }];
    
    //=============方式2======================
    
    // 注意：这里必须是先订阅才能发送命令
//    [commond.executionSignals subscribeNext:^(RACSignal *signal) {
//        executionSignals：信号源，信号中信号，发送数据就是信号
//        [signal subscribeNext:^(id  _Nullable x) {
//            NSLog(@"---- %@",x);
//        }];
//    }];
//    [commond execute:@4];
    
    //=============方式3======================
    
    // switchToLatest获取最新发送的信号，只能用于信号中信号
    [commond.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"---- %@",x);
    }];
    
    [commond execute:@5];
}

// 监听事件有没有完成
- (void)test1 {
  
    //注意：当前命令内部发送数据完成，一定要主动发送完成
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // block调用：执行命令的时候就会调用
        NSLog(@"%@", input);
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            // 发送数据
            [subscriber sendNext:@"执行命令产生的数据"];
            
            // *** 发送完成 **
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    // 监听事件有没有完成
    
    //默认会监测一次，所以可以使用skip表示跳过第一次信号。
    //这里可以用于App网络请求时，控制加载提示视图的隐藏或者显示
    [[command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) { //正在执行
            NSLog(@"正在执行");
        }else {//执行完成或没有执行
            NSLog(@"执行完成或没有执行");
        }
    }];
    
    //执行命令
    [command execute:@6];
}

// 信号中信号
- (void)test3 {
     RACSubject * signalOfSignal = [RACSubject subject];
     RACSubject * signal1 = [RACSubject subject];
     RACSubject * signal2 = [RACSubject subject];
     RACSubject * signal3 = [RACSubject subject];
     //switchToLatest :最新的信号!!
     [signalOfSignal.switchToLatest subscribeNext:^(id  _Nullable x) {
         NSLog(@"---- %@",x);
     }];
     
     //发送信号
     [signalOfSignal sendNext:signal1];
     [signalOfSignal sendNext:signal2];
     [signalOfSignal sendNext:signal3];
     //发送数据
     [signal3 sendNext:@"3"];
     [signal2 sendNext:@"2"];
     [signal1 sendNext:@"1"];
}
@end
