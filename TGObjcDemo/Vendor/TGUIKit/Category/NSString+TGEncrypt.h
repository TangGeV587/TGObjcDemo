//
//  NSString+TGEncrypt.h
//  TGObjcDemo
//
//  Created by hanghang on 2022/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TGEncrypt)

#pragma mark - BASE64

- (NSString*)encodeBase64;
- (NSString*)decodeBase64;

#pragma mark - SHA1

- (NSString *)md5;

#pragma mark - SHA1

- (NSString*)SHA1;
- (NSString*)SHA256;

#pragma mark - AES加密

-(NSString *)aes256_encrypt:(NSString *)key;
-(NSString *)aes256_decrypt:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
