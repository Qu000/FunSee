//
//  JHTabBarController.h
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/2.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTabBar.h"

/*
typedef NS_ENUM(NSInteger, TabBarType) {
    TabBarTypeDefault,
    TabBarTypeBPath
};
*/

@interface JHTabBarController : UITabBarController<JHTabBarDelegate>

/** tabBar*/
@property (nonatomic, strong) JHTabBar *jhTabBar;
/** 创建 */
+ (JHTabBarController *)jhTabbarController;

@end
