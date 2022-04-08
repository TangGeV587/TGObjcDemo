//
//  TGView.h
//  ReactCoCoaDemo
//
//  Created by e-zhaoyutang on 2021/7/1.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
NS_ASSUME_NONNULL_BEGIN

@interface TGView : UIView

@property (nonatomic, strong) RACSubject *subject;

@end

NS_ASSUME_NONNULL_END
