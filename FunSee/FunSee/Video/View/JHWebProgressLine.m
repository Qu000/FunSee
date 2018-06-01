//
//  JHWebProgressLine.m
//  FunSee
//
//  Created by qujiahong on 2018/5/28.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHWebProgressLine.h"

@implementation JHWebProgressLine

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    
    self.backgroundColor = lineColor;
}

- (void)startLoadingAnimation {
    self.hidden = NO;
    self.width = 0.0;
    
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        weakSelf.width = SCREEN_WIDTH * 0.6;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.width = SCREEN_WIDTH * 0.8;
        }];
    }];
}

- (void)endLoadingAnimation {
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.width = SCREEN_WIDTH;
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
    }];
}


@end
