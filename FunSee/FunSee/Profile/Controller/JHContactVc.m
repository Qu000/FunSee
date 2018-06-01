//
//  JHContactVc.m
//  FunSee
//
//  Created by qujiahong on 2018/5/28.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHContactVc.h"

#import "SpringTrasitionAnimation.h"

#import "JHPlayViewController.h"

@interface JHContactVc ()<UIViewControllerTransitioningDelegate>

@end

@implementation JHContactVc

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

///简书
- (IBAction)clickToJS:(id)sender {
    JHPlayViewController *playView = [[JHPlayViewController alloc]init];
    playView.url = @"https://www.jianshu.com/u/21c35a95919e";
    [self presentViewController:playView animated:YES completion:nil];
}

///GitHub
- (IBAction)clickToEmail:(id)sender {
    JHPlayViewController *playView = [[JHPlayViewController alloc]init];
    playView.url = @"https://github.com/Qu000";
    [self presentViewController:playView animated:YES completion:nil];
}

///GitHub.io
- (IBAction)clickToGitHub:(id)sender {
    JHPlayViewController *playView = [[JHPlayViewController alloc]init];
    playView.url = @"https://qu000.github.io";
    [self presentViewController:playView animated:YES completion:nil];
}

///点击推出
- (IBAction)clickToBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    return [[SpringTrasitionAnimation alloc]init];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    return [[SpringTrasitionAnimation alloc]init];
}

@end
