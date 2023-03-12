//
//  TGWeakScriptMessageDeledate.m
//  TGObjcDemo
//
//  Created by 赵玉堂 on 2023/3/9.
//

#import "TGWeakScriptMessageDeledate.h"

@implementation TGWeakScriptMessageDeledate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    if(self = [super init]) {
        _delegate = scriptDelegate;
    }
    return self;
    
}

- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    if(self.delegate && [self.delegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)])
    [self.delegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
