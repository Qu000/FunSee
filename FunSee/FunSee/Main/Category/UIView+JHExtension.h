//
//  UIView+JHExtension.h
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/3.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JHExtension)


//@property (nonatomic, assign) CGFloat x;
//@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@end
