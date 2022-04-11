//
//  LoginViewController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/8.
//

#import "LoginViewController.h"
#import <ReactiveObjC.h>

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *logInFailureLabel;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = @"登录";
    RACSignal *accountSignal = [self.userNameTF.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length > 6);
    }];
    
    RACSignal *pwdSignal = [self.passwordTF.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length > 6);
    }];
    
    RACSignal *combineSignal = [RACSignal combineLatest:@[accountSignal,pwdSignal] reduce:^id(NSNumber *account,NSNumber *pwd){
        return @([account boolValue] && [pwd boolValue]);
    }];
    
    RAC(self.userNameTF,backgroundColor) = [accountSignal map:^id _Nullable(NSNumber *value) {
        return [value boolValue]? [UIColor whiteColor] : [UIColor greenColor];
    }];
    
    RAC(self.passwordTF,backgroundColor) = [pwdSignal map:^id _Nullable(NSNumber *value) {
        return [value boolValue]? [UIColor whiteColor] : [UIColor greenColor];
    }];
    
    RAC(self.loginBtn,backgroundColor) = [combineSignal map:^id _Nullable(NSNumber *value) {
        return [value boolValue]?  [UIColor orangeColor] :[UIColor lightGrayColor];
    }];
    
    
    RAC(self.loginBtn,userInteractionEnabled) = combineSignal;
    
//    [[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^__kindof RACSignal * _Nullable(__kindof UIControl * _Nullable value) {
//        self.logInFailureLabel.hidden = YES;
//        return self.loginSignal;
//    }] subscribeNext:^(id x) {
//        self.logInFailureLabel.hidden = [x boolValue];
//        if ([x boolValue]) {
//            NSLog(@"---- 登录成功");
//        }else {
//            NSLog(@"---- 登录失败");
//        }
//    }];
    
    
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"发送登录请求");
        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            //发送登录请求
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                [subscriber sendNext:@"发送登录数据"];
                [subscriber sendCompleted];
            });
            return nil;
        }];
        
        return signal;
    }];
    
    //获取信号源
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"----- %@",x);
    }];
    
    //监听命令执行过程
    [[command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue]) {
            //show loading
            NSLog(@"正在执行...");
        }else {
            //hide loading
            NSLog(@"执行完成...");
        }
        
    }];
    
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [command execute:@"开始登录"];
    }];
   
}

#pragma mark - getter

- (RACSignal *)loginSignal {
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
    //网络请求
        BOOL result = [self.userNameTF.text isEqualToString:@"username"] && [self.passwordTF.text isEqualToString:@"password"];
        [subscriber sendNext:@(result)];
        return nil;
    }];
    
}

@end
