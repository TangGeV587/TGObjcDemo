//
//  RACOtherController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/7.
//

#import "RACOtherController.h"
#import <ReactiveObjC.h>

@interface RACOtherController ()

@end

@implementation RACOtherController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = @"其他";
    [self testLiftSelector];
}

- (void)testLiftSelector {
    //请求1
    RACSignal * signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送请求
        NSLog(@"请求网络数据 1");
        //发送数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"数据1 来了"];
        });
        return nil;
    }];
    
    //请求2
    RACSignal * signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //发送请求
        NSLog(@"请求网络数据 2");
        //发送数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"数据2 来了"];
        });
        return nil;
    }];
    
    //当数组中的所有洗好都发送了数据,才会执行Selector ,方法的参数:必须和数组的信号一一对应!!
    [self rac_liftSelector:@selector(updateUIWithOneData:TwoData:) withSignalsFromArray:@[signal1,signal2]];
    
}

- (void)updateUIWithOneData:(id )oneData TwoData:(id )twoData {
    NSLog(@"%@",[NSThread currentThread]);
    //拿到数据更新UI
    NSLog(@"UI!!%@%@",oneData,twoData);
}



- (void)testInterval {
        
    //创建一个定时器,指定销毁时间
    RACSignal *rac_disappear = [self rac_signalForSelector:@selector(viewWillDisappear:)];
    [[[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:rac_disappear] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"***** second 延时rac写法  ***** %@",x);
    }];

}

- (void)testDelay {
    //delay:延迟多久后,订阅 block 才会被调用
    RACSignal *delaySignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"发送信号");
        [subscriber sendNext:@"hanghang"];
        return nil;
    }];
    
    [[delaySignal delay:3.0] subscribeNext:^(id  _Nullable x) {
        NSLog(@"---- %@",x);
    }];
}

- (void)testTimeout {
    RACSignal *timeOutSignal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"timeOutSignal发送信号"];
        //[subscriber sendCompleted];
        return nil;
    }] timeout:5 onScheduler:[RACScheduler currentScheduler]];
       
    [timeOutSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"timeOutSignal:%@",x);
     } error:^(NSError * _Nullable error) {
        //5秒后执行打印：
        //timeOutSignal:出现Error-Error Domain=RACSignalErrorDomain Code=1 "(null)"
        NSLog(@"timeOutSignal:出现Error-%@",error);
    } completed:^{
        NSLog(@"timeOutSignal:complete");
    }];
}

- (void)testRetry {
//    retry: 只要失败，就会重新执行创建信号中的block,直到成功
    static int signalANum = 0;
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        if (signalANum == 3) {
            [subscriber sendNext:@"signalANum is 3"];
            [subscriber sendCompleted];
        }else{
            NSLog(@"signalANum错误！！!");
            [subscriber sendError:nil];
        }
        signalANum++;
        return nil;
    }];
      
    [[signalA retry] subscribeNext:^(id  _Nullable x) {
        NSLog(@"StringA-Next：%@",x);
    } error:^(NSError * _Nullable error) {
        //特别注意：这里并没有打印
         NSLog(@"signalA-Errror");
    }] ;
}

- (void)testThrottle {
    //节流:当某个信号发送比较频繁时，可以使用节流，在某一段时间不发送信号内容，过了一段时间获取信号的最新内容发出。
    // 阀门：防止重复的操作和按钮以及搜索的多次重复的点击和事件的触发。
    // 信号执行2秒后，如果没有新的操作则执行当前最终的信号。
    
    [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"被订阅");
        [subscriber sendNext:@"发送消息11"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"--- 1");
                [subscriber sendNext:@"发送消息21"];
                [subscriber sendNext:@"发送消息22"];
        });
            
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"--- 2");
                [subscriber sendNext:@"发送消息31"];
                [subscriber sendNext:@"发送消息32"];
                [subscriber sendNext:@"发送消息33"];
        });
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"--- 3");
                [subscriber sendNext:@"发送消息41"];
                [subscriber sendNext:@"发送消息42"];
                [subscriber sendNext:@"发送消息43"];
                [subscriber sendNext:@"发送消息44"];
        });
        return nil;
    }] throttle:2] subscribeNext:^(id  _Nullable x) {
            NSLog(@"--- Next:%@",x);
        }];
    
    
    /**
         [[[self.textfield rac_textSignal] throttle:1]  subscribeNext:^(id x) {
              NSLog(@"开始搜索请求==%@", x);
          }];
     */
    
    /**
     [[[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:5] subscribeNext:^(id x){
       NSLog(@"%@",x);
     }]
     */
}

@end
