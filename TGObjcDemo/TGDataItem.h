//
//  TGDataItem.h
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TGDataItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *className;

- (instancetype)init:(NSString *)title withClassName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
