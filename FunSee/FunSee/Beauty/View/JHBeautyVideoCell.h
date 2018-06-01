//
//  JHBeautyVideoCell.h
//  FunSee
//
//  Created by qujiahong on 2018/5/26.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BeautyVideoModel.h"
@class JHBeautyVideoCell;
@protocol JHBeautyVideoCellDelegate <NSObject>
///代理方法
- (void)tableViewCellPlayVideoWithCell:(JHBeautyVideoCell *)cell;
@end

@interface JHBeautyVideoCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** model*/
@property (nonatomic, strong) BeautyVideoModel * model;

/** delegate*/
@property (nonatomic, weak) id<JHBeautyVideoCellDelegate> delegate;

- (CGFloat)cellOffset;
@end
