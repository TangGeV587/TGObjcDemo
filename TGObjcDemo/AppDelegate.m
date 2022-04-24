//
//  AppDelegate.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/3/24.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
//    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
//    BOOL has_AMPM = containsA.location != NSNotFound;
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    NSString *dateStr = @"2022-4-25 14:00";
//    if (has_AMPM) {
//        format.dateFormat = @"yyyy-MM-dd hh:mm"; //2022-04-21 11:53 AM  2022-04-21 12:52 PM  2022-04-21 01:07 PM
//        NSLog(@"12小时制");
//    }else {
//        NSLog(@"24小时制");
//        format.dateFormat = @"yyyy-MM-dd HH:mm"; //2022-04-21 11:52 AM
//    }
//
//    NSDate *date = [format dateFromString:dateStr];
//    NSString *time = [format stringFromDate:[NSDate date]];
//    NSLog(@"--- %@  \n %@",time,date);
    
    return YES;
}





#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
