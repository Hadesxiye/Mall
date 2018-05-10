//
//  WebVC.m
//  sock
//
//  Created by 王浩祯 on 2018/5/9.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "WebVC.h"
#import<WebKit/WebKit.h>
@interface WebVC ()<WKNavigationDelegate,WKUIDelegate>

@end

@implementation WebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    WKWebView* webView = [[WKWebView alloc]init];
    [self.view addSubview:webView];
    webView.frame = CGRectMake(0, NAVSTASTUS, SC_WIDTH, SC_HEIGHT - NAVSTASTUS);
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.lencier.com"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
