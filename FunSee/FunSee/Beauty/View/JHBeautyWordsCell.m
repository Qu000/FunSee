//
//  JHBeautyWordsCell.m
//  FunSee
//
//  Created by qujiahong on 2018/5/20.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHBeautyWordsCell.h"

@interface JHBeautyWordsCell()

/** date*/
@property (nonatomic, strong) UILabel * dateLab;

/** titleType*/
@property (nonatomic, strong) UILabel * titleTypeLab;

/** excerpt*/
@property (nonatomic, strong) UILabel * excerptLab;

/** title*/
@property (nonatomic, strong) UILabel * titleLab;

/** thumbImage*/
@property (nonatomic, strong) UIImageView * thumbImage;

@end
@implementation JHBeautyWordsCell

- (UILabel *)dateLab {
    
    if (!_dateLab) {
        _dateLab = [[UILabel alloc]init];
        _dateLab.textColor = JHRGB(140, 140, 140);
        [_dateLab setFont:JHNewsCellFont];
        [self addSubview:_dateLab];
    }
    return _dateLab;
}

- (UILabel *)titleTypeLab {
    
    if (!_titleTypeLab) {
        _titleTypeLab = [[UILabel alloc]init];
        _titleTypeLab.textColor = JHRGB(251, 154, 167);
        [_titleTypeLab setFont:JHNewsCellFont];
        [self addSubview:_titleTypeLab];
    }
    return _titleTypeLab;
}

- (UILabel *)excerptLab {
    
    if (!_excerptLab) {
        _excerptLab = [[UILabel alloc]init];
        _excerptLab.textColor = JHRGB(140, 140, 140);
        [_excerptLab setFont:JHNewsCellFont];
        _excerptLab.textAlignment = NSTextAlignmentLeft;
        _excerptLab.numberOfLines = 0;
        [self addSubview:_excerptLab];
    }
    return _excerptLab;;
}
- (UILabel *)titleLab {
    
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = JHRGB(40, 40, 40);
        [_titleLab setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:_titleLab];
    }
    return _titleLab;
}
- (UIImageView *)thumbImage {
    
    if (!_thumbImage) {
        _thumbImage = [[UIImageView alloc]init];
        [self addSubview:_thumbImage];
    }
    return _thumbImage;
}

- (void)setModel:(BeautyWordFrameModel *)model{
    _model = model;
     model.model.categoriesModel = [RemindsModel mj_objectWithKeyValues:model.model.categories.firstObject];

    NSDictionary *fullDict = model.model.thumbnailImages[@"full"];
    
    self.thumbImage.frame = model.thumbF;
    [self.thumbImage downloadImage:fullDict[@"url"] placeholder:@"Placeholder_2"];
    
    self.titleLab.frame = model.titleF;
    self.titleLab.text = model.model.title;
    
    self.excerptLab.frame = model.excerptF;
    self.excerptLab.text = [self replaceHTMLStrToNSString:model.model.excerpt];
    
    self.dateLab.frame = model.dateF;
    self.dateLab.text = model.model.date;
    
    self.titleTypeLab.frame = model.titleTypeF;
    self.titleTypeLab.text = model.model.categoriesModel.title;
    
    
}

///替换后台返回字符串中的标签
- (NSString *)replaceHTMLStrToNSString:(NSString *)HTMLStr{
    
    NSString * htmlStr = [HTMLStr stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    NSString * myStr = [htmlStr stringByReplacingOccurrencesOfString:@"<br />" withString:@" "];
    NSString * myStr2 = [myStr stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    
    return myStr2;
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
