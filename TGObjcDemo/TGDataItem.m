//
//  TGDataItem.m
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/3/25.
//

#import "TGDataItem.h"

@implementation TGDataItem

- (instancetype)init:(NSString *)title withClassName:(NSString *)name{
    if (self = [super init]) {
        _title = title;
        _className = name;
    }
    return self;
}


@end
