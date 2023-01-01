//
//  TGCommonMacro.h
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/1.
//

#ifndef TGCommonMacro_h
#define TGCommonMacro_h

#pragma mark- 弱引用&强引用

#define TGWeakSelf __weak typeof(self) weakSelf = self;
#define TGStrongSelf __strong typeof(weakSelf) strongSelf = weakSelf;

#pragma mark- 打印

#if DEBUG
#define TGLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define TGLog(FORMAT, ...) nil
#endif




#pragma mark- 系统版本号判断
#define IOS18_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 18.0)
#define IOS17_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 17.0)
#define IOS16_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 16.0)
#define IOS15_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 15.0)
#define IOS14_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 14.0)
#define IOS13_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 13.0)
#define IOS12_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 12.0)
#define IOS11_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)


#define TG_SAFE_Bottom [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom
/** 刘海屏？？*/
#define IS_BANGS_SCREEN (IOS11_OR_LATER && (TG_SAFE_Bottom > 0))



/** 屏幕宽 */
#define TGScreenW [UIScreen mainScreen].bounds.size.width
/** 屏幕高 */
#define TGScreenH [UIScreen mainScreen].bounds.size.height

/** 状态栏高度*/

#define SCALE_X      G_SCREEN_WIDTH/375.0
#define SCALE_Y      G_STATUSBAR_HEIGHT/667.0

/** 导航栏高度 */

#define TG_NAV_HEIGHT  44 + TG_STATUSBAR_HEIGHT
#define TG_TABBAR_HEIGHT (IS_BANGS_SCREEN ? 83.0 : 49.0)


#pragma mark- 线程安全

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }
#endif

#pragma mark- 去除警告
#define TG_SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


static inline CGFloat TGStatusHeight() {
    CGFloat statusBarHeight = 0.0;
    if (@available(iOS 13.0, *)) {
        UIWindow *window = nil;
        if (@available(iOS 15, *)) {
              __block UIScene * _Nonnull tmpSc;
               [[[UIApplication sharedApplication] connectedScenes] enumerateObjectsUsingBlock:^(UIScene * _Nonnull obj, BOOL * _Nonnull stop) {
                   if (obj.activationState == UISceneActivationStateForegroundActive) {
                       tmpSc = obj;
                       *stop = YES;
                   }
               }];
               UIWindowScene *curWinSc = (UIWindowScene *)tmpSc;
            window = curWinSc.keyWindow;
        }else {
            window = [UIApplication sharedApplication].windows.firstObject;
        }
        statusBarHeight = window.windowScene.statusBarManager.statusBarFrame.size.height;
    } else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return statusBarHeight;
}

static inline BOOL TGIsObjectEmpty(id obj) { // 空对象
    return obj == nil || [obj isEqual:[NSNull null]] || ([obj respondsToSelector:@selector(length)] && [(NSData *) obj length] == 0) ||
    ([obj respondsToSelector:@selector(count)] && [(NSArray *) obj count] == 0);
}

static inline BOOL TGIsStringEmpty(NSString *string) { // 空字符串
    return string == nil || [string isEqual:[NSNull null]] || string.length == 0 || [string isEqualToString:@"<null>"] ||
    [string isEqualToString:@"(null)"];
}

static inline NSString* TGTransformEmptyString(NSString *string) { // 补全空字符串
    return TGIsStringEmpty(string) ? @"" : string;
}

static inline UIViewController* TGGetCurViewController() {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [((UINavigationController*)result) topViewController];
    }
    else if ([result isKindOfClass:[UITabBarController class]])
    {
        result = ((UITabBarController*)result).selectedViewController;
    }
    return result;
}

static inline UINavigationController* TGGetCurNavigationController() {
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController* ctl = window.rootViewController;

    while (![ctl isKindOfClass:[UINavigationController class]]) {

        if ([ctl isKindOfClass:[UITabBarController class]]) {
            UITabBarController* tabctl = (UITabBarController*)ctl;
            ctl = tabctl.selectedViewController;
        }
        else{
            ctl = ctl.navigationController;
        }
        if (!ctl) {
            break;
        }
        
    }
    return (UINavigationController*)ctl;
}



#endif /* TGCommonMacro_h */
