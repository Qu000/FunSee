//
//  JHBeautyVideoCell.m
//  FunSee
//
//  Created by qujiahong on 2018/5/26.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHBeautyVideoCell.h"

#define CellHeight   420
#define ImageViewHeight SCREEN_WIDTH*3/4

@interface JHBeautyVideoCell()

///封面图片
@property (nonatomic, weak) UIImageView *iconImg;

///bottom
@property (nonatomic, weak) UIView * bottomView;

///标题
@property (nonatomic, weak) UILabel * titleLab;

///描述
@property (nonatomic, weak) UILabel * desLab;

///tag
@property (nonatomic, weak) UILabel * storyTagLab;

///time
@property (nonatomic, weak) UILabel * itemTime;

/** 播放按钮*/
@property (nonatomic,strong) UIButton *button;

@end
@implementation JHBeautyVideoCell


- (UIButton *) button{
    if (_button == nil){
        _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_button setBackgroundImage:[UIImage imageNamed:@"Play_1"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
- (void)playAction:(UIButton *)button{
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
    CGFloat offset       = - offsetDig * (ImageViewHeight - CellHeight) / 2;
    //让pictureViewY轴方向位移offset
    CGAffineTransform transY = CGAffineTransformMakeTranslation(0,offset);
    _iconImg.transform   = transY;
    return offset;
}


+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString * ID = @"JHBeautyVideoCell";
    JHBeautyVideoCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[JHBeautyVideoCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}


/**
 * cell的初始化方法，一个cell只会调用一次
 * 一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //取消cell选中变色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupTopView];
        [self setupBottomView];
    }
    return self;
}

#pragma mark --- cell的上半部分
- (void)setupTopView{
    UIImageView * iconImg = [[UIImageView alloc]init];
    iconImg.userInteractionEnabled = YES;
    [self.contentView addSubview:iconImg];
    [iconImg addSubview:self.button];
    self.iconImg = iconImg;
}
#pragma mark --- cell的下半部分
- (void)setupBottomView{
    UIView *bottomView = [[UIView alloc]init];
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
    
    UILabel * titleLab = [[UILabel alloc]init];
    titleLab.numberOfLines = 0;
    [titleLab setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];//加粗
    titleLab.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:titleLab];
    self.titleLab = titleLab;
    
    UILabel * desLab = [[UILabel alloc]init];
    desLab.textAlignment = NSTextAlignmentCenter;
    desLab.numberOfLines = 0;
    [desLab setFont:[UIFont systemFontOfSize:14]];
    [desLab setTextColor:JHRGB(160,160,160)];
    [self.bottomView addSubview:desLab];
    self.desLab = desLab;
    
    UILabel * storyTagLab = [[UILabel alloc]init];
    [storyTagLab setTextColor:[UIColor redColor]];
    [storyTagLab setFont:[UIFont fontWithName:@"Helvetica-Oblique" size:10]];//加粗并且倾斜
    storyTagLab.textAlignment = NSTextAlignmentRight;
    [self.bottomView addSubview:storyTagLab];
    self.storyTagLab = storyTagLab;
    
    UILabel * itemTime = [[UILabel alloc]init];
    [itemTime setFont:[UIFont systemFontOfSize:10]];
    [itemTime setTextColor:JHRGB(160,160,160)];
    itemTime.textAlignment = NSTextAlignmentRight;
    [self.bottomView addSubview:itemTime];
    self.itemTime = itemTime;
}
#pragma mark --- cell子控件的frame
-(void)layoutSubviews{
    
    CGFloat iconImgH = SCREEN_WIDTH*3/4;
    self.iconImg.frame = CGRectMake(0, 0, SCREEN_WIDTH, iconImgH);
    
    _button.centerX = self.iconImg.width/2;
    _button.centerY = self.iconImg.height/2;
    
    
    CGFloat bottomViewY = CGRectGetMaxY(self.iconImg.frame);
    self.bottomView.frame = CGRectMake(0, bottomViewY, self.width, 220);
    
    CGFloat titleW = self.bottomView.width - 40;
    CGSize titleSize = [self sizeWithText:self.titleLab.text font:[UIFont fontWithName:@"Helvetica-Bold" size:24] maxW:titleW];
    self.titleLab.frame =  CGRectMake(20, 10, titleW, titleSize.height);
    
    CGFloat desLabY = CGRectGetMaxY(self.titleLab.frame);
    CGSize desSize = [self sizeWithText:self.desLab.text font:[UIFont systemFontOfSize:14] maxW:titleW];
    self.desLab.frame = CGRectMake(20, desLabY, titleW, desSize.height);
    
    CGFloat itemTimeW = 70;
    CGFloat itemTimeX = 10;
    CGFloat itemTimeY = CGRectGetMaxY(self.desLab.frame)+5;
    self.itemTime.frame = CGRectMake(itemTimeX, itemTimeY, itemTimeW, 20);
    
    CGSize storyTagSize = [self sizeWithText:self.storyTagLab.text font:[UIFont fontWithName:@"Helvetica-Oblique" size:10]];
    CGFloat storyTagX = self.bottomView.width - storyTagSize.width-10;
    CGFloat storyTagY = itemTimeY;
    self.storyTagLab.frame = CGRectMake(storyTagX, storyTagY, storyTagSize.width, 20);
    
}

-(void)setModel:(BeautyVideoModel *)model{
    _model = model;
    
    [self.iconImg downloadImage:model.itemCoverUrl placeholder:@"Placeholder_2"];
    self.titleLab.text = model.itemTitle;
    self.desLab.text = [self changeEncodingStringToUrlString:model.descriptionField];

    self.storyTagLab.text = [NSString stringWithFormat:@">%@",model.storyTag];
    
    NSString * itemTimeStr = [model.storyCreateTime substringToIndex:10];//截取掉下标9之前的字符串
    self.itemTime.text = itemTimeStr;
}
#pragma mark --- URL解码
- (NSString *)changeEncodingStringToUrlString:(NSString *)encodingString{
    NSString * urlString = [encodingString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return urlString;
}

#pragma mark --- 自适应layout
///计算height
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

///调用方法
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}

@end
