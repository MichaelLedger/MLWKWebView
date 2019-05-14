//
//  MLWebViewController.h
//  MLWebViewController
//
//  Created by MountainX on 2019/5/14.
//  Copyright © 2019 MTX Software Technology Co.,Ltd. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#ifndef __IPHONE_8_0
#define __IPHONE_8_0    80000
#endif

#ifndef __IPHONE_9_0
#define __IPHONE_9_0    90000
#endif

/*
 __IPHONE_OS_VERSION_MAX_ALLOWED：值等于Base SDK，当前开发环境版本（当前开发环境的系统SDK版本），如Xcode9.4.1中SDK版本是是iOS11.4。
 
 __IPHONE_OS_VERSION_MIN_REQUIRED： 值等于Deployment Target，检查支持的最小系统版本。
 
 NS_AVAILABLE_IOS(6_0)：自iOS6.0开始支持该方法，若在iOS6.0之前的版本使用该方法，则会导致 Crash；
 
 NS_DEPRECATED_IOS(2_0, 3_0)：表示该方法只能在IOS2.0 和 IOS3.0之间使用，是已被废弃的方法，但并不是说在IOS3.0之后不能使用该方法，是可以使用，但也需要考虑找其他替代方法了。
 
 NS_AVAILABLE(10_8, 6_0)：表示该方法分别随Mac OS 10.8和iOS 6.0被引入。
 
 NS_DEPRECATED(10_0, 10_6, 2_0, 4_0)：表示该方法随Mac OS 10.0和iOS 2.0被引入，在Mac OS 10.6和iOS 4.0后被废弃。
 
 注意：
 
 Base SDK用来编译APP的SDK（Software Development Kit）的版本，一般保持当前XCode支持的最新的就好。
 
 SDK其实就是包含了所有的你要用到的头文件、链接库的集合，你的APP里面用的各种类、函数，能编译、链接成最后的安装包，就要靠它，苹果每次升级系统，新推出的各种API，也是在SDK里面。所以一般Base SDK肯定是大于等于Deployment Target的版本。
 */

#ifndef ML_WEB_USING_WEBKIT
#define ML_WEB_USING_WEBKIT __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
//#define ML_WEB_USING_WEBKIT 0
#endif

#ifndef ML_WEB_AVAILABILITY
#define ML_WEB_AVAILABILITY BOOL ML_WEB_iOS8_0_AVAILABLE(void);\
                            BOOL ML_WEB_iOS9_0_AVAILABLE(void);\
                            BOOL ML_WEB_iOS10_0_AVAILABLE(void);
#endif

#ifndef ML_REQUIRES_SUPER
#if __has_attribute(objc_requires_super)
#define ML_REQUIRES_SUPER __attribute__((objc_requires_super))
#else
#define ML_REQUIRES_SUPER
#endif
#endif

#import <UIKit/UIKit.h>
#if ML_WEB_USING_WEBKIT
#import <WebKit/WebKit.h>
#import "MLSecurityPolicy.h"
#else
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#endif

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MLWebViewNavigationType) {
    /// Navigation bar items.
    MLWebViewNavigationTypeBarItem,
    /// Tool bar items.
    MLWebViewNavigationTypeToolItem
};

@class MLWebViewController;

@protocol MLWebViewControllerDelegate <NSObject>
@optional
/// Called when web view will go back.
///
/// @param webViewController a web view controller.
- (void)webViewControllerWillGoBack:(MLWebViewController *)webViewController;
/// Called when web view will go forward.
///
/// @param webViewController a web view controller.
- (void)webViewControllerWillGoForward:(MLWebViewController *)webViewController;
/// Called when web view will reload.
///
/// @param webViewController a web view controller.
- (void)webViewControllerWillReload:(MLWebViewController *)webViewController;
/// Called when web view will stop load.
///
/// @param webViewController a web view controller.
- (void)webViewControllerWillStop:(MLWebViewController *)webViewController;
/// Called when web view did start loading.
///
/// @param webViewController a web view controller.
- (void)webViewControllerDidStartLoad:(MLWebViewController *)webViewController;
/// Called when web view did finish loading.
///
/// @param webViewController a web view controller.
- (void)webViewControllerDidFinishLoad:(MLWebViewController *)webViewController;
/// Called when web viw did fail loading.
///
/// @param webViewController a web view controller.
///
/// @param error a failed loading error.
- (void)webViewController:(MLWebViewController *)webViewController didFailLoadWithError:(NSError *)error;
@end

