//
//  TGWebViewController.m
//  TGObjcDemo
//
//  Created by 赵玉堂 on 2023/3/9.
//

#import "TGWebViewController.h"
#import <WebKit/WebKit.h>
#import "TGWeakScriptMessageDeledate.h"
@interface TGWebViewController ()<WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic ,strong) WKWebView *webView;

@end

@implementation TGWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadRequest {
    //创建request
    NSString *path = @"https://www.baidu.com";
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequestCachePolicy cachePolicy = NSURLRequestUseProtocolCachePolicy;
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:cachePolicy timeoutInterval:0];
    //请求
    [self.webView loadFileURL:request.URL allowingReadAccessToURL:[request.URL URLByDeletingLastPathComponent]];
//    [self.webView evaluateJavaScript:jsCode completionHandler:^(id _Nullable, NSError * _Nullable error) {}];
}



- (void)syncCookieToWKCookieStore:(WKHTTPCookieStore *)cookieStore {
//    WKHTTPCookieStore *cookieStore = self.webView.configuration.websiteDataStore.httpCookieStore;
    if (@available(iOS 11.0, *)){
        NSArray *cookieList = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        if(cookieList.count == 0) return;
        for (NSHTTPCookie *cookie in cookieList) {
            [cookieStore setCookie:cookie completionHandler:^{
                if([cookieList.lastObject isEqual:cookie]){
                    
//                    [self webViewSetCookieSuccess];
                }
            }];
        }
    }
}

- (void)setupUI {
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    NSString *messageHandleName = @"bridge";
    [webConfig.userContentController addScriptMessageHandler:[[TGWeakScriptMessageDeledate alloc] initWithDelegate:self] name:messageHandleName];
    WKWebpagePreferences *preferences = [[WKWebpagePreferences alloc] init];
    preferences.allowsContentJavaScript = YES;
    
    /// 创建WKUserScript
//    WKUserScript *jqueryScript = [[WKUserScript alloc]initWithSource:jqueryString injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
       /// 注入到configuration配置内
//    [webConfig.userContentController addUserScript:jqueryScript];
    
    WKWebsiteDataStore *dataStore = [WKWebsiteDataStore defaultDataStore];
    // [WKWebsiteDataStore allWebsiteDataTypes] 所有类型
    [dataStore fetchDataRecordsOfTypes:[NSSet setWithObject:WKWebsiteDataTypeCookies] completionHandler:^(NSArray<WKWebsiteDataRecord *> * _Nonnull records) {
        for (WKWebsiteDataRecord *record in records) {
            if([record.displayName isEqualToString:@"baidu"]) {
                [dataStore removeDataOfTypes:record.dataTypes forDataRecords:@[record] completionHandler:^{
                    NSLog(@"Cookies for %@ deleted successfully",record.displayName);
                }];
            }
        }
    }];
    webConfig.websiteDataStore = dataStore;
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:webConfig];
    self.webView.navigationDelegate = self;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *url = navigationAction.request.URL.absoluteString;
    if([url hasPrefix:@"https:"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    if([navigationResponse.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse;
        NSInteger code = response.statusCode;
        NSString *url = response.URL.absoluteString;
        NSLog(@"当前状态值:%zd 当前地址:%@",code,url);
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
//    [self importJS];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        if ([challenge previousFailureCount] == 0) {
            // 如果没有错误的情况下 创建一个凭证，并使用证书
            NSURLCredential *credential = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
            // 验证失败，取消本次验证
            completionHandler(NSURLSessionAuthChallengeUseCredential,nil);
        }else {
            completionHandler(NSURLSessionAuthChallengeUseCredential,nil);
        }
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"bridge"]) {
        
        NSLog(@"----%@",message.body);
    }
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [webView reload];
}

@end
