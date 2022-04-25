//
//  TGRumtimeCopyController.m
//  TGRumtimeCopyController
//
//  Created by e-zhaoyutang on 2022/4/24.
//

#import "TGRumtimeCopyController.h"
#import "TGPerson.h"
#import <objc/runtime.h>
#import "TGCrash.h"

@interface TGRumtimeCopyController ()

@end

@implementation TGRumtimeCopyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = @"KVO";
    
}

//打印变量
void getIvarList(Class clazz) {
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([TGPerson class], &count);
    for (unsigned int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *ivarName = ivar_getName(ivar);
        NSString *name = [NSString stringWithUTF8String:ivarName];
        NSLog(@"变量名称：%@ \n",name);
    }
    free(ivars);
}

//打印方法
void getMethodList(Class clazz) {
    unsigned int count = 0;
   Method *methodList = class_copyMethodList(clazz, &count);
    for (unsigned int i = 0; i < count; i++) {
        Method method = methodList[i];
       SEL selector = method_getName(method);
       const char *encoding = method_getTypeEncoding(method);
        
        NSLog(@"方法名: %@ - %s \n 编码参数:%s",NSStringFromSelector(selector),sel_getName(selector),encoding);
    }
    free(methodList);
}

//打印属性
void getPropertyList(Class clazz) {
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList(clazz, &count);
    for (unsigned int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *propertyName = property_getName(property);
        const char *attribute = property_getAttributes(property);
        // (参考链接)[https://blog.csdn.net/cym_bj/article/details/89094417]
        
        NSLog(@"属性名称：%s \n 属性类型: %s",propertyName,attribute);
    }
    free(propertyList);
}

//打印类遵循的协议列表
void getProtocolList(Class clazz) {
    unsigned int count = 0;
    __unsafe_unretained Protocol **protocallist =  class_copyProtocolList(clazz, &count);
    for (unsigned int i = 0; i < count; i++) {
        Protocol *protocal = protocallist[i];
         const char *protocolName = protocol_getName(protocal);
        NSLog(@"协议名称: %s \n",protocolName);
    }
    free(protocallist);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    TGPerson *p = [[TGPerson alloc] init];
//    IMP imp = [p methodForSelector:@selector(run)];
//        getIvarList([p class]);
//        getMethodList([p class]);
//        getPropertyList([p class]);
//        getProtocolList([p class]);
    
    TGCrash *carsh = [[TGCrash alloc] init];
    [carsh performSelector:@selector(run)];
//    [carsh run];
}


@end
