//
//  TGIphoneFactory.m
//  TGObjcDemo
//
//  Created by 赵玉堂 on 2023/4/10.
//

#import "TGIphoneFactory.h"
#import "IPhone.h"

@implementation TGIphoneFactory

- (id<PhoneProtocol>)createProduct {
    return [[IPhone alloc] init];
}

@end
