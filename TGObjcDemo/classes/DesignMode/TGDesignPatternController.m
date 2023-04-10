//
//  TGDesignPatternController.m
//  TGObjcDemo
//
//  Created by 赵玉堂 on 2023/4/8.
//

#import "TGDesignPatternController.h"
#import "TGHuaWeiFactory.h"
#import "HuaWei.h"
#import "TGPhoneFactory.h"
#import "Phone.h"
@interface TGDesignPatternController ()

@end

@implementation TGDesignPatternController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    
    id<TGPhoneFactory> factory= [[TGHuaWeiFactory alloc] init];
    id<PhoneProtocol> phone = [factory createProduct];
    NSLog(@"%@",phone.name);
    
}

@end
