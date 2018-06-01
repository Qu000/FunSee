//
//  JHVideoCell.m
//  FunSee
//
//  Created by qujiahong on 2018/5/19.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHVideoCell.h"

#import "JHCellToolBar.h"

@interface JHVideoCell()


/** time*/
@property (nonatomic, strong) UILabel * timeLab;

/** title*/
@property (nonatomic, strong) UILabel * titleLab;

/** toolBar*/
@property (nonatomic, strong) JHCellToolBar * toolBar;

@end
@implementation JHVideoCell


#pragma mark --- 懒加载
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = JHRGB(80, 80, 80);
        [_titleLab setFont:JHNewsCellFont];
        _titleLab.numberOfLines = 0;
        _titleLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLab];
    }
    return _titleLab;
}

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc]init];
        _timeLab.textColor = JHRGB(80, 80, 80);
        [_timeLab setFont:JHNewsCellFont];
        [self.contentView addSubview:_timeLab];
    }
    return _timeLab;
}
- (UIImageView *)picImageView{
    if (!_picImageView) {
        _picImageView = [[UIImageView alloc]init];
        _picImageView.contentMode = UIViewContentModeScaleToFill;
        _picImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_picImageView];
    }
    return _picImageView;
}


- (JHCellToolBar *)toolBar{
    if (!_toolBar) {
        _toolBar = [JHCellToolBar creatToolBar];
        [self.contentView addSubview:_toolBar];
    }
    return _toolBar;
}

- (void)setModelF:(VideoFrameModel *)modelF{
    _modelF = modelF;
    
    self.timeLab.frame = modelF.cTimeF;
    self.timeLab.text = modelF.model.cTime;
    
    self.titleLab.frame = modelF.titleF;
    self.titleLab.text = modelF.model.title;
    
    self.picImageView.frame = modelF.picF;
    [self.picImageView downloadImage:modelF.model.pic placeholder:@"Placeholder_2"];
    
    
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playBtn setImage:[UIImage imageNamed:@"Play_1"] forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    _playBtn.frame = modelF.playBtnF;
    [self.picImageView addSubview:_playBtn];
    
    self.toolBar.frame = modelF.toolBarF;
    self.toolBar.backgroundColor = JHRGB(249, 227, 228);
}


- (void)playVideo:(UIButton *)sender {
    NSLog(@"点击了播放按钮");
//    if (self.playBlock) {
//        self.playBlock(sender);
//    }
    if (_delegate && [_delegate respondsToSelector:@selector(tableViewCellPlayVideoWithCell:)]){
        [_delegate tableViewCellPlayVideoWithCell:self];
    }
}

- (CGFloat)cellOffset{
    /*
     - (CGRect)convertRect:(CGRect)rect toView:(nullable UIView *)view;
     将rect由rect所在视图转换到目标视图view中，返回在目标视图view中的rect
     这里用来获取self在window上的位置
     */
    CGRect toWindow      = [self convertRect:self.bounds toView:self.window];
    //获取父视图的中心
    CGPoint windowCenter = self.superview.center;
    //cell在y轴上的位移
    CGFloat cellOffsetY  = CGRectGetMidY(toWindow) - windowCenter.y;
    //位移比例
    CGFloat offsetDig    = 2 * cellOffsetY / self.superview.frame.size.height ;
    //要补偿的位移,self.superview.frame.origin.y是tableView的Y值，这里加上是为了让图片从最上面开始显示
    CGFloat offset       = - offsetDig * (SCREEN_WIDTH*3/4 - SCREEN_WIDTH) / 2;
    //让pictureViewY轴方向位移offset
    CGAffineTransform transY = CGAffineTransformMakeTranslation(0,offset);
    _picImageView.transform   = transY;
    return offset;
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
