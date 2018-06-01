//
//  JHNavigationController.m
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/2.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHNavigationController.h"

@interface JHNavigationController ()

@end

@implementation JHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBar.translucent = NO;
    [self.navigationBar setBarTintColor:ThemeColorBar1];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : ThemeColorNavFont1,
                                                                      NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:17]}];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