#if ML_WEB_USING_WEBKIT
API_AVAILABLE(ios(8.0))
@interface MLWebViewController : UIViewController <WKUIDelegate, WKNavigationDelegate>
{
    @protected
    WKWebView *_webView;
    NSURL *_URL;
}
#else
API_AVAILABLE(ios(7.0))
@interface MLWebViewController : UIViewController
{
    @protected
    UIWebView *_webView;
    NSURL *_URL;
}
#endif

@property (nonatomic, weak) id<MLWebViewControllerDelegate> delegate;

#if ML_WEB_USING_WEBKIT
@property(readonly, nonatomic) WKWebView *webView;
/// Default is NO. Enabled to allow present alert views.
@property(assign, nonatomic) BOOL enabledWebViewUIDelegate;

#else
@property(readonly, nonatomic) UIWebView *webView;
#endif

/// Open app link in app store app. Default is NO.
@property(assign, nonatomic) BOOL reviewsAppInAppStore;
/// Max length of title string content. Default is 10.
@property(assign, nonatomic) NSUInteger maxAllowedTitleLength;
/// Time out internal.
@property(assign, nonatomic) NSTimeInterval timeoutInternal;
/// Cache policy.
@property(assign, nonatomic) NSURLRequestCachePolicy cachePolicy;

/// The based initialized url of the web view controller if any.
@property(readonly, nonatomic) NSURL *URL;
/// Shows tool bar. Default is YES.
@property(assign, nonatomic) BOOL showsToolBar;
/// Shows background description label. Default is YES.
@property(assign, nonatomic) BOOL showsBackgroundLabel;
/// Shows navigation close bar button item. Default is YES.
@property(assign, nonatomic) BOOL showsNavigationCloseBarButtonItem;
/// Shows the title of navigation back bar button item. Default is YES.
@property(assign, nonatomic) BOOL showsNavigationBackBarButtonItemTitle;
/// Check url can open default YES, only work after iOS 8.
@property(assign, nonatomic) BOOL checkUrlCanOpen API_AVAILABLE(ios(8.0));
/// Navigation type.
@property(assign, nonatomic) MLWebViewNavigationType navigationType;
/// Navigation close bar button item.
@property(readwrite, nonatomic) UIBarButtonItem *navigationCloseItem;

