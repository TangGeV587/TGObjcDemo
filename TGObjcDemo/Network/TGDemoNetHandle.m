//
//  TGDemoNetHandle.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/12.
//

#import "TGDemoNetHandle.h"

@interface TGDemoNetHandle ()


@end

static const float delaySeconds = 2.0f;

@implementation TGDemoNetHandle

/**
 请求视频列表
 
 @param paramsData 请求参数
 @param responeBlock 请求完成之后的回调
 */
+ (void)requestForVideoList:(NSDictionary *)paramsData
                   response:(HttpResponse)responeBlock{
    //使用延时操作，模拟登录网络请求,并在这里发送消息
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds)*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        NSDictionary *returnData;
        BOOL success = YES;
        //模拟只有三页数据的情况和没有更多数据的情况
        NSString *requestPage = paramsData[@"page"];
        if ([requestPage integerValue] > 3) {
            returnData = @{@"status":@"0",@"errorMsg":@"没有更多数据了",@"videos":@[]};
        }else{
            returnData = [self getDictionaryFromJsonFile:[NSString stringWithFormat:@"VideoList%@",requestPage]];
        }
        responeBlock(success,returnData);
    });
}

+ (NSDictionary *)getDictionaryFromJsonFile:(NSString *)fileName{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@".json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSError *error = nil;
    NSDictionary *  jsonDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (jsonDic == nil) {
        NSLog(@"解析文件失败");
        return nil;
    }
    return jsonDic;
}

@end
