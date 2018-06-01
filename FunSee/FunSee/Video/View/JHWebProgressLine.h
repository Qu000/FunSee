//
//  JHWebProgressLine.h
//  FunSee
//
//  Created by qujiahong on 2018/5/28.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHWebProgressLine : UIView


/// 进度条颜色
@property (nonatomic,strong) UIColor *lineColor;

/// 开始加载
- (void)startLoadingAnimation;

/// 结束加载
- (void)endLoadingAnimation;

@end
