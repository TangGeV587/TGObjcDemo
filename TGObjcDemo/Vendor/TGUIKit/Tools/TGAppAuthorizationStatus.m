//
//  TGAppAuthorizationStatus.m
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/5.
//

#import "TGAppAuthorizationStatus.h"

#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import  <CoreLocation/CoreLocation.h>


@implementation TGAppAuthorizationStatus

/// 检测是否有权限
/// @param authorType 要检测的权限类型
/// @return  0: 无权限或不支持的authType类型，1.：未确定   2：有权限
+ (int)checkAuthorizationStatus:(TGAuthorizationType)authType
{
    switch (authType) {
        case TGAuthorizationTypePhoto:
            return [[self class] JX_Device_Permission_PhotoLibraryAuth];
            break;
        case TGAuthorizationTypeCamera:
            return [[self class] JX_Device_Permission_CameraAuth];
            break;
        case TGAuthorizationTypeAudio:
            return [[self class] JX_Device_Permission_AudioAuth];
            break;
        default:
            break;
    }
    return 0;
}

/// 请求授权
/// @param authType 权限类型
/// @param permission 是否允许授权
+ (void)authorizationStatusAction:(TGAuthorizationType)authType
                       permission:(void (^)(BOOL granted))permission
{
    switch (authType) {
        case TGAuthorizationTypePhoto:
            [[self class] JX_Device_Permission_Check_PhotoLibraryAuth:permission];
            break;
        case TGAuthorizationTypeCamera:
            [[self class] JX_Device_Permission_Check_CameraAuth:permission];
            break;
        case TGAuthorizationTypeAudio:
            [[self class] JX_Device_Permission_Check_AudioAuth:permission];
            break;
        default:
            break;
    }
}




+ (UIAlertController *)showAlerView:(NSString *)title
       desc:(NSString *)desc
    okBlock:(void(^)(void))okBlock
cancelBlock:(void(^)(void))cancelBlock
{
     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                message:desc
                                                                         preferredStyle:UIAlertControllerStyleAlert];
    if (okBlock) {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            okBlock();
        }];
        [alertController addAction:okAction];
    }
    if (cancelBlock) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }];
        [alertController addAction:cancelAction];
    }

    
    return alertController;
}

#pragma mark - 相册权限
/**
 判断相册权限开关,但是不会弹出是否允许弹出权限
 (需要在info中配置)Privacy - Photo Library Additions Usage Description 允许**访问您的相册,来用于**功能
 
 @return  0: 无权限，1.：未确定   2：有权限
 */
+ (int)JX_Device_Permission_PhotoLibraryAuth
{
    
    if ([[UIDevice currentDevice].systemVersion floatValue]  >= 8.0) {
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        if(authStatus == PHAuthorizationStatusDenied || authStatus == PHAuthorizationStatusRestricted) {
            return 0;
        }
        if(authStatus == PHAuthorizationStatusNotDetermined) {
            return 1;
        }
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0 && [[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        if(authStatus == PHAuthorizationStatusDenied || authStatus == PHAuthorizationStatusRestricted) {
            return 0;
        }
        if(authStatus == PHAuthorizationStatusNotDetermined) {
            return 1;
        }
    }
    return 2;
}
/**
 判断相册权限开关,会弹出是否允许弹出权限
 (需要在info中配置)Privacy - Photo Library Additions Usage Description 允许**访问您的相册,来用于**功能
 */
+ (void)JX_Device_Permission_Check_PhotoLibraryAuth:(void (^)(BOOL granted))permission
{
    BOOL auth = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    if (!auth && permission) permission(NO);
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) { //弹出访问权限提示框
        dispatch_async(dispatch_get_main_queue(),^{ // 无权限
           if (permission) {
               permission(status==PHAuthorizationStatusAuthorized);
           }
        });
//        if (status == PHAuthorizationStatusAuthorized) { // 有权限
//            dispatch_async(dispatch_get_main_queue(),^{
//
//               // do something
//               //  一般操作
////              self.imagePickerController.sourceType   = UIImagePickerControllerSourceTypePhotoLibrary;
////              [self presentViewController:self.imagePickerController animated:YES completion:nil];
//            });
//        } else {
//            dispatch_async(dispatch_get_main_queue(),^{ // 无权限
//               // do something
//            });
//
//        }
    }];
}

