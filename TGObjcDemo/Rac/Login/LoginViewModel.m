//
//  LoginViewModel.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/11.
//

#import "LoginViewModel.h"

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
    
    
}

@end
