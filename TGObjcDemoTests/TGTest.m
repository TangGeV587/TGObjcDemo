//
//  TGTest.m
//  TGObjcDemoTests
//
//  Created by e-zhaoyutang on 2022/4/1.
//

#import <XCTest/XCTest.h>
#import <ReactiveObjC.h>
#import <ReactiveObjC/RACReturnSignal.h>
@interface TGTest : XCTestCase

@end

@implementation TGTest


- (void)testSubscribe1 {
    
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


@end
