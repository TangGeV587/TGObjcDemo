//
//  TGSwizzlingDefine.h
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/20.
//


#ifndef TGSwizzlingDefine_h
#define TGSwizzlingDefine_h

#import <objc/runtime.h>

static inline void swizzling_instanceMethod(Class clazz,SEL originSelector,SEL swizzledSelector) {

   Method originMehtod =  class_getInstanceMethod(clazz, originSelector);
   Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector);
   //实现要替换的方法
   BOOL result = class_addMethod(clazz, originSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (result) {
        class_replaceMethod(clazz, swizzledSelector, method_getImplementation(originMehtod), method_getTypeEncoding(originMehtod));
    }else {
        method_exchangeImplementations(originMehtod, swizzledMethod);//交换实现
    }
}


static inline void swizzling_classMethod(Class clazz,SEL originSelector,SEL swizzledSelector) {

   Method originMehtod =  class_getClassMethod(clazz, originSelector);
   Method swizzledMethod = class_getClassMethod(clazz, swizzledSelector);
   //实现要替换的方法
   BOOL result = class_addMethod(clazz, originSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (result) {
        class_replaceMethod(clazz, swizzledSelector, method_getImplementation(originMehtod), method_getTypeEncoding(originMehtod));
    }else {
        method_exchangeImplementations(originMehtod, swizzledMethod);//交换实现
    }
}
#endif /* TGSwizzlingDefine_h */
