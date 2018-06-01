//
//  JHBeautyViewController.m
//  FunSee
//
//  Created by qujiahong on 2018/5/17.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHBeautyViewController.h"

#import "JHBeautyWordsCell.h"

#import "BeautyWordFrameModel.h"

#import "JHRefresh.h"

#import "JHBeautyWebController.h"

#import "JHBeautyVideoViewController.h"

#import "JHCustomAnimateTransitionPush.h"

@interface JHBeautyViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>

///数据表
@property (nonatomic, strong) UITableView * tableView;

/**
 * 数据源
 * 里面都是frameModel模型，一个frameModel对象就是一条段子
 */
@property (nonatomic, strong) NSMutableArray * dataList;

///page参数
@property (nonatomic, assign)NSInteger page;

@property (nonatomic, strong)NSMutableArray *newsFrames;


@end

static NSString *reuseIdentifier = @"JHBeautyWordsCell";

@implementation JHBeautyViewController

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

- (UIButton *)button{
    if (!_button) {
        _button = [[UIButton alloc]init];
        _button.frame = CGRectMake(SCREEN_WIDTH-15-40, 10, 40, 40);
    }
    return _button;
}
#pragma mark --- Systems Method
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI{
    
    [self.view addSubview:_button];
    
    [self setupNav];
    
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHBeautyWordsCell class]) bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
    
    UIView *bgView = [[UIView alloc]init];
    [self.tableView addSubview:bgView];
    bgView.frame = self.tableView.frame;
    UIImageView *bgImage = [[UIImageView alloc]init];
    bgImage.frame = self.view.frame;
    [bgImage setImage:[UIImage imageNamed:@"bg-1"]];
    [bgView addSubview:bgImage];
    
    self.tableView.backgroundView = bgView;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //防止reloadData之后，cell乱跳
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.page = 2;
    self.tableView.mj_header = [JHRefresh headerWithRefreshingBlock:^{
        self.dataList = [NSMutableArray array];
        NSLog(@"下拉刷新-美文");
        [self loadNewData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self loadOldData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
#pragma mark --- Nav
- (void)setupNav{
    
    self.navigationItem.title = @"艺美";
    //定制右按钮
    UIButton *butR = [UIButton buttonWithType:UIButtonTypeCustom];
    butR.frame =CGRectMake(0,0, 60, 44);
    [butR setImage:[UIImage imageNamed:@"videoN2"] forState:UIControlStateNormal];
    [butR addTarget:self action:@selector(cilickVideo)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barButR = [[UIBarButtonItem alloc]initWithCustomView:butR];
    self.navigationItem.rightBarButtonItem = barButR;

}

- (void)cilickVideo{
    
    JHBeautyVideoViewController *videoVc = [[JHBeautyVideoViewController alloc]init];
    [self.navigationController pushViewController:videoVc animated:YES];
}
#pragma mark --- 转场动画
-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    
    if(operation==UINavigationControllerOperationPush)
    {
        JHCustomAnimateTransitionPush *animateTransitionPush=[JHCustomAnimateTransitionPush new];
        return animateTransitionPush;
    }
    else
    {
        return nil;
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 必须在viewDidAppear或者viewWillAppear中写，因为每次都需要将delegate设为当前界面
    self.navigationController.delegate=self;
    
    
}

#pragma mark --- 下拉刷新

- (void)loadNewData{
    
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];

    NSDictionary * param = @{@"json":@"get_posts",
                             @"post_type":@"post",
                             @"orderby":@"rand",
                             @"page":@"1",
                             @"count":@"20",
                             @"exclude":@"slug,content,author,comments,attachments,tags,comment_count,comment_status,custom_fields"
                             };
    NSString * URL = [NSString stringWithFormat:@"%@%@",SERVER_HOST,API_BeautyWord];
    //接收参数类型
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
    //设置超时时间
    manger.requestSerializer.timeoutInterval = 15;
    [manger GET:URL parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.tableView.mj_header endRefreshing];
        //返回信息正确--数据解析
        NSArray * newData = [BeautyWordModel mj_objectArrayWithKeyValuesArray:responseObject[@"posts"]];
        
        //将newsModel转为newsFrameModel
        NSArray *newFrames = [self beautyWordsFramesWithNews:newData];
        
        if ([self isNotEmpty:newFrames]) {//newData
            
            //将最新的数据，添加到总数组的最  前 面
            NSRange range = NSMakeRange(0, newFrames.count);
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.dataList insertObjects:newFrames atIndexes:set];
            [self.tableView reloadData];
        }else{
            [self showHint:@"暂无新美文哟!"];
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
                             @"post_type":@"post",
                             @"orderby":@"rand",
                             @"page":pagesStr,
                             @"count":@"20",
                             @"exclude":@"slug,content,author,comments,attachments,tags,comment_count,comment_status,custom_fields"
                             };
    NSString * URL = [NSString stringWithFormat:@"%@%@",SERVER_HOST,API_BeautyWord];
    //接收参数类型
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
    //设置超时时间
    manger.requestSerializer.timeoutInterval = 15;
    [manger GET:URL parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        //返回信息正确--数据解析
        NSArray * oldData = [BeautyWordModel mj_objectArrayWithKeyValuesArray:responseObject[@"posts"]];
        //将newsModel转为newsFrameModel
        NSArray *oldFrames = [self beautyWordsFramesWithNews:oldData];
        
        //将最新的数据，添加到总数组的最  后 面
        [self.dataList addObjectsFromArray:oldFrames];
        [self.tableView reloadData];
        self.page++;
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
    
    BeautyWordFrameModel *model = self.dataList[indexPath.row];
    return model.cellH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHBeautyWordsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (self.dataList.count) {
        BeautyWordFrameModel * model = self.dataList[indexPath.row];
        cell.model = model;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSLog(@"点击了-段子-的第%ld行",indexPath.row);
    BeautyWordFrameModel * model = self.dataList[indexPath.row];
    JHBeautyWebController *webVc = [[JHBeautyWebController alloc]init];
    webVc.url = model.model.url;
    [self presentViewController:webVc animated:YES completion:nil];
    
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
- (NSArray *)beautyWordsFramesWithNews:(NSArray *)words
{
    NSMutableArray *frames = [NSMutableArray array];
    for (BeautyWordModel *model in words) {
        BeautyWordFrameModel *f = [[BeautyWordFrameModel alloc] init];
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
