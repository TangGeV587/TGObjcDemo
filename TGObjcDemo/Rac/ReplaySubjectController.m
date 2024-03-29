//
//  ReplaySubjectController.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/2.
//

#import "ReplaySubjectController.h"
#import <ReactiveObjC.h>

@interface ReplaySubjectController ()

@end

@implementation ReplaySubjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationItem.title = @"replaySubject";
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)testSubscribe1 {
    //该对象根据 capacity 确定保存他发送过的值的个数，并且重新发送这些值给新的订阅者。对错误信息和完成信息也是一样的
    RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:RACReplaySubjectUnlimitedCapacity];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribe11 -- %@", x);
    }];
    [[self signal1] subscribe:subject];
    
    [[self signal2] subscribe:subject];
    //打印日志：
    /**
     2022-04-02 11:17:07.065200+0800 TGObjcDemo[92670:10952024] subscribe11 -- 1
     2022-04-02 11:17:07.065372+0800 TGObjcDemo[92670:10952024] subscribe11 -- 2
     2022-04-02 11:17:07.065496+0800 TGObjcDemo[92670:10952024] signal1 - die
     2022-04-02 11:17:07.065608+0800 TGObjcDemo[92670:10952024] signal2 - die
     */
}


- (void)testSubscribe2 {
    
    RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:RACReplaySubjectUnlimitedCapacity];
    
    [[self signal1] subscribe:subject];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"subscribe11 -- %@", x);
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
    
    RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:RACReplaySubjectUnlimitedCapacity];
    
    [[self signal1] subscribe:subject];
    [[self signal2] subscribe:subject];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"subscribe13 -- %@", x);
    }];
    
    //打印日志：
    /**
     2022-04-02 13:12:40.836222+0800 TGObjcDemo[95328:11045982] subscribe13 -- 1
     2022-04-02 13:12:40.836338+0800 TGObjcDemo[95328:11045982] subscribe13 -- 2
     2022-04-02 13:12:40.836475+0800 TGObjcDemo[95328:11045982] signal1 - die
     2022-04-02 13:12:40.836569+0800 TGObjcDemo[95328:11045982] signal2 - die
     */
}


- (void)testSubscribe4 {
    RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
    
    [[self signal1] subscribe:subject];
    [[self signal2] subscribe:subject];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"subscribe14 -- 1 -- %@", x);
    }];
    
    RACReplaySubject *subject1 = [RACReplaySubject replaySubjectWithCapacity:2];
    
    [[self signal1] subscribe:subject1];
    [[self signal2] subscribe:subject1];
    
    [subject1 subscribeNext:^(id x) {
        NSLog(@"subscribe14 -- 2 -- %@", x);
    }];
    
    // 打印日志：
    /*
     2022-04-02 13:37:44.753507+0800 TGObjcDemo[95962:11072425] subscribe14 -- 1 -- 2
     2022-04-02 13:37:44.753711+0800 TGObjcDemo[95962:11072425] subscribe14 -- 2 -- 1
     2022-04-02 13:37:44.753812+0800 TGObjcDemo[95962:11072425] subscribe14 -- 2 -- 2
     2022-04-02 13:37:44.753924+0800 TGObjcDemo[95962:11072425] signal1 - die
     2022-04-02 13:37:44.754036+0800 TGObjcDemo[95962:11072425] signal2 - die
     2022-04-02 13:37:44.754142+0800 TGObjcDemo[95962:11072425] signal1 - die
     2022-04-02 13:37:44.754220+0800 TGObjcDemo[95962:11072425] signal2 - die
     */
}

- (void)testSubscribe5 {
   
    RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:RACReplaySubjectUnlimitedCapacity];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"subscribe15 -- 1 -- %@", x);
    }];
    
    [[self signal1] subscribe:subject];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"subscribe15 -- 2 -- %@", x);
    }];
    
    [[self signal2] subscribe:subject];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"subscribe15 -- 3 -- %@", x);
    }];
    // 打印日志：
    /*
     2022-04-02 13:58:05.196001+0800 TGObjcDemo[96535:11096381] subscribe15 -- 1 -- 1
     2022-04-02 13:58:05.196160+0800 TGObjcDemo[96535:11096381] subscribe15 -- 2 -- 1
     2022-04-02 13:58:05.196265+0800 TGObjcDemo[96535:11096381] subscribe15 -- 1 -- 2
     2022-04-02 13:58:05.196353+0800 TGObjcDemo[96535:11096381] subscribe15 -- 2 -- 2
     2022-04-02 13:58:05.196446+0800 TGObjcDemo[96535:11096381] subscribe15 -- 3 -- 1
     2022-04-02 13:58:05.196531+0800 TGObjcDemo[96535:11096381] subscribe15 -- 3 -- 2
     2022-04-02 13:58:05.196659+0800 TGObjcDemo[96535:11096381] signal1 - die
     2022-04-02 13:58:05.196742+0800 TGObjcDemo[96535:11096381] signal2 - die
     */
}

- (void)testSubscribe6 {
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
    
    RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:RACReplaySubjectUnlimitedCapacity];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"subscribe6 -- 1 -- %@", x);
    } error:^(NSError *error) {
        NSLog(@"subscribe6 -- 1 -- error");
    } completed:^{
        NSLog(@"subscribe6 -- 1 -- completed");
    }];
    
    [signal1 subscribe:subject];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"subscribe6 -- 2 -- %@", x);
    } error:^(NSError *error) {
        NSLog(@"subscribe6 -- 2 -- error");
    } completed:^{
        NSLog(@"subscribe6 -- 2 -- completed");
    }];
    
    [signal2 subscribe:subject];

    [subject subscribeNext:^(id x) {
        NSLog(@"subscribe6 -- 3 -- %@", x);
    } error:^(NSError *error) {
        NSLog(@"subscribe6 -- 3 -- error");
    } completed:^{
        NSLog(@"subscribe6 -- 3 -- completed");
    }];
    
    // 打印日志：
    /*
     2022-04-02 14:06:56.622580+0800 TGObjcDemo[96837:11108173] subscribe6 -- 1 -- 1
     2022-04-02 14:06:56.622713+0800 TGObjcDemo[96837:11108173] subscribe6 -- 1 -- completed
     2022-04-02 14:06:56.622823+0800 TGObjcDemo[96837:11108173] subscribe6 -- 2 -- 1
     2022-04-02 14:06:56.622899+0800 TGObjcDemo[96837:11108173] subscribe6 -- 2 -- completed
     2022-04-02 14:06:56.623006+0800 TGObjcDemo[96837:11108173] subscribe6 -- 3 -- 1
     2022-04-02 14:06:56.623099+0800 TGObjcDemo[96837:11108173] subscribe6 -- 3 -- completed
     */
}

- (void)testSubscribe7 {
    RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:RACReplaySubjectUnlimitedCapacity];
    
    RACDisposable *dispoable1 = [subject subscribeNext:^(id x) {
        NSLog(@"subscribe17 -- 1 -- %@", x);
    }];
    [dispoable1 dispose];
    
    [[self signal1] subscribe:subject];
    
    RACDisposable *dispoable2 = [subject subscribeNext:^(id x) {
        NSLog(@"subscribe17 -- 2 -- %@", x);
    }];
    [dispoable2 dispose];
    
    [[self signal2] subscribe:subject];
    
    RACDisposable *dispoable3 = [subject subscribeNext:^(id x) {
        NSLog(@"subscribe17 -- 3 -- %@", x);
    }];
    [dispoable3 dispose];
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
