//
//  JHCellToolBar.m
//  FunSee
//
//  Created by qujiahong on 2018/5/19.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHCellToolBar.h"

@interface JHCellToolBar()

@property (nonatomic, strong) UIButton *praiseBtn;

@property (nonatomic, strong) UIButton *shareBtn;

/** 点赞次数*/
@property (nonatomic, assign) NSInteger clickNumber;


@end
@implementation JHCellToolBar


+(instancetype)creatToolBar{
    
    return [[self alloc]init];
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _praiseBtn = [[UIButton alloc]init];
        self.clickNumber = JHRandomNumber;
        [self.praiseBtn setTitle:[NSString stringWithFormat:@"%ld",self.clickNumber] forState:UIControlStateNormal];
        _praiseBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        _praiseBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_praiseBtn setTitleColor:JHRGB(80, 80, 80) forState:UIControlStateNormal];
        [_praiseBtn setImage:[UIImage imageNamed:@"praise"] forState:UIControlStateNormal];
        [_praiseBtn setImage:[UIImage imageNamed:@"praise_h"] forState:UIControlStateHighlighted];
        [_praiseBtn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_praiseBtn];
        
        _shareBtn = [[UIButton alloc]init];
        [_shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_shareBtn setTitleColor:JHRGB(80, 80, 80) forState:UIControlStateNormal];
        [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        _shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [self addSubview:_shareBtn];

    }
    return self;
}
-(void)layoutSubviews{

    [super layoutSubviews];

    self.praiseBtn.frame = CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height);
    self.shareBtn.frame = CGRectMake(CGRectGetMaxX(self.praiseBtn.frame), 0, self.frame.size.width/2, self.frame.size.height);
}


- (void)clickBtn{
    
    self.clickNumber++;
    [self.praiseBtn setTitle:[NSString stringWithFormat:@"%ld",(long)self.clickNumber] forState:UIControlStateNormal];
    [self showMoreLoveAnimateFromView:self.praiseBtn addToView:self];
    
}
- (void)showMoreLoveAnimateFromView:(UIView *)fromView addToView:(UIView *)addToView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 25)];
    CGRect loveFrame = [fromView convertRect:fromView.frame toView:addToView];
    CGPoint position = CGPointMake(fromView.layer.position.x, loveFrame.origin.y - 30);
    imageView.layer.position = position;
    NSArray *imgArr = @[@"heart_1",@"heart_2",@"heart_3",@"heart_4",@"heart_5",@"heart_1"];
    NSInteger img = arc4random()%6;
    imageView.image = [UIImage imageNamed:imgArr[img]];
    [addToView addSubview:imageView];
    
    imageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        imageView.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    CGFloat duration = 3 + arc4random()%5;
    CAKeyframeAnimation *positionAnimate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimate.repeatCount = 1;
    positionAnimate.duration = duration;
    positionAnimate.fillMode = kCAFillModeForwards;
    positionAnimate.removedOnCompletion = NO;
    
    UIBezierPath *sPath = [UIBezierPath bezierPath];
    [sPath moveToPoint:position];
    CGFloat sign = arc4random()%2 == 1 ? 1 : -1;
    CGFloat controlPointValue = (arc4random()%50 + arc4random()%100) * sign;
    [sPath addCurveToPoint:CGPointMake(position.x, position.y - 300) controlPoint1:CGPointMake(position.x - controlPointValue, position.y - 150) controlPoint2:CGPointMake(position.x + controlPointValue, position.y - 150)];
    positionAnimate.path = sPath.CGPath;
    [imageView.layer addAnimation:positionAnimate forKey:@"heartAnimated"];
    
    
    [UIView animateWithDuration:duration animations:^{
        imageView.layer.opacity = 0;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
}






 /**
 *创建一个按钮
 *title
 *image
 */
/*
 
 
//所有的按钮
//@property (nonatomic, strong) NSMutableArray *btns;


 //        NSString *praiseT = [NSString stringWithFormat:@"%ld",self.clickNumber];
 //        [self createToolBarBtnWithTitleNames:@[praiseT,@"分享"] images:@[@"praise",@"share"]];
 //        self.praiseBtn = self.btns[0];
 
 
-(UIButton *)setBtn:(NSString *)title image:(NSString *)image{
    UIButton * btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:FontColor1 forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.btns addObject:btn];
    [self addSubview:btn];
    return btn;
}

-(void)createToolBarBtnWithTitleNames:(NSArray *)titles images:(NSArray *)images{
    
    for (NSInteger i=0; i<titles.count; i++) {
        
        UIButton * btn = [[UIButton alloc]init];
        [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:JHRGB(80, 80, 80) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        btn.tag = i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [self.btns addObject:btn];
    }
}

 */

@end
