//
//  PicFrameModel.m
//  FunSee
//
//  Created by qujiahong on 2018/5/19.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "PicFrameModel.h"

@implementation PicFrameModel


- (void)setModel:(PicModel *)model{
    _model = model;
    
    CGFloat cellW = SCREEN_WIDTH;
    
    CGFloat timeX = JHNewsCellBorderW;
    CGFloat timeY = JHNewsCellBorderW;
    self.timeF = CGRectMake(timeX, timeY, cellW-2*timeX, 20);
    
    CGFloat unameY = CGRectGetMaxY(self.timeF);
    self.unameF = CGRectMake(timeX, unameY, cellW-2*timeX, 20);
    
    CGFloat titleY = CGRectGetMaxY(self.unameF)+15;
    self.titleF = CGRectMake(timeX, titleY, cellW-2*timeX, 20);
    
    CGFloat picW = [model.picW floatValue];
    CGFloat picH = [model.picH floatValue];
    CGFloat picY = CGRectGetMaxY(self.titleF)+15;
    if (picW<=cellW) {
        
        self.picF = CGRectMake(timeX, picY, picW, picH);
        
    }else{
        picW = cellW;
        self.picF = CGRectMake(timeX, picY, picW, picH);
        
    }
    
    CGFloat toolBarX = JHNewsCellBorderW;
    CGFloat toolBarY = CGRectGetMaxY(self.picF)+10;
    CGFloat toolBarH = 40;
    self.toolF = CGRectMake(toolBarX, toolBarY, cellW-3*timeX, toolBarH);
    
    self.cellH = CGRectGetMaxY(self.toolF)+JHNewsCellBorderW*2;
    
}

@end
