//
//  LoginViewModel.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/11.
//

#import "LoginViewModel.h"
#import <AFNetworking.h>

@interface LoginViewModel ()

@property (nonatomic, strong) RACSignal *accountValideSignal;
@property (nonatomic, strong) RACSignal *pwdValideSignal;

@end

@implementation LoginViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self setupSignal];
    }
    return self;
}

- (void)setupSignal {
    
    self.accountValideSignal = [RACObserve(self, account) map:^id _Nullable(NSString  *value) {
        return @(value.length > 6);
    }];
    
    self.pwdValideSignal = [RACObserve(self, pwd) map:^id _Nullable(NSString  * value) {
        return @(value.length > 6);
    }];
    
    self.loginValidateSignal = [RACSignal combineLatest:@[self.accountValideSignal,self.pwdValideSignal] reduce:^id _Nonnull(NSNumber *account,NSNumber *pwd){
        return @([account boolValue] && [pwd boolValue]);
    }];
    self.loginColorSignal = [self.loginValidateSignal map:^id _Nullable(id  _Nullable value) {
        return [value boolValue]?  [UIColor orangeColor] :[UIColor lightGrayColor];
    }];
    
    self.accountBgColorSignal = [self.accountValideSignal map:^id _Nullable(id  _Nullable value) {
        return [value boolValue]? [UIColor whiteColor] : [UIColor greenColor];
    }];
    self.pwdBgColorSignal = [self.pwdValideSignal map:^id _Nullable(id  _Nullable value) {
        return [value boolValue]? [UIColor whiteColor] : [UIColor greenColor];
    }];
    
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"发送登录请求");
        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            //发送登录请求
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            [manager GET:@"https://api.uomg.com/api/rand.img4" parameters:@{@"sort":@"巨乳",@"format":@"json"} headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [subscriber sendNext:error];
                [subscriber sendCompleted];
            }];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
//                [subscriber sendNext:@"发送登录数据"];
//                [subscriber sendCompleted];
//            });
            return nil;
        }];
        
        return signal;
    }];
    //https://api.uomg.com/api/rand.img4?sort=女仆&format=json
    //获取信号源
    [self.loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        [self.resultSignal sendNext:x];
    }];
    
    //监听命令执行过程
    [[self.loginCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            //show loading
            NSLog(@"正在执行...");
        }else {
            //hide loading
            NSLog(@"执行完成...");
        }
        
    }];
}

#pragma mark - getter

- (RACSubject *)resultSignal {
    if (_resultSignal == nil) {
        _resultSignal = [RACSubject subject];
    }
    return _resultSignal;
}


@end