#pragma mark - 相机
/**
 判断相机权限开关,但是不会弹出是否允许弹出权限
 (需要在info中配置)Privacy - Camera Usage Description 允许**访问您的相机,来用于**功能
 
 @return   0: 无权限，1.：未确定   2：有权限
 */
+ (BOOL)JX_Device_Permission_CameraAuth {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        return 0;
    }
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        return 1;
    }
    return 2;
}
/**
 判断相机权限开关,会弹出是否允许弹出权限
 (需要在info中配置)Privacy - Camera Usage Description 允许**访问您的相机,来用于**功能
 */
+ (void)JX_Device_Permission_Check_CameraAuth:(void (^)(BOOL granted))permission
{
    BOOL auth = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!auth && permission) permission(NO);
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(),^{
            if (permission) {
                permission(granted);
            }
//            if (granted) { // 授权成功
//                // do something
//                // 一般会做的操作，跳转到系统的相机
////                self.imagePickerController.sourceType   = UIImagePickerControllerSourceTypeCamera;
////                [self presentViewController:self.imagePickerController animated:YES completion:nil];
//            } else { // 拒绝授权
//                // do something
//            }
        });
    }];
}

#pragma mark - 麦克风权限
/**
 判断当前是有语音权限,但是不会弹出是否允许弹出权限
 （需要在info中配置）Privacy - Microphone Usage Description 允许**访问您的语音，来用于**功能？
 
 @return 0: 无权限，1.：未确定   2：有权限
 */
+ (BOOL)JX_Device_Permission_AudioAuth {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        return 0;
    }
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        return 1;
    }
    return 2;
}

/**
 判断当前是有语音权限,会弹出是否允许弹出权限
 （需要在info中配置）Privacy - Microphone Usage Description 允许**访问您的语音，来用于**功能？
 */
+ (void)JX_Device_Permission_Check_AudioAuth:(void (^)(BOOL granted))permission
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if ([session respondsToSelector:@selector(requestRecordPermission:)]){
        [session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
           dispatch_async(dispatch_get_main_queue(),^{
               if (permission) {
                   permission(granted);
               }
           });
        }];
    }

}

#pragma mark - 通知权限权限
/**
 推送权限开关
 
 @return YES:有权限，NO:没权限
 */
+ (BOOL)JX_Device_Permission_NotificationAuth {
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            return  NO;
        }
    } else {
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone == type){
            return  NO;
        }
    }
    return YES;
}
/**
 判断通知权限开关,会弹出是否允许弹出权限(远程、本地)
 */
+ (void)JX_Device_Permission_Check_NotificationAuth {
    if ([[UIDevice currentDevice].systemVersion floatValue]  >= 10.0) {
        [[UNUserNotificationCenter   currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // do something
                // 对granted 进行判断，是否允许权限
            });
        }];
    } else if ([[UIDevice currentDevice].systemVersion floatValue]  >= 8.0) {
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
        BOOL auth = [self JX_Device_Permission_NotificationAuth];
        // 对auth 进行判断，是否允许权限
    }
}

#pragma mark - 定位
//参考：https://www.jianshu.com/p/00bbd06ac520
/**
 定位权限开关
 (需要在info中配置)Privacy - Location When In Use Usage Description 允许**在应用使用期间访问您的位置,来用于**功能
 (需要在info中配置)Privacy - Location Always and When In Use Usage Description 允许**访问您的位置,来用于**功能
 
 @return YES:有权限，NO:没权限
 */
//- (BOOL)JX_Device_Permission_LocationAuth {
//    if (![CLLocationManager locationServicesEnabled]) {
//        return NO;
//    }
//    CLAuthorizationStatus CLstatus = [CLLocationManager authorizationStatus];
//    if (CLstatus == kCLAuthorizationStatusDenied || CLstatus == kCLAuthorizationStatusRestricted) {
//        return NO;
//    }
//    return YES;
//}

@end
