//
//  XYWebViewController.m
//  MiaoLive
//
//  Created by mofeini on 16/11/21.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//

#import "XYWebViewController.h"

@interface XYWebViewController ()

@property (nonatomic, weak) UIWebView *webView;
@end

@implementation XYWebViewController
- (UIWebView *)webView {

    if (_webView == nil) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:webView];
        _webView = webView;
    }
    return _webView;
}

- (instancetype)initWithURL:(NSURL *)URL {

    if (self = [super init]) {
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
    }
    return self;
}

- (void)dealloc {

    NSLog(@"%s", __FUNCTION__);
}
@end
