//
//  LoginViewController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/8.
//

#import "LoginViewController.h"
#import <ReactiveObjC.h>
#import "LoginViewModel.h"
#import "VideoListController.h"
@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *logInFailureLabel;
@property (nonatomic, strong) LoginViewModel *viewModel;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = @"登录";
    RAC(self.viewModel,account) = self.userNameTF.rac_textSignal;
    RAC(self.userNameTF,backgroundColor) = self.viewModel.accountBgColorSignal;
    
    RAC(self.viewModel,pwd) = self.passwordTF.rac_textSignal;
    RAC(self.passwordTF,backgroundColor) = self.viewModel.pwdBgColorSignal;
    RAC(self.loginBtn,backgroundColor) = self.viewModel.loginColorSignal;
    RAC(self.loginBtn,userInteractionEnabled) = self.viewModel.loginValidateSignal;
    
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
    [self.viewModel.resultSignal subscribeNext:^(id  _Nullable x) {
       
        NSLog(@"请求结果 ------ %@",x);
        VideoListController *vc = [[VideoListController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.loginCommand execute:@"开始登录"];
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

- (LoginViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[LoginViewModel alloc] init];
    }
    return _viewModel;
}


@end
