//
//  TGHelper.h
//  TGObjcDemo
//
//  Created by e-zhaoyutang on 2022/4/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

typedef void (^TGAsyncImageComplete)(NSString * path, UIImage *image);

@interface TGHelper : NSObject

+ (void)asyncDecodeImage:(NSString *)path complete:(TGAsyncImageComplete)complete;

@end

