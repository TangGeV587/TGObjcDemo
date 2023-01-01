//
//  TGAlertUtils.m
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/1.
//

#import "TGAlertUtils.h"

@implementation TGAlertUtils

+ (void)handleAlertActionWithVC:(UIViewController *)vc
                        okBlock:(TGAlertOKActionBlock)okBlock
                    cancleBlock:(TGAlertCancleActionBlock)cancleBlock {
    [self handleAlertActionWithVC:vc text:@"该功能需要重启App才能生效" okBlock:okBlock cancleBlock:cancleBlock];
}


+ (void)handleAlertActionWithVC:(UIViewController *)vc
                           text:(NSString *)text
                        okBlock:(TGAlertOKActionBlock)okBlock
                    cancleBlock:(TGAlertCancleActionBlock)cancleBlock {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancleBlock ? cancleBlock():nil;
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        okBlock ? okBlock():nil;
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [vc presentViewController:alertController animated:YES completion:nil];
}

+ (void)handleAlertActionWithVC:(UIViewController *)vc
                           text:(NSString *)text
                        okBlock:(TGAlertOKActionBlock)okBlock{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        okBlock ? okBlock():nil;
    }];
    [alertController addAction:okAction];
    [vc presentViewController:alertController animated:YES completion:nil];
}

+ (void)handleAlertActionWithVC:(UIViewController *)vc
                          title: (NSString *)title
                           text:(NSString *)text
                             ok:(NSString *)ok
                        okBlock:(TGAlertOKActionBlock)okBlock{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:ok style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        okBlock ? okBlock():nil;
    }];
    [alertController addAction:okAction];
    [vc presentViewController:alertController animated:YES completion:nil];
}

+ (void)handleAlertActionWithVC:(UIViewController *)vc
                          title: (NSString *)title
                           text:(NSString *)text
                             ok:(NSString *)ok
                         cancel:(NSString *)cancel
                        okBlock:(TGAlertOKActionBlock)okBlock
                    cancleBlock:(TGAlertCancleActionBlock)cancleBlock {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancleBlock ? cancleBlock():nil;
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:ok style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        okBlock ? okBlock():nil;
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [vc presentViewController:alertController animated:YES completion:nil];
}


@end
