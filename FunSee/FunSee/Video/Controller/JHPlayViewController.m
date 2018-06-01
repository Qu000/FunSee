//
//  JHPlayViewController.m
//  FunSee
//
//  Created by qujiahong on 2018/5/22.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHPlayViewController.h"

#import "JHWebProgressLine.h"

@interface JHPlayViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView * web;

@property (nonatomic, strong) UIView * videoView;

@property (nonatomic, strong) UIImageView * placeHolder;

@property (nonatomic, strong) UIView * topView;

/** 加载进度条*/
@property (nonatomic, strong) JHWebProgressLine * progressLine;
@end

@implementation JHPlayViewController

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
        _topView.backgroundColor = ThemeColorBar1;
        [self.view addSubview:_topView];
    }
    return _topView;
}

- (UIImageView *)placeHolder{
    if (!_placeHolder) {
        _placeHolder = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _placeHolder.image = [UIImage imageNamed:@"outLine"];
        [self.web addSubview:_placeHolder];
    }
    return _placeHolder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.placeHolder.hidden = YES;
    
    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(10, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickToBack) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:backBtn];
    
    self.view.backgroundColor = ThemeColorBar1;
    
    if (self.index == 1) {
        //web
        self.url = self.model.model.url;
        [self setupWebPlayer];
    }else{
        //
        [self setupWebPlayer];
    }
}
- (void)setupWebPlayer{
    
    UIWebView *webPlayer = [[UIWebView alloc]init];
    webPlayer.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [webPlayer loadRequest:request];
    webPlayer.delegate = self;
    [self.view addSubview:webPlayer];
    self.web = webPlayer;
    
    
    self.progressLine = [[JHWebProgressLine alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
    self.progressLine.lineColor = JHRGB(0, 158, 156);
    [self.web addSubview:self.progressLine];
    
}

- (void)clickToBack{
    
    if (self.web.canGoBack == YES) {
        [self.web goBack];
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
    self.placeHolder.hidden = NO;
}


- (void)dealloc{
    
    NSLog(@"---dealloc--Player---");
    
    [self.web removeFromSuperview];
}

@end
