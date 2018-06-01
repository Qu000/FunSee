//
//  JHTabBarItem.h
//  customTabBar
//
//  Created by qujiahong on 2018/5/13.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHTabBarItem : UIView

@property (nonatomic, copy) NSString *title;

/// 当前的 itemImage
@property (nonatomic, strong) UIImage *image;

/// 当前选中的的 itemImage
@property (nonatomic, strong) UIImage *selectImage;

/// 是否被选中
@property (nonatomic, assign) BOOL isSelect;

///
@property (nonatomic, strong) UIImageView *icomImgView;

/// 文字信息
@property (nonatomic, strong) UILabel *titleLab;

@end
