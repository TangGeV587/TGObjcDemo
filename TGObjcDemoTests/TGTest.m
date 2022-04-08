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
    [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]  ] subscribeNext:^(NSDate * _Nullable x) {
        NSLog(@"***** second 延时rac写法  ***** %@",x);
    }];
}


@end
