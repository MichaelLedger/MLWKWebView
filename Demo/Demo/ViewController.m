//
//  ViewController.m
//  Demo
//
//  Created by MountainX on 2019/5/13.
//  Copyright © 2019 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#define KMainWidth ([UIScreen mainScreen].bounds.size.width)
#define KMainHeight ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView *mainWebView;
@property(nonatomic,strong)UIButton *alertButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainWebView];
    [self.view addSubview:self.alertButton];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (WKWebView *)mainWebView{
    
    if (_mainWebView == nil) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *userController = [[WKUserContentController alloc] init];
        configuration.userContentController = userController;
        _mainWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, KMainWidth, KMainHeight) configuration:configuration];
        NSString *path = [[[NSBundle mainBundle] bundlePath]  stringByAppendingPathComponent:@"index.html"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
        [_mainWebView loadRequest: request];
        _mainWebView.navigationDelegate = self;
        _mainWebView.UIDelegate = self;
        [userController addScriptMessageHandler:self name:@"currentCookies"];
    }
    return _mainWebView;
}

- (UIButton *)alertButton{
    
    if (_alertButton == nil) {
        _alertButton = [[UIButton alloc] initWithFrame:CGRectMake(KMainWidth*0.2, KMainHeight - 60, KMainWidth * 0.6, 40)];
        _alertButton.backgroundColor = [UIColor colorWithRed:250/255.0 green:204/255.0 blue:96/255.0 alpha:1.0];
        _alertButton.layer.cornerRadius = 6.0f;
        _alertButton.layer.masksToBounds = YES;
        _alertButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_alertButton setTitle:@"弹出弹窗" forState:UIControlStateNormal];
        [_alertButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_alertButton addTarget:self action:@selector(alertButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _alertButton;
}

- (void)alertButtonAction{
    
    [self.mainWebView evaluateJavaScript:@"alertAction('OC调用JS警告窗方法')" completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"alert");
    }];
    
}

//JS调用的OC回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"currentCookies"]) {
        NSString *cookiesStr = message.body;
        NSLog(@"当前的cookie为： %@", cookiesStr);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"JS调用的OC回调方法" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//接收到警告面板
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();//此处的completionHandler()就是调用JS方法时，`evaluateJavaScript`方法中的completionHandler
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


//接收到确认面板
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    
}

//接收到输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler{
    
}

- (void)dealloc{
    
    [self.mainWebView.configuration.userContentController removeScriptMessageHandlerForName:@"currentCookies"];
}
@end
