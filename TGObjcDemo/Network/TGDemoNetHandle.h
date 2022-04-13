//
//  TGDemoNetHandle.h
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/12.
//

#import <Foundation/Foundation.h>

typedef void(^HttpResponse)(BOOL success,id _Nullable data);
NS_ASSUME_NONNULL_BEGIN

@interface TGDemoNetHandle : NSObject

/**
 请求视频列表

 @param paramsData 请求参数
 @param responeBlock 请求完成之后的回调
 */
+ (void)requestForVideoList:(NSDictionary *)paramsData
                   response:(HttpResponse)responeBlock;

@end

NS_ASSUME_NONNULL_END
