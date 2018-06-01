//
//  JHTabBarController.m
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/2.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHTabBarController.h"
#import "JHNavigationController.h"

#import "JHHomeViewController.h"
#import "JHVideoViewController.h"
#import "JHBeautyViewController.h"
#import "JHProfileViewController.h"


static JHTabBarController *tabbarCtl;

@interface JHTabBarController ()

@end

@implementation JHTabBarController

+(JHTabBarController *)jhTabbarController{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabbarCtl = [[JHTabBarController alloc] init];
    });
    return tabbarCtl;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewControllers];
}

#pragma mark --- 自定义TabBar
- (void)addChildViewControllers{
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@"JHHomeViewController",@"JHVideoViewController",@"JHBeautyViewController",@"JHProfileViewController"]];
    NSArray *imgArray = @[@"home2",@"see2",@"beauty2",@"video2"];
    NSArray *selectImageArray = @[@"home1",@"see1_h",@"beauty1",@"video1"];
    NSArray *titles = @[@"首页",@"Fun看",@"艺美",@"乐我"];
    
    for(int i =0;i<array.count;i++)
    {
        UIViewController *vc = [[NSClassFromString(array[i]) alloc] init];
        //先给外面传进来的小控制器，包装一个导航控制器
        JHNavigationController * nav = [[JHNavigationController alloc]initWithRootViewController:vc];

        [array replaceObjectAtIndex:i withObject:nav];
    }
    self.viewControllers = array;

    // 将自定义的覆盖到原来的tabBar上面
    self.jhTabBar = [[JHTabBar alloc] initWithTitles:titles itemImages:imgArray selectImages:selectImageArray];
    self.jhTabBar.backgroundColor = [UIColor whiteColor];
    /// 设置delegate
    self.jhTabBar.delegate = self;
    self.jhTabBar.tintColor = JHRGB(254, 142, 153);//JHRGB(234, 0, 115)
    [self.tabBar addSubview:self.jhTabBar];
    
}


- (void)selectIndex:(NSInteger)index{
    
    /// 通知 切换视图控制器
    [self setSelectedIndex:index];
    
}
- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    
    [super setSelectedIndex:selectedIndex];
    
    self.jhTabBar.selectIndex = selectedIndex;
    
    
}


#pragma mark---原生TabBar
- (void)setupUI{
    
    JHHomeViewController *homeVc = [[JHHomeViewController alloc]init];
    [self addChildVc:homeVc withTabTitle:@"首页" title:@"段子" image:@"h_h" selectedImage:@"selectedTabBar"];
    
    JHVideoViewController *seeVc = [[JHVideoViewController alloc]init];
    [self addChildVc:seeVc withTabTitle:@"Fun看" title:@"精选" image:@"u_h" selectedImage:@"selectedTabBar"];
    
    JHProfileViewController *profileVc = [[JHProfileViewController alloc]init];
    [self addChildVc:profileVc withTabTitle:@"乐我" title:@"Profile" image:@"n_h" selectedImage:@"selectedTabBar"];
}
- (void)addChildVc:(UIViewController *)childVc withTabTitle:(NSString *)tabTitle title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    
    childVc.navigationItem.title = title;
    childVc.tabBarItem.title = tabTitle;
//    childVc.title
    childVc.tabBarItem.image = [UIImage imageNamed:image];

    //声明：这张图片按照原来的样子显示出来，不要自动渲染成其他颜色（比如蓝色）
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置文字样式
    NSMutableDictionary *textAtts = [NSMutableDictionary dictionary];
    textAtts[NSForegroundColorAttributeName] = [UIColor whiteColor];//JHRGB(123, 123, 123)
    
    NSMutableDictionary *selectTextAtts = [NSMutableDictionary dictionary];
    selectTextAtts[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    
    
    [childVc.tabBarItem setTitleTextAttributes:textAtts forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAtts forState:UIControlStateSelected];
    
    //先给外面传进来的小控制器，包装一个导航控制器
    JHNavigationController * nav = [[JHNavigationController alloc]initWithRootViewController:childVc];
    
    //添加子控制器
    [self addChildViewController:nav];
  
    
}

@end
