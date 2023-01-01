//
//  TGKVOController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/24.
//

#import "TGKVOController.h"
#import "TGPerson.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface TGKVOController ()

@property (nonatomic, strong) TGPerson *person1;
@property (nonatomic, strong) TGPerson *person2;

@end

@implementation TGKVOController

- (void)dealloc {
    //移除观察者的时候 会将ISA指针重新追回原来的对象
    [self removeObserver:self.person1 forKeyPath:@"age" context:@"xxx"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = @"KVO";
    //[[self.person1 mutableArrayValueForKey:@"datalist"] addObject:@"1"] 数据粗发kvo
    self.person1 = [[TGPerson alloc] init];
    self.person1.age = 10;
    self.person2 = [[TGPerson alloc] init];
    self.person2.age = 11;
    
    NSLog(@"监听前 %@,%@",object_getClass(self.person1),object_getClass(self.person2));
    
    
    IMP imp1 = [self.person1 methodForSelector:@selector(setAge:)];
    IMP imp2 = [self.person2 methodForSelector:@selector(setAge:)];
    NSLog(@"监听前 imp1:%p \n imp2:%p",imp1,imp2);
    
    NSKeyValueObservingOptions  option = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.person1 addObserver:self forKeyPath:@"age" options:option context:@"xxx"];
    
    NSLog(@"监听后 %@,%@",object_getClass(self.person1),object_getClass(self.person2));
    /**
     打印结果  监听后 NSKVONotifying_TGPerson,TGPerson
     1、person1的类对象发生了变化，KVO利用运行时的特性，动态的生成了一个继承TGPerson的子类
     2、修改person1对象的isa指针指向，指向这个派生类
     3、重写了setter方法
     */
    
    NSLog(@"监听后 imp1:%p \n imp2:%p", [self.person1 methodForSelector:@selector(setAge:)],[self.person2 methodForSelector:@selector(setAge:)]);
    
   
    
}


/// 当监听对象的属性值发生改变时，就会调用
/// @param keyPath 被监听的属性名称
/// @param object 被监听的对象
/// @param change 值的变化
/// @param context 包含将在相应的更改通知中传递回观察者的任意数据，您可以指定NULL并完全依赖keyPath字符串来确定通知的来源，但是这种方式可能会导致一个问题，父类的一个对象由于不同的原因也在观察同一个路径。
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSLog(@"keypath: %@ \n object: %@ \n change: %@ \n context: %@ \n",keyPath,object,change,context);
    /**
     
     ypedef NS_ENUM(NSUInteger, NSKeyValueChange) {
     NSKeyValueChangeSetting = 1, //调用set方法

     // 观测的值是一个可变集合/数组的情况
     NSKeyValueChangeInsertion = 2, //插入操作
     NSKeyValueChangeRemoval = 3, //移除操作
     NSKeyValueChangeReplacement = 4, // 替换操作
     };
     
     change: {
        kind = 1; //调用set方法
        new = 15;
        old = 10;
    }
     
     */
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.person1.age = 15;
    [self printMethodNameOfClass:object_getClass(self.person1)];
    [self printMethodNameOfClass:object_getClass(self.person2)];
    /**
     类NSKVONotifying_TGPerson  setAge:,class,dealloc,_isKVOA
     class 屏蔽内部实现 隐藏NSKVONotifying_TGPerson的存在
     dealloc 做一些销毁操作
      isKOVA 是否是动态派生类
     */
}


#pragma mark - private

- (void)printMethodNameOfClass:(Class)clazz {
    unsigned int count = 0;
   NSMutableString *nameStr = [NSMutableString string];
    Method *methodList = class_copyMethodList(clazz, &count);
    for (unsigned int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSString *methodName = NSStringFromSelector( method_getName(method));
          [nameStr appendString:methodName];
          [nameStr appendString:@","];
       }
       free(methodList);
       NSLog(@"类%@  %@",clazz,nameStr);
}

@end
