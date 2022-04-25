//
//  NSObject+safe.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/25.
//

#import "NSObject+safe.h"
#import "TGSwizzlingDefine.h"
#include <execinfo.h>

@implementation NSObject (safe)

+ (void)load {
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_instanceMethod([NSObject class], @selector(forwardingTargetForSelector:), @selector(tg_forwardingTargetForSelector:));
    });
}



- (id)tg_forwardingTargetForSelector:(SEL)aSelector {
    SEL forwarding_sel = @selector(forwardingTargetForSelector:);
    //获取nsobject的消息转发方法
    Method root_forwarding_m = class_getInstanceMethod([NSObject class], forwarding_sel);
    //获取当前类的消息转发方法
    Method current_forwarding_m = class_getInstanceMethod([self class], forwarding_sel);
    
    BOOL response = (method_getImplementation(current_forwarding_m) == method_getImplementation(root_forwarding_m));
    //没有实现第二步:消息接受者重定向
    if (response) {
        //判断没有实现第三步:消息接受者重定向
        SEL signature_sel = @selector(methodSignatureForSelector:);
        Method root_signature_m = class_getInstanceMethod([NSObject class], signature_sel);
        Method current_signature_m = class_getInstanceMethod([self class], signature_sel);
        BOOL realize = (method_getImplementation(root_signature_m) == method_getImplementation(current_signature_m));
        
        if (realize) {//没有实现第三步：消息接受者重定向
            [[self class] putBacktraceInfo];
          //创建一个新类
            NSString *errClazz = NSStringFromClass([self class]);
            NSString *errSel = NSStringFromSelector(aSelector);
            NSLog(@"【error】出问题的类:%@ 方法:%@",errClazz,errSel);
            
            NSString *className = @"TGCrashClass";
            Class crashClazz = NSClassFromString(className);
            if (!crashClazz) {
            crashClazz = objc_allocateClassPair([NSObject class], className.UTF8String, 0);
            //注册类
                objc_registerClassPair(crashClazz);
            }
            
            //类没有对应的方法则动态添加一个
            if (!class_getInstanceMethod(crashClazz, aSelector)) {
                class_addMethod(crashClazz, aSelector, (IMP)Crash, "i16@0:8");
            }
            
            // 把消息转发到当前动态生成类的实例对象上
            return [[crashClazz alloc] init];
        }
    }
    return [self tg_forwardingTargetForSelector:aSelector];
}

// 动态添加的方法实现

static int Crash(id self, SEL _cmd) {
    NSLog(@"检测到奔溃。。。。");
    return 0;
}



+ (void)putBacktraceInfo{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = 0;i < frames;i++){
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    NSString *mainCallStackSymbolMsg = [self getMainCallStackSymbolMessageWithCallStackSymbols:backtrace];
    
    if (mainCallStackSymbolMsg == nil) {
        
        mainCallStackSymbolMsg = @"崩溃方法定位失败,请您查看函数调用栈来排查错误原因";
        
    }
    NSString *errorPlace = [NSString stringWithFormat:@"Error Place:%@",mainCallStackSymbolMsg];
    free(strs);
    NSLog(@"\n⚠️⚠️⚠️%@ \n=====>>>>>堆栈<<<<<=====\n%@",errorPlace,backtrace);
}


/**
 *  获取堆栈主要崩溃精简化的信息<根据正则表达式匹配出来>
 *
 *  @param callStackSymbols 堆栈主要崩溃信息
 *
 *  @return 堆栈主要崩溃精简化的信息
 */

+ (NSString *)getMainCallStackSymbolMessageWithCallStackSymbols:(NSArray<NSString *> *)callStackSymbols {
    
    //mainCallStackSymbolMsg的格式为   +[类名 方法名]  或者 -[类名 方法名]
    __block NSString *mainCallStackSymbolMsg = nil;
    
    //匹配出来的格式为 +[类名 方法名]  或者 -[类名 方法名]
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";
    
    
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    
    for (int index = 2; index < callStackSymbols.count; index++) {
        NSString *callStackSymbol = callStackSymbols[index];
        
        [regularExp enumerateMatchesInString:callStackSymbol options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbol.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result) {
                NSString* tempCallStackSymbolMsg = [callStackSymbol substringWithRange:result.range];
                
                //get className
                NSString *className = [tempCallStackSymbolMsg componentsSeparatedByString:@" "].firstObject;
                className = [className componentsSeparatedByString:@"["].lastObject;
                
                NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(className)];
                
                //filter category and system class
                if (![className hasSuffix:@")"] && bundle == [NSBundle mainBundle]) {
                    mainCallStackSymbolMsg = tempCallStackSymbolMsg;
                    
                }
                *stop = YES;
            }
        }];
        
        if (mainCallStackSymbolMsg.length) {
            break;
        }
    }
    
    return mainCallStackSymbolMsg;
}


@end
