//
//  BehaviorSubjectController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/3/30.
//

#import "BehaviorSubjectController.h"
#import <ReactiveObjC.h>
@interface BehaviorSubjectController ()

@property (nonatomic, strong) RACSignal *signal1;
@property (nonatomic, strong) RACSignal *signal2;

@end

@implementation BehaviorSubjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = @"BehaviorSubject";
    self.view.backgroundColor = [UIColor whiteColor];
    RACBehaviorSubject *subject = [RACBehaviorSubject behaviorSubjectWithDefaultValue:@100];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"----> %@", x);
    }];
    
    [self.signal1 subscribe:subject];
    [self.signal2 subscribe:subject];
}


- (void)testSubscribe1 {
    //RACBehaviorSubject 当该对象被订阅的时候，会发送他之前接收到的最后一个值。
    
    RACBehaviorSubject *subject = [RACBehaviorSubject behaviorSubjectWithDefaultValue:@(100)];//用一个默认值创建一个新的对象。如果当它被订阅的时候，还没有收到任何的值，就将默认值发送出去。
    
    [subject subscribeNext:^(id x) {
        NSLog(@"subscribe1 -- %@", x);
    }];
    
    [[self signal1] subscribe:subject];
    [[self signal2] subscribe:subject];
    
    //打印日志：
    /**
     2022-04-01 10:44:22.538653+0800 TGObjcDemo[37853:9591091] subscribe1 -- 100
     2022-04-01 10:44:22.538792+0800 TGObjcDemo[37853:9591091] subscribe1 -- 1
     2022-04-01 10:44:22.538897+0800 TGObjcDemo[37853:9591091] subscribe1 -- 2
     2022-04-01 10:44:22.538981+0800 TGObjcDemo[37853:9591091] signal1 - die
     2022-04-01 10:44:22.539060+0800 TGObjcDemo[37853:9591091] signal2 - die
     */
}


- (void)testSubscribe2 {
    RACBehaviorSubject *subject = [RACBehaviorSubject behaviorSubjectWithDefaultValue:@10];
    [[self signal1] subscribe:subject];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribe1 -- %@", x);
    }];
    [[self signal2] subscribe:subject];
    
    //打印日志：
    /**
     2022-04-01 10:49:11.390002+0800 TGObjcDemo[38000:9596689] subscribe1 -- 1
     2022-04-01 10:49:11.390136+0800 TGObjcDemo[38000:9596689] subscribe1 -- 2
     2022-04-01 10:49:11.390234+0800 TGObjcDemo[38000:9596689] signal1 - die
     2022-04-01 10:49:11.390315+0800 TGObjcDemo[38000:9596689] signal2 - die
     */
}

- (void)testSubscribe3 {
    
    RACBehaviorSubject *subject = [RACBehaviorSubject behaviorSubjectWithDefaultValue:@(100)];
    [[self signal1] subscribe:subject];
    [[self signal2] subscribe:subject];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribe1 -- %@", x);
    }];
    
    //打印日志：
    /**
     2022-04-01 11:05:20.915327+0800 TGObjcDemo[38344:9612621] subscribe1 -- 2
     2022-04-01 11:05:20.915467+0800 TGObjcDemo[38344:9612621] signal1 - die
     2022-04-01 11:05:20.915550+0800 TGObjcDemo[38344:9612621] signal2 - die
     */
}


- (void)testSubscribe4 {
    RACBehaviorSubject *subject = [RACBehaviorSubject behaviorSubjectWithDefaultValue:@100];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"subscribe4 -- 1 -- %@", x);    //subscribe4 -- 1 -- 100 默认值
    }];
    
    [[self signal1] subscribe:subject];     //subscribe4 -- 1 ---1
    
    [subject subscribeNext:^(id x) {
        NSLog(@"subscribe4 -- 2 -- %@", x); //subscribe4 -- 2 --- 1
    }];
    
    [[self signal2] subscribe:subject];  //subscribe4 -- 1 --- 2
    
    [subject subscribeNext:^(id x) {  //subscribe4 -- 2 --- 2
        NSLog(@"subscribe4 -- 3 -- %@", x); ////subscribe4 -- 3 --- 2
    }];
    
    // 打印日志：
    /*
     2022-04-01 16:43:45.009440+0800 TGObjcDemo[66479:9988193] subscribe4 -- 1 -- 100
     2022-04-01 16:43:45.009670+0800 TGObjcDemo[66479:9988193] subscribe4 -- 1 -- 1
     2022-04-01 16:43:45.009808+0800 TGObjcDemo[66479:9988193] subscribe4 -- 2 -- 1
     2022-04-01 16:43:45.009936+0800 TGObjcDemo[66479:9988193] subscribe4 -- 1 -- 2
     2022-04-01 16:43:45.010034+0800 TGObjcDemo[66479:9988193] subscribe4 -- 2 -- 2
     2022-04-01 16:43:45.010125+0800 TGObjcDemo[66479:9988193] subscribe4 -- 3 -- 2
     2022-04-01 16:43:45.010228+0800 TGObjcDemo[66479:9988193] signal1 - die
     2022-04-01 16:43:45.010310+0800 TGObjcDemo[66479:9988193] signal2 - die
     */
}

