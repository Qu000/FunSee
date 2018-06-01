//
//  JHTabBar.h
//  customTabBar
//
//  Created by qujiahong on 2018/5/13.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTabBarItem.h"

@protocol JHTabBarDelegate <NSObject>

- (void)selectIndex:(NSInteger)index;

@end


@interface JHTabBar : UIView

/// myTabBar
@property (nonatomic, readonly, strong) NSMutableArray <JHTabBarItem *> *tabBarItems;

/// titles组
@property (nonatomic, copy) NSArray <NSString *> *titles;

/// 默认图标 UIImage 类型 或者 NSString 类型--未选中
@property (nonatomic, strong) NSArray *itemImages;

/// 图标 UIImage 类型 或者 NSString 类型------选中
@property (nonatomic, strong) NSArray *selectItemImages;

/// 默认titles颜色
@property (nonatomic, strong) UIColor *defColor;

/// 选中titles颜色
@property (nonatomic, strong) UIColor *tintColor;

/// 当前选中的下标
@property (nonatomic, assign) NSInteger selectIndex;

/// 选中当前tabBar
@property (nonatomic, strong)JHTabBarItem *tabBarItem;
@property (nonatomic, weak) id <JHTabBarDelegate>delegate;

/// 提供function
- (instancetype)initWithTitles:(NSArray <NSString *>*)titles itemImages:(NSArray *)itemImgs selectImages:(NSArray *)selectImages;;



@end
