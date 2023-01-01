//
//  TGFileHash.h
//  TGObjcDemo
//
//  Created by hanghang on 2022/12/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TGFileHash : NSObject

+ (NSString *)md5HashOfFileAtPath:(NSString *)filePath;
+ (NSString *)sha1HashOfFileAtPath:(NSString *)filePath;
+ (NSString *)sha512HashOfFileAtPath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
