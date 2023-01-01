//
//  TGAppAuthorizationStatus.h
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TGAuthorizationType) {

    TGAuthorizationTypePhoto,  //相册
    TGAuthorizationTypeCamera,   //相机
    TGAuthorizationTypeAudio  //麦克风
};

@interface TGAppAuthorizationStatus : NSObject


/// 检测是否有权限
/// @param authType 要检测的权限类型
/// @return  0: 无权限或不支持的authType类型，1.：未确定   2：有权限
+ (int)checkAuthorizationStatus:(TGAuthorizationType)authType;


/// 请求授权异步
/// @param authType 权限类型
/// @param permission 是否允许授权回调（会在主线程）
+ (void)authorizationStatusAction:(TGAuthorizationType)authType
                       permission:(void (^)(BOOL granted))permission;


+ (UIAlertController *)showAlerView:(NSString *)title
                               desc:(NSString *)desc
                            okBlock:(void(^)(void))okBlock
                        cancelBlock:(void(^)(void))cancelBlock;


@end


NS_ASSUME_NONNULL_END
