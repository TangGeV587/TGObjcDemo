//
//  SubjectSubController.h
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/3/28.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC.h>
NS_ASSUME_NONNULL_BEGIN

@interface SubjectSubController : UIViewController

//@property(nonatomic, strong)RACSubject *subject;
@property(nonatomic, strong)RACReplaySubject *subject;

@end

NS_ASSUME_NONNULL_END
