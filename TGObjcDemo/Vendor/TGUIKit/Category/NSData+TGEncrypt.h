//
//  NSData+TGEncrypt.h
//  TGObjcDemo
//
//  Created by hanghang on 2022/11/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (TGEncrypt)

#pragma mark - BASE64

- (NSString*)encodeBase64;
- (NSString*)decodeBase64;

#pragma mark - md5

- (NSString *)md5;

#pragma mark - SHA1

- (NSString*)SHA1;
- (NSString*)SHA256;


#pragma mark - AES加密

-(NSData *)aes256_encrypt:(NSString *)key;
-(NSData *)aes256_decrypt:(NSString *)key;

- (NSData *)AES128EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES128DecryptWithKey:(NSString *)key;   //解密
     
@end

NS_ASSUME_NONNULL_END
