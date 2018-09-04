//
//  TJWKWebController.m
//  TJBridge
//
//  Created by tao on 2018/9/4.
//  Copyright © 2018年 tao. All rights reserved.
//

#import "TJWKWebController.h"
#import "WebViewJavascriptBridge.h"

@interface TJWKWebController ()
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

@end

@implementation TJWKWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"WKWebView";
    WKWebView* webView = [[NSClassFromString(@"WKWebView") alloc] initWithFrame:self.view.bounds];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    
    // 加载网页
    
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
    
    // 开启日志
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [_bridge setWebViewDelegate:self];
    
    [self initBottomUI];

    [_bridge registerHandler:@"fromjsExample" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (![data[@"check"] isEqualToString:@"isuiwebview"]) {
            responseCallback(@"success");
        }else{
            responseCallback(@"error");
            
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidFinishLoad");
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (UIButton *)creatBtn:(NSInteger)tag title:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    
    return button;
}
- (void)initBottomUI{
    CGFloat height = ([[UIScreen mainScreen] bounds].size.height) - 50;
    CGFloat width = ([[UIScreen mainScreen] bounds].size.width);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, height - 100 , width, 100)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor orangeColor];
    UIButton *button = [self creatBtn:100 title:@"JSAlertEmaple"];
    [view addSubview:button];
    button.frame = CGRectMake(20, 10, 200, 30);
    [button sizeToFit];
    UIButton *button1 = [self creatBtn:101 title:@"getJSUserInfo"];
    [view addSubview:button1];
    button1.frame = CGRectMake(20, 40, 200, 30);
    [button1 sizeToFit];
}

- (void)buttonClick:(UIButton *)button{
    if (button.tag == 100) {
        [self.bridge callHandler:@"JSAlertEmaple" data:nil];
    }else{
        [self.bridge callHandler:@"getJSUserInfo" data:@{@"userId":@"tj002"} responseCallback:^(id responseData) {
            NSLog(@"from js: %@", responseData[@"userName"]);
        }];
    }
    
}
@end