- (void)testSubscribe5 {
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@(1)];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@(2)];
        [subscriber sendError:nil];
        
        return nil;
    }];
    
    RACBehaviorSubject *subject = [RACBehaviorSubject behaviorSubjectWithDefaultValue:@(100)];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"subscribe5 -- 1 -- %@", x);   // 100    1    completed
    } error:^(NSError *error) {
        NSLog(@"subscribe5 -- 1 -- error");
    } completed:^{
        NSLog(@"subscribe5 -- 1 -- completed");
    }];
    
    [signal1 subscribe:subject];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"subscribe5 -- 2 -- %@", x);
    } error:^(NSError *error) {
        NSLog(@"subscribe5 -- 2 -- error");
    } completed:^{
        NSLog(@"subscribe5 -- 2 -- completed");
    }];
    
    [signal2 subscribe:subject];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"subscribe5 -- 3 -- %@", x);
    } error:^(NSError *error) {
        NSLog(@"subscribe5 -- 3 -- error");
    } completed:^{
        NSLog(@"subscribe5 -- 3 -- completed");
    }];
    
    // 打印日志：
    /*
     2022-04-01 17:08:54.630252+0800 TGObjcDemo[67246:10013907] subscribe5 -- 1 -- 100
     2022-04-01 17:08:54.630378+0800 TGObjcDemo[67246:10013907] subscribe5 -- 1 -- 1
     2022-04-01 17:08:54.630485+0800 TGObjcDemo[67246:10013907] subscribe5 -- 1 -- completed
     2022-04-01 17:08:54.630598+0800 TGObjcDemo[67246:10013907] subscribe5 -- 2 -- 1
     2022-04-01 17:08:54.630691+0800 TGObjcDemo[67246:10013907] subscribe5 -- 3 -- 1
     */
}

- (void)testSubscribe6 {
    RACBehaviorSubject *subject = [RACBehaviorSubject behaviorSubjectWithDefaultValue:@(100)];
    
    RACDisposable *dispoable1 = [subject subscribeNext:^(id x) {
        NSLog(@"subscribe6 -- 1 -- %@", x);
    }];
    [dispoable1 dispose];
    
    [[self signal1] subscribe:subject];
    RACDisposable *dispoable2 = [subject subscribeNext:^(id x) {
        NSLog(@"subscribe6 -- 2 -- %@", x);
    }];
    [dispoable2 dispose];
    
    [[self signal2] subscribe:subject];
    
    RACDisposable *dispoable3 = [subject subscribeNext:^(id x) {
        NSLog(@"subscribe6 -- 3 -- %@", x);
    }];
    
    [dispoable3 dispose];
    
    // 打印日志：
    /*
     2022-04-01 17:22:21.231854+0800 TGObjcDemo[67705:10030750] subscribe6 -- 1 -- 100
     2022-04-01 17:22:21.232262+0800 TGObjcDemo[67705:10030750] subscribe6 -- 2 -- 1
     2022-04-01 17:22:21.232444+0800 TGObjcDemo[67705:10030750] subscribe6 -- 3 -- 2
     2022-04-01 17:22:21.232601+0800 TGObjcDemo[67705:10030750] signal1 - die
     2022-04-01 17:22:21.232686+0800 TGObjcDemo[67705:10030750] signal2 - die
     */
}


#pragma mark - getter
- (RACSignal *)signal1
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@(1)];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"signal1 - die");
        }];
    }];
}

- (RACSignal *)signal2
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@(2)];
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"signal2 - die");
        }];
    }];
}


@end
