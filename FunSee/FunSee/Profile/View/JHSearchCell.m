//
//  JHSearchCell.m
//  FunSee
//
//  Created by qujiahong on 2018/5/24.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHSearchCell.h"

@interface JHSearchCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *desctionLab;

@end

@implementation JHSearchCell


- (void)setModel:(SearchModel *)model{
    _model = model;
    
    [self.headImage downloadImage:model.storyCover placeholder:@"Placeholder_2"];
    
    self.desctionLab.text = model.storyDesc;
    
}



@end
