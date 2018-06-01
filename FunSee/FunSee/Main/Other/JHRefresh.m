//
//  JHRefresh.m
//  FunSee
//
//  Created by qujiahong on 2018/5/17.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHRefresh.h"

@implementation JHRefresh

- (instancetype)init
{
    if (self = [super init]) {
        self.lastUpdatedTimeLabel.hidden = YES;
        self.stateLabel.hidden = YES;
        [self setImages:@[[UIImage imageNamed:@"refresh_1"], [UIImage imageNamed:@"refresh_2"], [UIImage imageNamed:@"refresh_3"], [UIImage imageNamed:@"refresh_4"], [UIImage imageNamed:@"refresh_5"], [UIImage imageNamed:@"refresh_6"], [UIImage imageNamed:@"refresh_7"], [UIImage imageNamed:@"refresh_8"], [UIImage imageNamed:@"refresh_9"], [UIImage imageNamed:@"refresh_10"], [UIImage imageNamed:@"refresh_11"], [UIImage imageNamed:@"refresh_12"], [UIImage imageNamed:@"refresh_13"]]  forState:MJRefreshStateRefreshing];
        
        [self setImages:@[[UIImage imageNamed:@"refresh_1"], [UIImage imageNamed:@"refresh_2"], [UIImage imageNamed:@"refresh_3"], [UIImage imageNamed:@"refresh_4"], [UIImage imageNamed:@"refresh_5"], [UIImage imageNamed:@"refresh_6"], [UIImage imageNamed:@"refresh_7"], [UIImage imageNamed:@"refresh_8"], [UIImage imageNamed:@"refresh_9"], [UIImage imageNamed:@"refresh_10"], [UIImage imageNamed:@"refresh_11"], [UIImage imageNamed:@"refresh_12"], [UIImage imageNamed:@"refresh_13"]]  forState:MJRefreshStatePulling];
        
        [self setImages:@[[UIImage imageNamed:@"refresh_1"], [UIImage imageNamed:@"refresh_2"], [UIImage imageNamed:@"refresh_3"], [UIImage imageNamed:@"refresh_4"], [UIImage imageNamed:@"refresh_5"], [UIImage imageNamed:@"refresh_6"], [UIImage imageNamed:@"refresh_7"], [UIImage imageNamed:@"refresh_8"], [UIImage imageNamed:@"refresh_9"], [UIImage imageNamed:@"refresh_10"], [UIImage imageNamed:@"refresh_11"], [UIImage imageNamed:@"refresh_12"], [UIImage imageNamed:@"refresh_13"]]  forState:MJRefreshStateIdle];
    }
    return self;
}

@end
