//
//  VideoViewModel.h
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoViewModel : NSObject<UITableViewDelegate,UITableViewDataSource>

//当前视图控制器
@property (nonatomic, weak) UIViewController *currentVC;
@property (nonatomic, strong) RACCommand *videoListCommand;
@property (nonatomic, strong) RACSubject *resultSubject;

@end

NS_ASSUME_NONNULL_END
