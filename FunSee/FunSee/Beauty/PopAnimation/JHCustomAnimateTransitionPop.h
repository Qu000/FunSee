//
//  JHCustomAnimateTransitionPop.h
//  FunSee
//
//  Created by qujiahong on 2018/5/29.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JHCustomAnimateTransitionPop : NSObject<UIViewControllerAnimatedTransitioning,CAAnimationDelegate>
@property(nonatomic,strong)id<UIViewControllerContextTransitioning>transitionContext;

@end
