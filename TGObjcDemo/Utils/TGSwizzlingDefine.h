//
//  TGSwizzlingDefine.h
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/20.
//


#ifndef TGSwizzlingDefine_h
#define TGSwizzlingDefine_h
#import <objc/runtime.h>

static inline void swizzling_ExchangeMethod(Class clazz,SEL originSelector,SEL swizzledSelector) {
    
    class_getMethodImplementation(clazz, originSelector)
    
    
}


#endif /* TGSwizzlingDefine_h */
