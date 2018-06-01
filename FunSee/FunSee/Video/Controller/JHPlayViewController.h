//
//  JHPlayViewController.h
//  FunSee
//
//  Created by qujiahong on 2018/5/22.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VideoFrameModel.h"

@interface JHPlayViewController : UIViewController

/** frameModel*/
@property (nonatomic, strong) VideoFrameModel * model;

/** url*/
@property (nonatomic, strong) NSString * url;

/** index判断是否为web*/
@property (nonatomic, assign) NSInteger index;

@end
