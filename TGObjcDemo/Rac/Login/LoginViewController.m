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
    
    //
    [[[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^__kindof RACSignal * _Nullable(__kindof UIControl * _Nullable value) {
        return self.loginSignal;
    }] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        NSLog(@"---- 登录");
    }];
}

#pragma mark - getter

- (RACSignal *)loginSignal {
    
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
    //网络请求
        BOOL result = [self.userNameTF.text isEqualToString:@"username"] && [self.passwordTF.text isEqualToString:@"password"];
        return @(result);
    }];
    
}

@end
