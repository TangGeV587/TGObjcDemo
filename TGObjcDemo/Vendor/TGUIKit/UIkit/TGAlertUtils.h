//
//  TGAlertUtils.h
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^TGAlertOKActionBlock)(void);
typedef void (^TGAlertCancleActionBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface TGAlertUtils : NSObject

+ (void)handleAlertActionWithVC:(UIViewController *)vc
                     okBlock:(TGAlertOKActionBlock)okBlock
                      cancleBlock:(TGAlertCancleActionBlock)cancleBlock;

+ (void)handleAlertActionWithVC:(UIViewController *)vc
                             text:(NSString *)text
                     okBlock:(TGAlertOKActionBlock)okBlock
                      cancleBlock:(TGAlertCancleActionBlock)cancleBlock;

+ (void)handleAlertActionWithVC:(UIViewController *)vc
                           text:(NSString *)text
                        okBlock:(TGAlertOKActionBlock)okBlock;

+ (void)handleAlertActionWithVC:(UIViewController *)vc
                          title: (NSString *)title
                           text:(NSString *)text
                             ok:(NSString *)ok
                        okBlock:(TGAlertOKActionBlock)okBlock;

+ (void)handleAlertActionWithVC:(UIViewController *)vc
                          title: (NSString *)title
                           text:(NSString *)text
                             ok:(NSString *)ok
                         cancel:(NSString *)cancel
                        okBlock:(TGAlertOKActionBlock)okBlock
                    cancleBlock:(TGAlertCancleActionBlock)cancleBlock;

@end

NS_ASSUME_NONNULL_END
