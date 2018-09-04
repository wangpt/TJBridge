//
//  TJUIWebController.m
//  TJBridge
//
//  Created by tao on 2018/9/4.
//  Copyright © 2018年 tao. All rights reserved.
//

#import "TJUIWebController.h"
#import "WebViewJavascriptBridge.h"

@interface TJUIWebController ()
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

@end

@implementation TJUIWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  @"UIWebView";

    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat height = ([[UIScreen mainScreen] bounds].size.height);
    CGFloat width = ([[UIScreen mainScreen] bounds].size.width);//self.view.bounds
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, width, height)];
    [self.view addSubview:webView];
    // 2.加载网页
    NSString *indexPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString *appHtml = [NSString stringWithContentsOfFile:indexPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseUrl = [NSURL fileURLWithPath:indexPath];
    [webView loadHTMLString:appHtml baseURL:baseUrl];
    //开启日志
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [_bridge setWebViewDelegate:self];
    
    
    //    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
    //        NSLog(@"testObjcCallback called: %@", data);
    //        responseCallback(@"Response from testObjcCallback");
    //    }];
    
    [self initBottomUI];
 
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
        [self.bridge callHandler:@"getJSUserInfo" data:@{@"userId":@"TJ001"} responseCallback:^(id responseData) {
            NSLog(@"from js: %@", responseData[@"userName"]);

        }];
    }

}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
