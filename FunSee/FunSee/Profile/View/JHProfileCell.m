//
//  JHProfileCell.m
//  FunSee
//
//  Created by qujiahong on 2018/5/23.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHProfileCell.h"

@interface JHProfileCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation JHProfileCell


- (void)setDataWithTitles:(NSString *)title images:(NSString *)image{
    
    self.titleLab.text = title;
    
    self.imageView.image = [UIImage imageNamed:image];
    
}


@end
