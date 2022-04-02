//
//  SequenceViewController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/2.
//

#import "SequenceViewController.h"
#import <ReactiveObjC.h>
@interface SequenceViewController ()

@end

@implementation SequenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupUI {
    
    
}

- (void)filterArray {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:path];
    [dictArr.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    } error:^(NSError *error) {
        NSLog(@"===error===");
    } completed:^{
        NSLog(@"ok---完毕");
    }];
}

- (void)filterDictionary {
    
    NSDictionary *dict = @{@"key":@1, @"key2":@2};
    [dict.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@", x);
        // RACTupleUnpack宏：专门用来解析元组
        // RACTupleUnpack 等会右边：需要解析的元组 宏的参数，填解析的什么样数据
        // 元组里面有几个值，宏的参数就必须填几个
        RACTupleUnpack(NSString *key, NSString *value) = x;
        NSLog(@"%@ %@", key, value);
    } error:^(NSError *error) {
        NSLog(@"===error");
    } completed:^{
        NSLog(@"-----ok---完毕");
    }];
}

@end
