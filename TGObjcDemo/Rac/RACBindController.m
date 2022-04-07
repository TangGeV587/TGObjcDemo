//
//  RACBindController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/7.
//

#import "RACBindController.h"
#import <ReactiveObjC.h>
#import "RACReturnSignal.h"

@interface RACBindController ()

@end

@implementation RACBindController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = @"bind";
    
}

- (void)testBind {
    
    //创建信号
    RACSubject *subject = [RACSubject subject];
    
    //绑定信号
    RACSignal *bindSignal = [subject bind:^RACSignalBindBlock {
        // block调用时刻：只要绑定信号订阅就会调用。不做什么事情，
        NSLog(@"绑定信号订阅");
        return ^RACSignal *(id value ,BOOL *flag){
            // 只要源信号（subject）发送数据，就会调用block
            NSLog(@"接受到源信号的内容：%@", value);
            // block作用：处理源信号内容
            value = @"ttt";
            return [RACReturnSignal return:value];
        };
    }];
    
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"接收绑定信号处理后的信号----- %@",x);
    }];
    
    [subject sendNext:@"uuuuuu"];
}

/*************************总结**********************/

// bind（绑定）的使用思想和Hook的一样---> 都是拦截API从而可以对数据进行操作，，而影响返回数据。
// 发送信号的时候会来到30行的block。在这个block里我们可以对数据进行一些操作，那么35行打印的value和订阅绑定信号后的value就会变了。变成什么样随你喜欢喽。

@end
