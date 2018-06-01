//
//  JHNewsCell.m
//  FunSee
//
//  Created by qujiahong on 2018/5/17.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHNewsCell.h"
#import "JHCellToolBar.h"

@interface JHNewsCell ()

/** 段子content*/
@property (nonatomic, strong) UILabel * contentLab;

/** 段子发布日期*/
@property (nonatomic, strong) UILabel * dateLab;

/** toolBar */
@property(nonatomic, strong) JHCellToolBar * toolBar;

/** 间隔view*/
@property (nonatomic, strong) UIView * bottomSpView;
@end
@implementation JHNewsCell

#pragma mark --- 懒加载

- (UILabel *)contentLab{
    if (!_contentLab) {
        self.contentLab = [[UILabel alloc]init];
        self.contentLab.textAlignment = NSTextAlignmentLeft;
        self.contentLab.numberOfLines = 0;
        self.contentLab.textColor = JHRGB(80, 80, 80);
        //不显示省略号
        self.contentLab.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentLab setFont:JHNewsCellFont];
        
        [self addSubview:self.contentLab];
    }
    return _contentLab;
}

- (UILabel *)dateLab{
    if (!_dateLab) {
        self.dateLab = [[UILabel alloc]init];
        self.dateLab.textAlignment = NSTextAlignmentLeft;
        self.dateLab.textColor = JHRGB(80, 80, 80);
        self.dateLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.dateLab];
    }
    return _dateLab;
}

- (JHCellToolBar *)toolBar{
    if (!_toolBar) {
        _toolBar = [JHCellToolBar creatToolBar];
        [self addSubview:_toolBar];
    }
    return _toolBar;
}

- (UIView *)bottomSpView {
    
    if (!_bottomSpView) {
        _bottomSpView = [[UIView alloc]init];
        _bottomSpView.backgroundColor = JHRGB(230, 230, 230);
        [self addSubview:_bottomSpView];
    }
    return _bottomSpView;
}
#pragma mark --- 模型赋值
-(void)setModelF:(NewsFrameModel *)modelF{
    _modelF = modelF;
    
    self.dateLab.frame = modelF.dateF;
    self.dateLab.text = modelF.model.date;
    
    self.contentLab.frame = modelF.contentF;
    self.contentLab.text = [self replaceHTMLStrToNSString:modelF.model.content];
    
    self.toolBar.frame = modelF.toolF;
    self.toolBar.backgroundColor = JHRGB(249, 227, 228);
    
//    self.bottomSpView.frame = modelF.bottomSpF;

}

///替换后台返回字符串中的标签
- (NSString *)replaceHTMLStrToNSString:(NSString *)HTMLStr{
    
    NSString * htmlStr = [HTMLStr stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    NSString * myStr = [htmlStr stringByReplacingOccurrencesOfString:@"<br />" withString:@" \n "];
    NSString * myStr2 = [myStr stringByReplacingOccurrencesOfString:@"</p>" withString:@""];

    return myStr2;
}
///直接呈现<p>中的内容
- (NSAttributedString *)showHTML:(NSString *)html{
    NSString *htmlStype = html;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlStype dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attributedString;
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
