//
//  RACMapController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/6.
//

#import "RACMapController.h"
#import <ReactiveObjC.h>
#import <ReactiveObjC/RACReturnSignal.h>

@interface RACMapController ()


@end

@implementation RACMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    
    
}

- (void)testMap {
    //创建信号
    RACSubject *subject = [RACSubject subject];
    // 2.忽略一些值
    RACSignal *bindSignal = [subject map:^id _Nullable(NSString *value) {
        //返回的值 就是映射的值
        return [NSString stringWithFormat:@"tangge:%@",value];
    }];
    // 3.订阅信号
    [bindSignal subscribeNext:^(id x) {
        NSLog(@"--- %@", x);
    }];
    // 4.发送数据
    [subject sendNext:@"handsome"];
}

- (void)testFlatMap {
  
    //创建信号
    RACSubject *subject = [RACSubject subject];
    // 2.忽略一些值
    RACSignal *bindSignal = [subject flattenMap:^__kindof RACSignal * (id  value) {
        // 返回信号用来包装成修改内容的值
        return [RACReturnSignal return:value];
    }];
    
    // flattenMap中返回的是什么信号，订阅的就是什么信号
    [bindSignal subscribeNext:^(id x) {
        NSLog(@"--- %@", x);
    }];
    // 4.发送数据
    [subject sendNext:@"hanghang"];
    
}


- (void)testFlatMap2 {//信号中信号
    //创建信号
    RACSubject *signalofSignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
 
    [[signalofSignals flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return value;
    }] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"----- %@",x);
        
    }] ;
    
    [signalofSignals sendNext:signal];
    [signal sendNext:@"888"];
}

@end
