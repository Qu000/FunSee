//
//  JHSearchDetailVc.m
//  FunSee
//
//  Created by qujiahong on 2018/5/24.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHSearchDetailVc.h"

@interface JHSearchDetailVc ()

/** intro*/
@property (nonatomic, strong)NSString *storyIntro;
/** cover图片*/
@property (nonatomic, strong)NSString *storyCover;
/** tag展示*/
@property (nonatomic, strong)NSString *storyTag;
/** title*/
@property (nonatomic, strong)NSString *storyTitle;

/** cover图片容器*/
@property (nonatomic, strong) UIImageView * coverImage;
/** tagLab*/
@property (nonatomic, strong) UILabel * tagLab;
/** titleLab*/
@property (nonatomic, strong) UILabel * titleLab;
/** story_create_time*/
@property (nonatomic, strong) UILabel * timeLab;
/** introLab*/
@property (nonatomic, strong) UILabel * introLab;

/** scroll容器*/
@property (nonatomic, strong) UIScrollView * scrollView;
@end

@implementation JHSearchDetailVc

#pragma mark --- 懒加载

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        _scrollView.contentSize = self.view.bounds.size;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        _titleLab.numberOfLines = 0;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont boldSystemFontOfSize:18];
        [self.scrollView addSubview:_titleLab];
    }
    return _titleLab;
}
- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc]init];
        _timeLab.frame = CGRectMake(10, CGRectGetMaxY(self.titleLab.frame)+10, 100, 20);
        _timeLab.textAlignment = NSTextAlignmentLeft;
        _timeLab.font = [UIFont systemFontOfSize:15];
        _timeLab.textColor = ThemeColorFont2;
        [self.scrollView addSubview:_timeLab];
    }
    return _timeLab;
}
- (UILabel *)tagLab{
    if (!_tagLab) {
        _tagLab = [[UILabel alloc]init];
        _tagLab.frame = CGRectMake(_timeLab.width, CGRectGetMaxY(self.titleLab.frame)+10, SCREEN_WIDTH-_timeLab.width-10, 20);
        _tagLab.textAlignment = NSTextAlignmentRight;
        _tagLab.font = [UIFont systemFontOfSize:15];
        _tagLab.textColor = ThemeColorFont2;
        [self.scrollView addSubview:_tagLab];
    }
    return _tagLab;
}
- (UIImageView *)coverImage{
    if (!_coverImage) {
        _coverImage = [[UIImageView alloc]init];
        _coverImage.image = [UIImage imageNamed:@"headImage1"];
        _coverImage.frame = CGRectMake(0, CGRectGetMaxY(self.timeLab.frame)+10, SCREEN_WIDTH, 300);
        [self.scrollView addSubview:_coverImage];
    }
    return _coverImage;
}

- (UILabel *)introLab{
    if (!_introLab) {
        _introLab = [[UILabel alloc]init];
        _introLab.font = [UIFont systemFontOfSize:15];
        _introLab.numberOfLines = 0;
        _introLab.frame = CGRectMake(0, CGRectGetMaxY(self.coverImage.frame)+10, SCREEN_WIDTH, 100);
        [self.scrollView addSubview:_introLab];
    }
    return _introLab;
}

#pragma mark --- Label高度自适应
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self loadData];
}

- (void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(10, 30, 20, 20);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickToBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
}
- (void)clickToBack{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)loadData{
    NSString *nowTime = [self getNowTime];
    NSLog(@"nowTime=%@",nowTime);
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
   
    //%E6%90%9E%E7%AC%91//1527128306
    NSString * URL = [NSString stringWithFormat:@"http://www.yuntoo.com/api/story/%@/?is_draft=2&client_type=1&client_version=3.2.7&build_version=100942&uuid=DB82C673-C9A9-42D5-A709-428041796AE7&session_key=&req_time=%@",self.searchID,nowTime];
    //接收参数类型
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
    //设置超时时间
    manger.requestSerializer.timeoutInterval = 15;
    [manger GET:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableDictionary *dataDict = responseObject[@"data"];
        [self.coverImage downloadImage:dataDict[@"story_cover"] placeholder:@"headImage1"];
        self.tagLab.text = dataDict[@"story_tag"];
        
        self.introLab.text = [self changeEncodingStringToUrlString:dataDict[@"user_intro"]];
        
        NSString *time = [dataDict[@"story_create_time"] substringWithRange:NSMakeRange(0, 10)];
        self.timeLab.text = time;
        self.titleLab.text = [self changeEncodingStringToUrlString:dataDict[@"story_title"]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error==%@",error);
        
        [self showHint:@"请检查您的网络!"];
        
    }];
}

#pragma mark --- 获取当前时间戳
- (NSString *)getNowTime{
    // 获取时间（非本地时区，需转换）
    NSDate * today = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:today];
    // 转换成当地时间
    NSDate *localeDate = [today dateByAddingTimeInterval:interval];
    // 时间转换成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];//@"1517468580"
    return timeSp;
}

#pragma maek --- URL解码
///解码
- (NSString *)changeEncodingStringToUrlString:(NSString *)encodingString{
    NSString * urlString = [encodingString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return urlString;
}

@end
