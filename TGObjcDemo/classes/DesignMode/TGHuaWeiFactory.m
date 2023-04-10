//
//  TGHuaWeiFactory.m
//  TGObjcDemo
//
//  Created by 赵玉堂 on 2023/4/10.
//

#import "TGHuaWeiFactory.h"
#import "HuaWei.h"
@implementation TGHuaWeiFactory

- (id<PhoneProtocol>)createProduct {
    return [[HuaWei alloc] init];
}

@end
