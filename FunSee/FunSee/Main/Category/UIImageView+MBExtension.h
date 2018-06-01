//
//  UIImageView+MBExtension.h
//  MBLive_iOS
//
//  Created by qujiahong on 2018/3/7.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (MBExtension)

// 播放GIF
- (void)playGifAnim:(NSArray *)images;
// 停止动画
- (void)stopGifAnim;

@end
