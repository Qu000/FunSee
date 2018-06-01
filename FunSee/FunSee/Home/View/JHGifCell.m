//
//  JHGifCell.m
//  FunSee
//
//  Created by qujiahong on 2018/5/18.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHGifCell.h"

#import "JHCellToolBar.h"

@interface JHGifCell()

/** title*/
@property (nonatomic, strong) UILabel * titleLab;

/** time*/
@property (nonatomic, strong) UILabel * timeLab;

/** 来源于*/
@property (nonatomic, strong) UILabel * unameLab;

/** gifImage*/
@property (nonatomic, strong) UIImageView * picImageView;

/** toolBar*/
@property (nonatomic, strong) JHCellToolBar * toolBar;
@end
@implementation JHGifCell

#pragma mark --- 懒加载
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = JHRGB(80, 80, 80);
        [_titleLab setFont:JHNewsCellFont];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLab];
    }
    return _titleLab;
}

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc]init];
        _timeLab.textColor = JHRGB(80, 80, 80);
        [_timeLab setFont:JHNewsCellFont];
        [self addSubview:_timeLab];
    }
    return _timeLab;
}
- (UILabel *)unameLab{
    if (!_unameLab) {
        _unameLab = [[UILabel alloc]init];
        _unameLab.textColor = JHRGB(80, 80, 80);
        [_unameLab setFont:JHNewsCellFont];
        [self addSubview:_unameLab];
    }
    return _unameLab;
}
- (UIImageView *)picImageView{
    if (!_picImageView) {
        _picImageView = [[UIImageView alloc]init];
        _picImageView.contentMode = UIViewContentModeScaleAspectFill;
        _picImageView.userInteractionEnabled = NO;
        [self addSubview:_picImageView];
    }
    return _picImageView;
}
- (JHCellToolBar *)toolBar{
    if (!_toolBar) {
        _toolBar = [JHCellToolBar creatToolBar];
        [self addSubview:_toolBar];
    }
    return _toolBar;
}


- (void)setModelF:(PicFrameModel *)modelF{
    _modelF = modelF;
    
    self.timeLab.frame = modelF.timeF;
    self.timeLab.text = modelF.model.timeStr;
    
    self.unameLab.frame = modelF.unameF;
    self.unameLab.text = modelF.model.uname;
    
    self.titleLab.frame = modelF.titleF;
    self.titleLab.text = modelF.model.title;
    
//    NSLog(@"modelF.model.pic=%@",modelF.model.pic);
    self.picImageView.frame = modelF.picF;
    [self.picImageView downloadImage:modelF.model.pic placeholder:@"Placeholder_2"];
    
    self.toolBar.frame = modelF.toolF;
    self.toolBar.backgroundColor = JHRGB(249, 227, 228);
}

///注意：没有编辑操作的时候，可以用此方法进行cell间隔设置
- (void)setFrame:(CGRect)frame{
    frame.origin.x = 5;//这里间距为10，可以根据自己的情况调整
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 2 * frame.origin.x;
    [super setFrame:frame];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.0;
}




@end
