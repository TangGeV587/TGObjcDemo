//
//  LoginViewModel.h
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/11.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>
NS_ASSUME_NONNULL_BEGIN

@interface LoginViewModel : NSObject

@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *pwd;
@property (nonatomic, strong) RACSignal *accountBgColorSignal;
@property (nonatomic, strong) RACSignal *pwdBgColorSignal;
@property (nonatomic, strong) RACSignal *loginColorSignal;
@property (nonatomic, strong) RACSignal *loginValidateSignal;
@property (nonatomic, strong) RACCommand *loginCommand;
@property (nonatomic, strong) RACSubject *resultSignal;


@end

NS_ASSUME_NONNULL_END
