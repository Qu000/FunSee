//
//  PicFrameModel.h
//  FunSee
//
//  Created by qujiahong on 2018/5/19.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PicModel.h"

@interface PicFrameModel : NSObject

/** PicModel*/
@property (nonatomic, strong) PicModel * model;


///picture
@property (nonatomic, assign) CGRect picF;

///返回时间-今天 13:14 --我需要显示的
@property (nonatomic, assign) CGRect timeF;

///picture的title
@property (nonatomic, assign) CGRect titleF;

///uname --- 来源
@property (nonatomic, assign) CGRect unameF;

///被赞数
@property (nonatomic, assign) CGRect zanNumF;

///底部ToolBar
@property (nonatomic, assign) CGRect toolF;

///cellH
@property (nonatomic, assign) CGFloat cellH;

@end
