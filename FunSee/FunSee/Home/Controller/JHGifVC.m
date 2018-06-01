//
//  JHVideoVC.m
//  FunSee
//
//  Created by qujiahong on 2018/5/17.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHGifVC.h"

#import "PicFrameModel.h"

#import "JHGifCell.h"

#import "JHRefresh.h"

@interface JHGifVC ()<UITableViewDelegate,UITableViewDataSource>

///数据表
@property (nonatomic, strong) UITableView * tableView;

///数据源
@property (nonatomic, strong) NSMutableArray * dataList;

/** 设置时间间隔*/
@property (nonatomic, assign) NSInteger hours;
@end

static NSString *reuseIdentifier = @"JHGifCell";

@implementation JHGifVC

#pragma mark --- 懒加载
-(NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}


#pragma mark --- Systems Method
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI{
    
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHGifCell class]) bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
    
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg-1"]];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //防止reloadData之后，cell乱跳
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.hours = 9;
    self.tableView.mj_header = [JHRefresh headerWithRefreshingBlock:^{
        self.dataList = [NSMutableArray array];
        NSLog(@"下拉刷新-Gif");
        [self loadNewData];

    }];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self loadOldData];
    
    }];
    
    [self.tableView.mj_header beginRefreshing];
    self.tableView.tableFooterView = [[UIView alloc] init];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

#pragma mark --- 下拉刷新 --- 点赞等信息还未赋值

- (void)loadNewData{
     
     AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
     NSString * URL = @"http://xiaoliao.vipappsina.com/index.php/Api386/index/pad/0/sw/0/cid/qutu/p/1/markId/0/date/";
    
     //接收参数类型
     manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
     //设置超时时间
     manger.requestSerializer.timeoutInterval = 15;
     [manger POST:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     [self.tableView.mj_header endRefreshing];
     
     //返回信息正确--数据解析
     NSArray * newData = [PicModel mj_objectArrayWithKeyValuesArray:responseObject[@"rows"]];
     //将PicModel转为PicFrameModel
     NSArray *picFrames = [self picFramesWithPics:newData];
     //        NSLog(@"newData==%@",newData);
     if ([self isNotEmpty:picFrames]) {
         
         //将最新的数据，添加到总数组的最  前 面
         NSRange range = NSMakeRange(0, picFrames.count);
         NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
         [self.dataList insertObjects:picFrames atIndexes:set];
         [self.tableView reloadData];
     
     }else{
    
         [self showHint:@"暂无新搞笑图片哟!"];
     }
     
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     NSLog(@"error==%@",error);
     [self.tableView.mj_header endRefreshing];
     [self showHint:@"请检查您的网络!"];
     }];
    
}

#pragma mark --- 上拉刷新
- (void)loadOldData{
    
    NSString * timeSp = [self getOldTime:self.hours];
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    NSString * URL = [NSString stringWithFormat:@"http://xiaoliao.vipappsina.com/index.php/Api386/index/pad/0/sw/0/cid/qutu/lastTime/%@",timeSp];
    //接收参数类型
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
    //设置超时时间
    manger.requestSerializer.timeoutInterval = 15;
    [manger GET:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        //返回信息正确--数据解析
        NSArray * oldData = [PicModel mj_objectArrayWithKeyValuesArray:responseObject];//list
        //将newsModel转为newsFrameModel
        NSArray *oldFrames = [self picFramesWithPics:oldData];
        
        //将最新的数据，添加到总数组的最  后 面
        [self.dataList addObjectsFromArray:oldFrames];
        [self.tableView reloadData];
        self.hours = self.hours + 9;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"error==%@",error);
        [self showHint:@"请检查您的网络!"];
        
    }];
}

#pragma mark - TableView DataSource&&Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PicFrameModel *model = self.dataList[indexPath.row];
    return model.cellH;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHGifCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (self.dataList.count) {
        PicFrameModel * model = self.dataList[indexPath.row];
        cell.modelF = model;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了-Gif-的第%ld行",indexPath.row);
}

#pragma mark --- 动画处理2
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataList.count>0) {
        //设置x和y的初始值为0.1；
        //cell.alpha=0.5;
        cell.layer.transform = CATransform3DMakeScale(0.7, 0.7, 1);
        //x和y的最终值为1
        [UIView animateWithDuration:1 animations:^{
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
            //cell.alpha=1;
        }];
    }
}

#pragma mark --- 获取1小时之前的时间戳
- (NSString *)getOldTime:(NSInteger)hours{
    //得到当前的时间
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //设置时间间隔（秒）
    NSInteger hoursTime = hours/8;
    NSTimeInterval time = hoursTime * 60 * 60;//小时的秒数
    //得到小时之前的当前时间
    NSDate * lastTime = [date dateByAddingTimeInterval:-time];
//    NSLog(@"lastTime=%@",lastTime);
    // 时间转换成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[lastTime timeIntervalSince1970]];
    return timeSp;
    
}

/**
 *  将NewsModel模型转为NewsFrameModel模型
 */
- (NSArray *)picFramesWithPics:(NSArray *)pics
{
    NSMutableArray *frames = [NSMutableArray array];
    for (PicModel *model in pics) {
        PicFrameModel *f = [[PicFrameModel alloc] init];
        f.model = model;
        [frames addObject:f];
    }
    return frames;
}

#pragma mark -- 控制导航栏的显示与隐藏
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //拿到scroll的拖拽手势
    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
    
    //获得拖拽的速度 >0 向下拖动  <0 向上拖动
    CGFloat velocity = [pan velocityInView:scrollView].y;
    
    if (velocity < -5) {
        //向上,隐藏导航栏
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
    }else if(velocity > 5){
        //向下,显示导航栏
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }else if(velocity == 0){
        //停止拖拽
    }
}



@end
