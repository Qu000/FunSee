//
//  JHTabBarItem.m
//  customTabBar
//
//  Created by qujiahong on 2018/5/13.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHTabBarItem.h"

@implementation JHTabBarItem

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTabBarView];
    }
    return self;
}

- (void)createTabBarView{
    _isSelect = NO;
    _icomImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-10, 9, 20, 20)];
    _icomImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:_icomImgView];
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, self.frame.size.width, 14)];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.font = [UIFont systemFontOfSize:9];
    [self addSubview:_titleLab];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLab.text = _title;
}
- (void)setImage:(UIImage *)image{
    _image = image;
    _icomImgView.image = _image;
}
- (void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if(_isSelect)
    {
        _icomImgView.image = _selectImage;
    }else{
        _icomImgView.image = _image;
    }
}

@end
