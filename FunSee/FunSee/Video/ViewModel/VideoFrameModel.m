//
//  VideoFrameModel.m
//  FunSee
//
//  Created by qujiahong on 2018/5/19.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "VideoFrameModel.h"

#define ImageViewHeight SCREEN_WIDTH*3/4

@implementation VideoFrameModel

- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}

- (void)setModel:(VideoModel *)model{
    _model = model;
    
    CGFloat cellW = SCREEN_WIDTH;
    
    CGFloat cTimeX = JHNewsCellBorderW;
    CGFloat cTimeY = JHNewsCellBorderW;
    self.cTimeF = CGRectMake(cTimeX, cTimeY, cellW-2*cTimeX, 20);
    
    CGFloat titleY = CGRectGetMaxY(self.cTimeF)+10;
    CGFloat maxW = cellW - 2*cTimeX;
    CGSize titleSize = [self sizeWithText:model.title font:[UIFont systemFontOfSize:16] maxW:maxW];
    self.titleF = (CGRect){{cTimeX,titleY},titleSize};
    
    
    CGFloat picY = CGRectGetMaxY(self.titleF)+15;
    self.picF = CGRectMake(0, picY, SCREEN_WIDTH, ImageViewHeight);
    
    CGFloat playBtnX = self.picF.size.width/2-30;//设定按钮为60
    CGFloat playBtnY = self.picF.size.height/2-30;
    self.playBtnF = CGRectMake(playBtnX, playBtnY, 60, 60);
    
    CGFloat toolBarX = JHNewsCellBorderW;
    CGFloat toolBarY = CGRectGetMaxY(self.picF)+15;
    CGFloat toolBarW = cellW - 3*JHNewsCellBorderW;
    CGFloat toolBarH = 40;
    self.toolBarF = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
    
    self.cellH = CGRectGetMaxY(self.toolBarF)+JHNewsCellBorderW*2;
}
@end
