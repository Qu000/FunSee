//
//  customLayout.h
//  collectionViewDemo
//
//  Created by qujiahong on 2018/4/18.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LayoutType) {
    ///线性
    LayoutTypeLinear,
    ///旋转
    LayoutTypeRotary,
    ///轮滑
    LayoutTypeCarousel,
    LayoutTypeCarousel2,
    ///空间
    LayoutTypeCoverFlow,
    ///水平
    LayoutTypeHorizontal
    
};

@interface customLayout : UICollectionViewLayout

- (instancetype)initWithType:(LayoutType)type;
//@property (readonly) LayoutType layoutType;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) NSInteger visibleCount;
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
@end
