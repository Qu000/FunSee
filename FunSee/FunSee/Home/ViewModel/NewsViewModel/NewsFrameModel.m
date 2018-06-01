//
//  NewsFrameModel.m
//  FunSee
//
//  Created by qujiahong on 2018/5/19.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "NewsFrameModel.h"

@implementation NewsFrameModel

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



-(void)setModel:(NewsModel *)model{
    _model = model;
    
    CGFloat cellW = SCREEN_WIDTH;
    
    CGFloat dateX = JHNewsCellBorderW;
    CGFloat dateY = JHNewsCellBorderW;
    CGSize dateSize = [self sizeWithText:model.date font:JHNewsCellFont];
    self.dateF = (CGRect){{dateX,dateY},dateSize};
    
    CGFloat contentX = dateX;
    CGFloat contentY = CGRectGetMaxY(self.dateF)+10;
    CGFloat maxW = cellW - 2*contentX;
    
    CGSize contentSize = [self sizeWithText:[self replaceHTMLStrToNSString:model.content] font:JHNewsCellFont maxW:maxW];
    self.contentF = (CGRect){{contentX,contentY},contentSize};
    
    CGFloat toolBarX = JHNewsCellBorderW;
    CGFloat toolBarY = CGRectGetMaxY(self.contentF)+10;
    CGFloat toolBarW = cellW - 3*JHNewsCellBorderW;
    CGFloat toolBarH = 40;
    self.toolF = CGRectMake(toolBarX, toolBarY, toolBarW, toolBarH);
    
    self.bottomSpF = CGRectMake(0, CGRectGetMaxY(self.toolF)+10, cellW, 8);
    
    self.cellH = CGRectGetMaxY(self.bottomSpF);
    
}
///替换后台返回字符串中的标签
- (NSString *)replaceHTMLStrToNSString:(NSString *)HTMLStr{
    
    NSString * htmlStr = [HTMLStr stringByReplacingOccurrencesOfString:@"<p>" withString:@" \n "];
    NSString * myStr = [htmlStr stringByReplacingOccurrencesOfString:@"<br />" withString:@" \n "];
    NSString * myStr2 = [myStr stringByReplacingOccurrencesOfString:@"<br />" withString:@"</p>"];
    return myStr2;
}

///过滤后台返回字符串中的标签
- (NSString *)changeHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    return html;
}
@end
