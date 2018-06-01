//
//  JHBeautyWebController.m
//  FunSee
//
//  Created by qujiahong on 2018/5/20.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHBeautyWebController.h"

#import "JHWebProgressLine.h"

@interface JHBeautyWebController ()<UIWebViewDelegate>

///webView
@property (nonatomic, strong) UIWebView *webView;

/** 加载进度条*/
@property (nonatomic, strong) JHWebProgressLine * progressLine;

@end

@implementation JHBeautyWebController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(10, 30, 20, 20);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickToBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    self.view.backgroundColor = ThemeColorBar1;
    [self setupWebView];
}

- (void)setupWebView{
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    self.webView.delegate = self;
    [self.webView loadRequest:request];
    [self.view addSubview: self.webView];
    
    self.progressLine = [[JHWebProgressLine alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
    self.progressLine.lineColor = JHRGB(0, 158, 156);
    [self.webView addSubview:self.progressLine];
}


- (void)clickToBack{
    
    if (self.webView.canGoBack == YES) {
        [self.webView goBack];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma mark --- webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [self showHint:@"正在玩命加载中"];
    [self.progressLine startLoadingAnimation];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self showHint:@"加载完成"];
    [self.progressLine endLoadingAnimation];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self.progressLine endLoadingAnimation];
}

- (void)dealloc{
    
    NSLog(@"---dealloc--webView---");
    
    [self.webView removeFromSuperview];
}


@end
