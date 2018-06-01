//
//  JHHomeTopView.h
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/3.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TopBlock)(NSInteger tag);

@interface JHHomeTopView : UIView

-(instancetype)initWithFrame:(CGRect)frame titleNames:(NSArray *)titles;

/** block*/
@property (nonatomic, copy) TopBlock block;

- (void)scrolling:(NSInteger)index;

@end
