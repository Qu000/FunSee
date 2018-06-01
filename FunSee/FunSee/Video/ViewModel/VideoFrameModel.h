//
//  VideoFrameModel.h
//  FunSee
//
//  Created by qujiahong on 2018/5/19.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VideoModel.h"

@interface VideoFrameModel : NSObject

/** videoModel*/
@property (nonatomic, strong) VideoModel * model;


///发布时间 --- 我要展示的
@property (nonatomic, assign) CGRect cTimeF;

///封面图片
@property (nonatomic, assign) CGRect picF;

///视频简介 --- 较长篇幅
@property (nonatomic, assign) CGRect titleF;

///获赞数
@property (nonatomic, assign) CGRect zanNumF;

///playBtn
@property (nonatomic, assign) CGRect playBtnF;

///底部ToolBar
@property (nonatomic, assign) CGRect toolBarF;

///cellH
@property (nonatomic, assign) CGFloat cellH;

@end
