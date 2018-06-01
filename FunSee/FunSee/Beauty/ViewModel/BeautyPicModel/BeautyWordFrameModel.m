//
//  BeautyWordFrameModel.m
//  FunSee
//
//  Created by qujiahong on 2018/5/20.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "BeautyWordFrameModel.h"

@implementation BeautyWordFrameModel

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

- (void)setModel:(BeautyWordModel *)model{
    _model = model;
    
    CGFloat cellW = SCREEN_WIDTH;
    
    CGFloat thumbX = JHNewsCellBorderW;
    CGFloat thumbY = JHNewsCellBorderW;
    CGFloat thumbH = cellW*9/16;
    self.thumbF = CGRectMake(0, thumbY, cellW, thumbH);
    
    
    CGFloat titleY = CGRectGetMaxY(self.thumbF)+15;
    self.titleF = CGRectMake(thumbX, titleY, cellW-2*thumbX, 24);
    
    CGFloat excerptY = CGRectGetMaxY(self.titleF)+15;
    CGFloat maxW = cellW - 2*thumbX;
    CGSize excerptSize = [self sizeWithText:[self replaceHTMLStrToNSString:model.excerpt] font:JHNewsCellFont maxW:maxW];
    self.excerptF = (CGRect){{thumbX,excerptY},excerptSize};
    
    CGFloat dateY = CGRectGetMaxY(self.excerptF)+15;
    self.dateF = CGRectMake(thumbX, dateY, 160, 20);
    
    CGFloat titleTypeW = 60;
    CGFloat titleTypeX = cellW - JHNewsCellBorderW - titleTypeW;
    self.titleTypeF = CGRectMake(titleTypeX, dateY, titleTypeW, 20);
    
    self.cellH = CGRectGetMaxY(self.dateF)+15;
    
}


///替换后台返回字符串中的标签
- (NSString *)replaceHTMLStrToNSString:(NSString *)HTMLStr{
    
    NSString * htmlStr = [HTMLStr stringByReplacingOccurrencesOfString:@"<p>" withString:@" \n "];
    NSString * myStr = [htmlStr stringByReplacingOccurrencesOfString:@"<br />" withString:@" \n "];
    NSString * myStr2 = [myStr stringByReplacingOccurrencesOfString:@"<br />" withString:@"</p>"];
    return myStr2;
}

@end
