//
//  BeautyWordFrameModel.h
//  FunSee
//
//  Created by qujiahong on 2018/5/20.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeautyWordModel.h"

@interface BeautyWordFrameModel : NSObject

/** 美文Model*/
@property (nonatomic, strong) BeautyWordModel * model;


///封面图片
@property (nonatomic, assign) CGRect thumbF;

///title 字体较大
@property (nonatomic, assign) CGRect titleF;

///描述
@property (nonatomic, assign) CGRect excerptF;

///发布时间 --- 我要展示的
@property (nonatomic, assign) CGRect dateF;

///文章 type ---美文---散文
@property (nonatomic, assign) CGRect titleTypeF;

///cellH
@property (nonatomic, assign) CGFloat cellH;

@end