/// Get a instance of `AXWebViewController` by a url string.
///
/// @param urlString a string of url to be loaded.
///
/// @return a instance `AXWebViewController`.
- (instancetype)initWithAddress:(NSString*)urlString;
/// Get a instance of `AXWebViewController` by a url.
///
/// @param URL a URL to be loaded.
///
/// @return a instance of `AXWebViewController`.
- (instancetype)initWithURL:(NSURL*)URL;
/// Get a instance of `AXWebViewController` by a url request.
///
/// @param request a URL request to be loaded.
///
/// @return a instance of `AXWebViewController`.
- (instancetype)initWithRequest:(NSURLRequest *)request;
#if ML_WEB_USING_WEBKIT
/// Get a instance of `AXWebViewController` by a url and configuration of web view.
///
/// @param URL a URL to be loaded.
/// @param configuration configuration instance of WKWebViewConfiguration to create web view.
///
/// @return a instance of `AXWebViewController`.
- (instancetype)initWithURL:(NSURL *)URL configuration:(WKWebViewConfiguration *)configuration;
/// Get a instance of `AXWebViewController` by a request and configuration of web view.
///
/// @param request a URL request to be loaded.
/// @param configuration configuration instance of WKWebViewConfiguration to create web view.
///
/// @return a instance of `AXWebViewController`.
- (instancetype)initWithRequest:(NSURLRequest *)request configuration:(WKWebViewConfiguration *)configuration;
#endif
/// Get a instance of `AXWebViewController` by a HTML string and a base URL.
///
/// @param HTMLString a HTML string object.
/// @param baseURL a baseURL to be loaded.
///
/// @return a instance of `AXWebViewController`.
- (instancetype)initWithHTMLString:(NSString *)HTMLString baseURL:(NSURL * _Nullable)baseURL;
/// Load a new url.
///
/// @param URL a new url.
- (void)loadURL:(NSURL*)URL;
/// Load a new html string.
///
/// @param HTMLString a encoded html string.
/// @param baseURL base url of bundle.
- (void)loadHTMLString:(NSString *)HTMLString baseURL:(NSURL *)baseURL;

@end

@interface MLWebViewController (SubclassingHooks)
/// Called when web view will go back. Do not call this directly. Same to the bottom methods.
/// @discussion 使用的时候需要子类化，并且调用super的方法!切记！！！
///
- (void)willGoBack ML_REQUIRES_SUPER;
/// Called when web view will go forward. Do not call this directly.
///
- (void)willGoForward ML_REQUIRES_SUPER;
/// Called when web view will reload. Do not call this directly.
///
- (void)willReload ML_REQUIRES_SUPER;
/// Called when web view will stop load. Do not call this directly.
///
- (void)willStop ML_REQUIRES_SUPER;
/// Called when web view did start loading. Do not call this directly.
///
- (void)didStartLoad ML_REQUIRES_SUPER NS_DEPRECATED_IOS(2_0, 8_0);
#if ML_WEB_USING_WEBKIT
/// Called when web view(WKWebView) did start loading. Do not call this directly.
///
/// @param navigation Navigation object of the current request info.
- (void)didStartLoadWithNavigation:(WKNavigation *)navigation ML_REQUIRES_SUPER NS_AVAILABLE(10_10, 8_0);
#endif
/// Called when web view did finish loading. Do not call this directly.
///
- (void)didFinishLoad ML_REQUIRES_SUPER;
/// Called when web viw did fail loading. Do not call this directly.
///
/// @param error a failed loading error.
- (void)didFailLoadWithError:(NSError *)error ML_REQUIRES_SUPER;
@end

/**
 WebCache clearing.
 */
@interface MLWebViewController (WebCache)
/// Clear cache data of web view.
///
/// @param completion completion block.
+ (void)clearWebCacheCompletion:(dispatch_block_t _Nullable)completion;
@end

/**
 Accessibility to background label.
 */
@interface MLWebViewController (BackgroundLabel)
/// Description label of web content's info.
///
@property(readonly, nonatomic) UILabel *descriptionLabel;
@end

#if ML_WEB_USING_WEBKIT
typedef NSURLSessionAuthChallengeDisposition(^WKWebViewDidReceiveAuthenticationChallengeHandler)(WKWebView *webView, NSURLAuthenticationChallenge *challenge, NSURLCredential * _Nullable __autoreleasing * _Nullable credential);

@interface MLWebViewController (Security)
/// Challenge handler for the credential.
@property(copy, nonatomic, nullable) WKWebViewDidReceiveAuthenticationChallengeHandler challengeHandler;
/// The security policy used by created session to evaluate server trust for secure connections.
/// `AXWebViewController` uses the `defaultPolicy` unless otherwise specified.
@property(readwrite, nonatomic, nullable) MLSecurityPolicy *securityPolicy;
@end
#endif

NS_ASSUME_NONNULL_END
