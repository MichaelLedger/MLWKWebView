//
//  MLWebViewActivity.m
//  Demo
//
//  Created by MountainX on 2019/5/14.
//  Copyright © 2019 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import "MLWebViewActivity.h"

@implementation MLWebViewActivity

- (UIActivityType)activityType {
    return NSStringFromClass([self class]);
}

- (UIImage *)activityImage {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *bundlePath = [bundle pathForResource:@"MLWebView" ofType:@"bundle"];
    if (bundlePath) {
        NSBundle *bundle2 = [NSBundle bundleWithPath:bundlePath];
        if (bundle2) bundle = bundle2;
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return [UIImage imageNamed:[self.activityType stringByAppendingString:@"-iPad"] inBundle:bundle compatibleWithTraitCollection:nil];
    } else {
        return [UIImage imageNamed:self.activityType inBundle:bundle compatibleWithTraitCollection:nil];
    }
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            self.URL = activityItem;
        }
    }
}

@end

@implementation MLWebViewActivityChrome

- (NSString *)schemePrefix {
    return @"googlechrome://";
}

- (NSString *)activityTitle {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resourcePath = [bundle pathForResource:@"MLWebView" ofType:@"bundle"] ;
    
    if (resourcePath){
        NSBundle *bundle2 = [NSBundle bundleWithPath:resourcePath];
        if (bundle2){
            bundle = bundle2;
        }
    }
    
    return NSLocalizedStringFromTableInBundle(@"OpenInChrome", @"MLWebView", bundle, @"Open in Chrome");
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]] && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.schemePrefix]]) {
            return YES;
        }
    }
    return NO;
}

- (void)performActivity {
    NSString *openingURL;
    if (@available(iOS 9.0, *)) {
        openingURL = [self.URL.absoluteString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        openingURL = [self.URL.absoluteString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
    }
    
    NSURL *activityURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.schemePrefix, openingURL]];
    
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:activityURL options:@{} completionHandler:NULL];
    } else {
        [[UIApplication sharedApplication] openURL:activityURL];
    }
    
    [self activityDidFinish:YES];
}

@end

@implementation MLWebViewActivitySafari
- (NSString *)activityTitle {
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    NSString *resourcePath = [bundle pathForResource:@"MLWebView" ofType:@"bundle"] ;
    
    if (resourcePath){
        NSBundle *bundle2 = [NSBundle bundleWithPath:resourcePath];
        if (bundle2){
            bundle = bundle2;
        }
    }
    
    return NSLocalizedStringFromTableInBundle(@"OpenInSafari", @"MLWebView", bundle, @"Open in Safari");
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]] && [[UIApplication sharedApplication] canOpenURL:activityItem]) {
            return YES;
        }
    }
    return NO;
}

- (void)performActivity {
    BOOL completed = [[UIApplication sharedApplication] openURL:self.URL];
    [self activityDidFinish:completed];
}

@end
