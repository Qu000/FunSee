//
//  JHNewsVC.m
//  FunSee
//
//  Created by qujiahong on 2018/5/17.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHNewsVC.h"

#import "NewsFrameModel.h"

#import "JHNewsCell.h"

#import "JHRefresh.h"

@interface JHNewsVC ()<UITableViewDelegate,UITableViewDataSource>

///数据表
@property (nonatomic, strong) UITableView * tableView;

/**
 * 数据源
 * 里面都是NewsFrameModel模型，一个NewsFrameModel对象就是一条段子
 */
@property (nonatomic, strong) NSMutableArray * dataList;

///page参数
@property (nonatomic, assign)NSInteger page;

@property (nonatomic, strong)NSMutableArray *newsFrames;
@end

static NSString *reuseIdentifier = @"JHNewsCell";

@implementation JHNewsVC

#pragma mark --- 懒加载
-(NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}
-(NSMutableArray *)newsFrames{
    if (!_newsFrames) {
        _newsFrames = [[NSMutableArray alloc]init];
    }
    return _newsFrames;
}

#pragma mark --- Systems Method

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI{
    
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHNewsCell class]) bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
    
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg-1"]];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    //防止reloadData之后，cell乱跳
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.page = 1;
    self.tableView.mj_header = [JHRefresh headerWithRefreshingBlock:^{
        self.dataList = [NSMutableArray array];
        NSLog(@"下拉刷新-段子");
        [self loadNewData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self loadOldData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

#pragma mark --- 下拉刷新

- (void)loadNewData{
    
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    NSDictionary * param = @{@"json":@"get_posts",
                             @"post_type":@"page",
                             @"orderby":@"rand",
                             @"page":@"1",
                             @"count":@"20",
                             @"exclude":@"excerpt,modified,author,attachments,tags,comments,comment_count,comment_status,custom_fields,categories,slug,url,status,title,title_plain"
                             };
    NSString * URL = [NSString stringWithFormat:@"%@%@",SERVER_HOST,API_DuanZi];
    //接收参数类型
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
    //设置超时时间
    manger.requestSerializer.timeoutInterval = 15;
    [manger GET:URL parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.tableView.mj_header endRefreshing];
        //返回信息正确--数据解析
        NSArray * newData = [NewsModel mj_objectArrayWithKeyValuesArray:responseObject[@"posts"]];
        
        //将newsModel转为newsFrameModel
        NSArray *newFrames = [self newsFramesWithNews:newData];
        
        if ([self isNotEmpty:newFrames]) {//newData

            //将最新的数据，添加到总数组的最  前 面
            NSRange range = NSMakeRange(0, newFrames.count);
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.dataList insertObjects:newFrames atIndexes:set];
            [self.tableView reloadData];
        }else{
            [self showHint:@"暂无新段子哟!"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error==%@",error);
        [self.tableView.mj_header endRefreshing];
        [self showHint:@"请检查您的网络!"];
    }];

}

#pragma mark --- 上拉刷新
- (void)loadOldData{
    
    NSString * pagesStr = [NSString stringWithFormat:@"%ld",(long)self.page];
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    NSDictionary * param = @{@"json":@"get_posts",
                             @"post_type":@"page",
                             @"orderby":@"date",
                             @"page":pagesStr,
                             @"count":@"20",
                             @"exclude":@"excerpt,modified,author,attachments,tags,comments,comment_count,comment_status,custom_fields,categories,slug,url,status,title,title_plain"
                             };
    NSString * URL = [NSString stringWithFormat:@"%@%@",SERVER_HOST,API_DuanZi];
    //接收参数类型
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
    //设置超时时间
    manger.requestSerializer.timeoutInterval = 15;
    [manger GET:URL parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        //返回信息正确--数据解析
        NSArray * oldData = [NewsModel mj_objectArrayWithKeyValuesArray:responseObject[@"posts"]];
        //将newsModel转为newsFrameModel
        NSArray *oldFrames = [self newsFramesWithNews:oldData];
        
        //将最新的数据，添加到总数组的最  后 面
        [self.dataList addObjectsFromArray:oldFrames];
        [self.tableView reloadData];
        self.page ++;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error==%@",error);
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

#pragma mark - TableView DataSource&&Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NewsFrameModel *model = self.dataList[indexPath.row];
    return model.cellH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (self.dataList.count) {
        NewsFrameModel * model = self.dataList[indexPath.row];
        cell.modelF = model;
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了-段子-的第%ld行",indexPath.row);
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

/**
 *  将NewsModel模型转为NewsFrameModel模型
 */
- (NSArray *)newsFramesWithNews:(NSArray *)news
{
    NSMutableArray *frames = [NSMutableArray array];
    for (NewsModel *model in news) {
        NewsFrameModel *f = [[NewsFrameModel alloc] init];
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
