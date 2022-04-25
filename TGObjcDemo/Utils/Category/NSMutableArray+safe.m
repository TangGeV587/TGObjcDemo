//
//  NSMutableArray+safe.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/25.
//

#import "NSMutableArray+safe.h"
#import "TGSwizzlingDefine.h"

@implementation NSMutableArray (safe)


+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        swizzling_classMethod(NSClassFromString(@"__NSArrayM"), NSSelectorFromString(@"objectAtIndex:"), @selector(tg_objectAtIndex:));
        swizzling_classMethod(NSClassFromString(@"__NSArrayM"), NSSelectorFromString(@"removeObjectsInRange:"), @selector(tg_removeObjectsInRange:));
        swizzling_classMethod(NSClassFromString(@"__NSArrayM"), NSSelectorFromString(@"insertObject:atIndex:"), @selector(tg_insertObject:atIndex:));
        swizzling_classMethod(NSClassFromString(@"__NSArrayM"), NSSelectorFromString(@"removeObject:inRange:"), @selector(tg_removeObject:inRange:));
        swizzling_classMethod(NSClassFromString(@"__NSArrayM"), NSSelectorFromString(@"objectAtIndexedSubscript:"), @selector(tg_objectAtIndexedSubscript:));
        
    });
}

/**
 取出第index个 值
 @param index 索引 index
 @return 返回值
 */
- (id)tg_objectAtIndex:(NSUInteger)index {
    if (index >=self.count) {
        return nil;
    }
    return [self tg_objectAtIndex:index];
}

/**
 NSMutableArray 移除索引 index 对应的值
 @param range 移除范围
 */
- (void)tg_removeObjectsInRange:(NSRange)range {
    if ((range.location + range.length) > self.count) {
        return;
    }
    
    return [self tg_removeObjectsInRange:range];
}

/**
 在range范围内，移除掉anObject
 @param anObject 移除的anObject
 @param range 范围
 */

- (void)tg_removeObject:(id)anObject inRange:(NSRange)range {
    
    if ((range.location + range.length) > self.count) {
        return;
    }
    
    if (!anObject){
        return;
    }
    
    return [self tg_removeObject:anObject inRange:range];
}

/**
 NSMutableArray 插入 新值 到 索引index 指定位置
 @param anObject 新值
 @param index 索引 index
 */
- (void)tg_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > self.count) {
        return;
    }
    
    if (!anObject){
        return;
    }
    
    [self tg_insertObject:anObject atIndex:index];
}

/**
 取出NSArray 第index个 值 对应 __NSArrayI
 @param idx 索引 idx
 @return 返回值
 */

- (id)tg_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count){
        return nil;
    }
    
    return [self tg_objectAtIndexedSubscript:idx];
}

@end
