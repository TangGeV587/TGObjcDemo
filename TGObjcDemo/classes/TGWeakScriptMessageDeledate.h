//
//  TGWeakScriptMessageDeledate.h
//  TGObjcDemo
//
//  Created by 赵玉堂 on 2023/3/9.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>


@interface TGWeakScriptMessageDeledate : NSObject<WKScriptMessageHandler>

@property (nonatomic ,weak) id<WKScriptMessageHandler> delegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end

