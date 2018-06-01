//
//  JHHomeTopView.m
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/3.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHHomeTopView.h"
#import "Wave.h"

@interface JHHomeTopView()
/** topView的按钮 */
@property (nonatomic, strong) NSMutableArray * buttons;
/** topView按钮下的线条 */
@property (nonatomic, strong) UIView *lineView;

/** topView按钮下的小船*/
@property (nonatomic, strong) UIImageView * shipImageView;
/** 波浪特效*/
@property (nonatomic, strong) Wave * waveView;
@end
@implementation JHHomeTopView

-(NSArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
        [_waveView startWaveAnimation];
    }
    return _buttons;
}

-(Wave *)waveView{
    if (!_waveView) {
        _waveView = [[Wave alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height-7)];
        _waveView.backgroundColor = ThemeColorBar1;//JHRGB(254, 225, 227)
        [self addSubview:_waveView];
    }
    return _waveView;
}

-(instancetype)initWithFrame:(CGRect)frame titleNames:(NSArray *)titles{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat btnW = self.frame.size.width/titles.count;
        CGFloat btnH = self.frame.size.height;
        
        for (NSInteger i=0; i<titles.count; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString * vcTitle = titles[i];
            [button setTitle:vcTitle forState:UIControlStateNormal];
            
            [button setTitleColor:JHRGB(40, 40, 40) forState:UIControlStateNormal];
            
            [button setTitleColor:ThemeColorNavFont1 forState:UIControlStateSelected];
            
            button.titleLabel.font = [UIFont systemFontOfSize:18];
            
            button.frame = CGRectMake(i*btnW, -10, btnW, btnH);
            
            [button addTarget:self action:@selector(clickTitle:) forControlEvents:UIControlEventTouchUpInside];
            
            button.tag = i;//设置block的回传
            
            [self.waveView addSubview:button];
            
            [self.buttons addObject:button];
            if (i == 1) {
                CGFloat h = 20;//12:8//w:h
                
                [button.titleLabel sizeToFit];
                
                self.shipImageView = [[UIImageView alloc]init];
                self.shipImageView.image = [UIImage imageNamed:@"waveShip"];
                self.shipImageView.height = h;
                self.shipImageView.width = 50;
                self.shipImageView.bottom = CGRectGetMaxY(self.waveView.frame);
                self.shipImageView.centerX = button.centerX;
                [self addSubview:self.shipImageView];//waveView
            }
            
        }
    }
    return self;
}

//topView的button点击事件
-(void)clickTitle:(UIButton *)button{
    self.block(button.tag);
    
    //点击按钮，使ScrollView滑动到相应位置(展示相应的子视图控制器)
    [self scrolling:button.tag];
}

-(void)scrolling:(NSInteger)index{
    
    UIButton *button = self.buttons[index];
    if (button.tag==0) {
        button.selected = YES;
        UIButton *button2 = self.buttons[index+1];
        button2.selected = NO;
    }else{
        UIButton *button2 = self.buttons[index-1];
        button2.selected = NO;
        button.selected = YES;
    }

    [UIView animateWithDuration:0.2 animations:^{
        self.shipImageView.centerX = button.centerX;
    } completion:^(BOOL finished) {
//        NSLog(@"切换到->%@",button.titleLabel.text);
        
    }];
}

/*
 3个button时-->
 
     switch (button.tag) {
     case 0:
     {
     button.selected = YES;
     UIButton *button2 = self.buttons[index+1];
     button2.selected = NO;
     UIButton *button3 = self.buttons[index+2];
     button3.selected = NO;
     }
     break;
     case 1:
     {
     UIButton *button2 = self.buttons[index-1];
     button2.selected = NO;
     button.selected = YES;
     UIButton *button3 = self.buttons[index+1];
     button3.selected = NO;
     }
     break;
     case 2:
     {
     UIButton *button2 = self.buttons[index-2];
     button2.selected = NO;
     UIButton *button3 = self.buttons[index-1];
     button3.selected = NO;
     button.selected = YES;
     }
     break;
     default:
     break;
     }
 */



@end
