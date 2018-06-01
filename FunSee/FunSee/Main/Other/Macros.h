//
//  Macros.h
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/2.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


#define JHRGB(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]

#define JHRGBA(r,g,b,a) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a]

#define JHRandomColor JHRGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

#define JHRandomNumber arc4random_uniform(7000)
//cell的边框宽度
#define JHNewsCellBorderW 10
// cell的字体
#define JHNewsCellFont [UIFont systemFontOfSize:14]

///主题色系--卡粉--Nav、tabBar
#define ThemeColorBar1 JHRGB(254, 225, 227)
#define ThemeColorNavFont1 JHRGB(254, 142, 153)
#define ThemeColorFont1 JHRGB(0, 155, 248)
#define ThemeColorFont2 JHRGB(57, 185, 170)

#define FontColor1 JHRGB(90, 90, 90)

#endif /* Macros_h */
