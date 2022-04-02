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
    
    [self.textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
       
        NSLog(@"%@ \n",x);
        
    }];
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
