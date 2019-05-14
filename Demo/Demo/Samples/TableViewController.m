//
//  TableViewController.m
//  MLWebViewController
//
//  Created by ai on 15/12/23.
//  Copyright © 2015年 AiXing. All rights reserved.
//

#import "TableViewController.h"
#import "MLWebViewController.h"
#import "AXPracticalHUD.h"

@interface TableViewController () <UITextFieldDelegate>

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"back", @"MLWebViewController", [NSBundle bundleWithPath:[[[NSBundle bundleForClass:NSClassFromString(@"MLWebViewController")] resourcePath] stringByAppendingPathComponent:@"MLWebViewController.bundle"]], @"Back") style:0 target:nil action:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            MLWebViewController *webVC = [[MLWebViewController alloc] initWithURL:[NSURL fileURLWithPath:[NSBundle.mainBundle pathForResource:@"Swift" ofType:@"pdf"]]];
            webVC.title = @"Swift.pdf";
            webVC.showsToolBar = NO;
            if (@available(iOS 9.0, *)) {
                webVC.webView.allowsLinkPreview = YES;
            } else {
                // Fallback on earlier versions
            }
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 1:
        {
            MLWebViewController *webVC = [[MLWebViewController alloc] initWithAddress:@"http://www.baidu.com"];
            webVC.showsToolBar = NO;
            // webVC.showsNavigationCloseBarButtonItem = NO;
            if (@available(iOS 9.0, *)) {
                webVC.webView.allowsLinkPreview = YES;
            } else {
                // Fallback on earlier versions
            }
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        case 2:
        {
            MLWebViewController *webVC = [[MLWebViewController alloc] initWithAddress:@"http://www.baidu.com"];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
            nav.navigationBar.tintColor = [UIColor colorWithRed:0.322 green:0.322 blue:0.322 alpha:1.00];
            [self presentViewController:nav animated:YES completion:NULL];
            webVC.showsToolBar = YES;
            webVC.navigationType = 1;
        }
            break;
        case 3: {
            MLWebViewController *webVC = [[MLWebViewController alloc] initWithAddress:@"https://github.com/devedbox/MLWebViewController"];
            webVC.showsToolBar = NO;
            webVC.showsBackgroundLabel = NO;
            // webVC.showsNavigationBackBarButtonItemTitle = NO;
            if (@available(iOS 9.0, *)) {
                webVC.webView.allowsLinkPreview = YES;
            } else {
                // Fallback on earlier versions
            }
            [self.navigationController pushViewController:webVC animated:YES];
        } break;
        case 4: {
            MLWebViewController *webVC = [[MLWebViewController alloc] initWithAddress:@"https://github.com/devedbox/MLWebViewController/releases/latest"];
            webVC.showsToolBar = NO;
            if (@available(iOS 9.0, *)) {
                webVC.webView.allowsLinkPreview = YES;
            } else {
                // Fallback on earlier versions
            }
            [self.navigationController pushViewController:webVC animated:YES];
        } break;
        default:
            break;
    }
}

- (void)handle:(id)sender {
    NSURL *URL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"MLWebViewController.bundle/html.bundle/neterror" ofType:@"html" inDirectory:nil]];
    MLWebViewController *webVC = [[MLWebViewController alloc] initWithURL:URL];
    webVC.showsToolBar = NO;
    webVC.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.100f green:0.100f blue:0.100f alpha:0.800f];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.996f green:0.867f blue:0.522f alpha:1.00f];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)gotoGithub:(id)sender {
    MLWebViewController *webVC = [[MLWebViewController alloc] initWithAddress:@"https://github.com/devedbox/MLWebViewController"];
    webVC.showsToolBar = NO;
    if (@available(iOS 9.0, *)) {
        webVC.webView.allowsLinkPreview = YES;
    } else {
        // Fallback on earlier versions
    }
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)clearCacheBtnClicked:(id)sender {
    [[AXPracticalHUD sharedHUD] showNormalInView:self.navigationController.view text:@"清理缓存..." detail:nil configuration:NULL];
    [MLWebViewController clearWebCacheCompletion:^{
        [[AXPracticalHUD sharedHUD] hide:YES afterDelay:0.5 completion:NULL];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Get the text of text field.
    NSString *text = [textField.text copy];
    // Create an url object with the text string.
    NSURL *URL = [NSURL URLWithString:text];
    
    if (URL) {
        [self.view endEditing:YES];
        
        MLWebViewController *webVC = [[MLWebViewController alloc] initWithURL:URL];
        webVC.showsToolBar = NO;
        if (@available(iOS 9.0, *)) {
            webVC.webView.allowsLinkPreview = YES;
        } else {
            // Fallback on earlier versions
        }
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
    return YES;
}
@end
