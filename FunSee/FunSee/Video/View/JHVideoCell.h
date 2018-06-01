//
//  JHVideoCell.h
//  FunSee
//
//  Created by qujiahong on 2018/5/19.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoFrameModel.h"

@class JHVideoCell;
@protocol JHVideoCellDelegate <NSObject>
///代理方法
- (void)tableViewCellPlayVideoWithCell:(JHVideoCell *)cell;
@end

@interface JHVideoCell : UITableViewCell

/** modelF数据*/
@property (nonatomic, strong) VideoFrameModel * modelF;

/** videoImage*/
@property (nonatomic, strong) UIImageView * picImageView;

/** playBtn*/
@property (nonatomic, strong) UIButton * playBtn;

/** 播放按钮block */
@property (nonatomic, copy) void(^playBlock)(UIButton *);

/** delegate*/
@property (nonatomic, weak) id<JHVideoCellDelegate> delegate;

- (CGFloat)cellOffset;

@end
