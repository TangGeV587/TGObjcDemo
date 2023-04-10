//
//  TGPhoneFactory.h
//  TGObjcDemo
//
//  Created by 赵玉堂 on 2023/4/10.
//

#ifndef TGPhoneFactory_h
#define TGPhoneFactory_h
#import <Foundation/Foundation.h>
#import "Phone.h"

@protocol TGPhoneFactory <NSObject>

- (id<PhoneProtocol>)createProduct;

@end

#endif /* TGPhoneFactory_h */
