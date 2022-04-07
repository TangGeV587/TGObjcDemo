//
//  RacMacrosController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/2.
//

#import "RacMacrosController.h"
#import <ReactiveObjC.h>

@interface RacMacrosController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) RACSignal *signal;

@end

@implementation RacMacrosController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    [self.view addSubview:self.textField];
    
}

- (void)text {
    
    // RAC:把一个对象的某个属性绑定一个信号,只要发出信号,就会把信号的内容给对象的属性赋值
    // 给label的text属性绑定了文本框改变的信号
    RAC(self.label,text) = self.textField.rac_textSignal;
}

/**
 *  KVO
 *  RACObserveL:快速的监听某个对象的某个属性改变
 *  返回的是一个信号,对象的某个属性改变的信号
 */
- (void)test1 {
    
    [RACObserve(self.label, text) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@ ---  ",x);
    }];
}

//循环引用问题
- (void)test2 {
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        NSLog(@"%@",self.view);
        return nil;
    }];
    _signal = signal;
}

- (void)test3 {
    RACTuple *tuple = RACTuplePack(@1,@2,@3);
//    NSLog(@"%@",tuple.allObjects);
//    NSLog(@"%@ - %@ - %@",tuple.first,tuple.second,tuple.third);
    RACTupleUnpack(NSNumber *item1,NSNumber *item2,NSNumber *item3) = tuple;
    NSLog(@"%@ - %@ - %@",item1,item2,item3);
}

#pragma mark - getter

- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.text = @"label";
        _label.backgroundColor = [UIColor yellowColor];
        _label.numberOfLines = 0;
        _label.frame = CGRectMake(0, 100, 300, 30);
    }
    return _label;
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.frame = CGRectMake(0, 200, 300, 30);
        _textField.backgroundColor = [UIColor greenColor];
    }
    return _textField;
}




@end
