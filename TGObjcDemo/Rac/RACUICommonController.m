//
//  RACUICommonController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/8.
//

#import "RACUICommonController.h"
#import "TGView.h"

@interface RACUICommonController ()<UITextFieldDelegate>

@property (nonatomic, strong) TGView *contentView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation RACUICommonController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self testDeledate];
}

- (void)setupUI {
    self.navigationItem.title = @"常用";
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.label];
    [self.view addSubview:self.loginBtn];
}

#pragma mark - notification
- (void)rac_notification {
        
    [[NSNotificationCenter defaultCenter] rac_addObserverForName:@"rac_notification" object:nil];
}

#pragma mark - delegate

- (void)testDeledate {
    
    [[self rac_signalForSelector:@selector(textFieldDidBeginEditing:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"代理开始做事情");
    }];
    
    [[[self.textField rac_textSignal] filter:^BOOL(NSString * _Nullable value) {
        
        return value.length;
        
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"text---- %@",x);
    }];
    
//    [[self.textField rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(__kindof UIControl * _Nullable x) {
//
//        NSLog(@"event---- %@",x);
//    }];
}

#pragma mark - selector

- (void)testAction {
    //可以把里面参数给传出来
    [[self.contentView rac_signalForSelector:@selector(sendAction:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"---- %@",x);
    }];
}

- (void)subjectAction {
    [self.contentView.subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"---- %@",x);
    }];
}

#pragma mark - getter

- (TGView *)contentView {
    if (_contentView == nil) {
        _contentView = [[TGView alloc] init];
        _contentView.frame = CGRectMake(100, 100, 200, 200);
        _contentView.backgroundColor = [UIColor greenColor];
    }
    return _contentView;
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        CGFloat x = (self.screenWidth - 200) * 0.5;
        _textField.placeholder = @"请输入用户名";
        _textField.frame = CGRectMake(x, CGRectGetMaxY(self.contentView.frame) + 30, 200, 30);
        _textField.backgroundColor = [UIColor greenColor];
        _textField.delegate = self;
    }
    return _textField;
}

- (UILabel *)label {
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.text = @"振兴中华";
        _label.backgroundColor = [UIColor yellowColor];
        _label.numberOfLines = 0;
        CGFloat x = (self.screenWidth - 200) * 0.5;
        _label.frame = CGRectMake(x, CGRectGetMaxY(self.textField.frame) + 30, 200, 30);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            NSLog(@"点击label");
        }];
        [_label addGestureRecognizer:tap];
        _label.userInteractionEnabled = YES;
    }
    return _label;
}

- (UIButton *)loginBtn {
    if (_loginBtn == nil) {
        _loginBtn = [[UIButton alloc] init];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _loginBtn.backgroundColor = [UIColor brownColor];
        CGFloat x = (self.screenWidth - 200) * 0.5;
        _loginBtn.frame = CGRectMake(x, CGRectGetMaxY(self.label.frame) + 30, 200, 44);
        [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
           
            NSLog(@"登录了");
        }];
    }
    return _loginBtn;
}


@end
