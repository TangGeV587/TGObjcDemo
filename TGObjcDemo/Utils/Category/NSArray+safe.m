//
//  NSArray+safe.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/24.
//

#import "NSArray+safe.h"
#import "TGSwizzlingDefine.h"
@implementation NSArray (safe)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        swizzling_classMethod(NSClassFromString(@"__NSArray0"), NSSelectorFromString(@"objectAtIndex:"), @selector(tg_objectAtIndex:));
        swizzling_classMethod(NSClassFromString(@"__NSSingleObjectArrayI"), NSSelectorFromString(@"objectAtIndex:"), @selector(tg_objectAtIndex:));
        swizzling_classMethod(NSClassFromString(@"__NSArrayI"), NSSelectorFromString(@"objectAtIndex:"), @selector(tg_objectAtIndex:));
        
    });
}

- (id)tg_objectAtIndex:(NSUInteger)index {
    if (index >=self.count) {
        return nil;
    }
    return [self tg_objectAtIndex:index];
}

@end
