//
//  MLWebViewActivity.h
//  Demo
//
//  Created by MountainX on 2019/5/14.
//  Copyright © 2019 MTX Software Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLWebViewActivity : UIActivity

@property (nonatomic, strong) NSURL *URL;

@property (copy, nonatomic) NSString *scheme;

@end

@interface MLWebViewActivityChrome : MLWebViewActivity @end
@interface MLWebViewActivitySafari : MLWebViewActivity @end

NS_ASSUME_NONNULL_END
