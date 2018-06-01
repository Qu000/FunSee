//
//  NewsFrameModel.h
//  FunSee
//
//  Created by qujiahong on 2018/5/19.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsModel.h"

@interface NewsFrameModel : NSObject

/** NewsModel*/
@property (nonatomic, strong) NewsModel * model;

///段子内容
@property (nonatomic, assign) CGRect contentF;

///段子发布时间
@property (nonatomic, assign) CGRect dateF;

///底部ToolBar
@property (nonatomic, assign) CGRect toolF;

/** 底部间隔*/
@property (nonatomic, assign) CGRect bottomSpF;

///cellH
@property (nonatomic, assign) CGFloat cellH;
@end
