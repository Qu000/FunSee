//
//  JHBeautyVideoViewController.m
//  FunSee
//
//  Created by qujiahong on 2018/5/26.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHBeautyVideoViewController.h"

#import "JHRefresh.h"

#import "BeautyVideoModel.h"

#import "JHBeautyVideoCell.h"

#import "CLPlayerView.h"

#import "JHCustomAnimateTransitionPop.h"

@interface JHBeautyVideoViewController ()<JHBeautyVideoCellDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong)NSMutableArray * dataList;
@property (nonatomic, strong)NSMutableArray * tempArr;
@property (nonatomic, assign)NSInteger pages;

/**CLplayer*/
@property (nonatomic, weak) CLPlayerView *playerView;
/**记录Cell*/
@property (nonatomic, assign) UITableViewCell *cell;

///转场
@property(nonatomic,strong)UIPercentDrivenInteractiveTransition *interactiveTransition;
@end

@implementation JHBeautyVideoViewController


-(NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}
-(NSMutableArray *)tempArr{
    if (!_tempArr) {
        _tempArr = [[NSMutableArray alloc]init];
    }
    return _tempArr;
}


#pragma mark --- Systems method
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.delegate=self;
    
    self.navigationItem.hidesBackButton = YES;
}

#pragma mark - 释放处理
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    __weak __typeof(self)wself = self;
    [_playerView endPlay:^{
        //销毁播放器
        [wself.playerView destroyPlayer];
        wself.playerView = nil;
        wself.cell = nil;
    }];
    
    //销毁播放器
    [_playerView destroyPlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pages = 10;
    
    [self setupUI];
}

- (void)setupUI{
    
    [self setupNav];
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.mj_header = [JHRefresh headerWithRefreshingBlock:^{
        self.dataList = [NSMutableArray array];
        NSLog(@"下拉刷新-艺术视频");
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
    
    [butR setImage:[UIImage imageNamed:@"words1"] forState:UIControlStateNormal];
    [butR addTarget:self action:@selector(cilickPic)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  *barButR = [[UIBarButtonItem alloc]initWithCustomView:butR];
    self.navigationItem.rightBarButtonItem = barButR;
    
}
- (void)cilickPic{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark --- 转场
//为这个动画添加用户交互
- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return self.interactiveTransition;
}
//用来自定义转场动画
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        JHCustomAnimateTransitionPop *pingInvert = [JHCustomAnimateTransitionPop new];
        return pingInvert;
    }else{
        return nil;
    }
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHBeautyVideoCell *cell = [JHBeautyVideoCell cellWithTableView:tableView];

    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 420;
    
}

//在willDisplayCell里面处理数据能优化tableview的滑动流畅性，cell将要出现的时候调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JHBeautyVideoCell *myCell = (JHBeautyVideoCell *)cell;
    myCell.model = self.dataList[indexPath.row];
    
    //Cell开始出现的时候修正偏移量，让图片可以全部显示
    [myCell cellOffset];
    //第一次加载动画
    [[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:myCell.model.itemCoverUrl] completion:^(BOOL isInCache) {
        if (!isInCache) {
            //主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                CATransform3D rotation;//3D旋转
                rotation = CATransform3DMakeTranslation(0 ,50 ,20);
                //逆时针旋转
                rotation = CATransform3DScale(rotation, 0.8, 0.9, 1);
                rotation.m34 = 1.0/ -600;
                myCell.layer.shadowColor = [[UIColor blackColor]CGColor];
                myCell.layer.shadowOffset = CGSizeMake(10, 10);
                myCell.alpha = 0;
                myCell.layer.transform = rotation;
                [UIView beginAnimations:@"rotation" context:NULL];
                //旋转时间
                [UIView setAnimationDuration:0.6];
                myCell.layer.transform = CATransform3DIdentity;
                myCell.alpha = 1;
                myCell.layer.shadowOffset = CGSizeMake(0, 0);
                [UIView commitAnimations];
            });
        }
    }];
}

//cell离开tableView时调用
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //因为复用，同一个cell可能会走多次
    if ([_cell isEqual:cell]) {
        //区分是否是播放器所在cell,销毁时将指针置空
        [_playerView destroyPlayer];
        _cell = nil;
    }
}

#pragma mark - cell播放代理
- (void)tableViewCellPlayVideoWithCell:(JHBeautyVideoCell *)cell{
    //记录被点击的Cell
    _cell = cell;
    //销毁播放器
    [_playerView destroyPlayer];
    CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*3/4)];//cell.width  cell.height
    
    _playerView = playerView;
    
    [cell.contentView addSubview:_playerView];
    //视频地址
    _playerView.url = [NSURL URLWithString:cell.model.videoUrl];
    
    //播放
    [_playerView playVideo];
    //返回按钮点击事件回调
    [_playerView backButton:^(UIButton *button) {
        NSLog(@"返回按钮被点击");
    }];
    //播放完成回调
    __weak __typeof(self)wself = self;
    [_playerView endPlay:^{
        //销毁播放器
        [wself.playerView destroyPlayer];
        wself.playerView = nil;
        wself.cell = nil;
        NSLog(@"播放完成");
    }];
}
#pragma mark - 滑动代理
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
#pragma mark --- 加载数据
- (void)loadNewData{
    NSString * timeSp = [self getNowTime];
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    NSDictionary * param = @{@"client_type":@"1",
                             @"client_version":@"3.2.6",
                             @"build_version":@"100938",
                             @"uuid":@"A836978E-75CA-4713-A835-B15A64DBBBCE",
                             @"session_key":@"",
                             @"req_time":timeSp,
                             @"offset":@"0",
                             @"limit":@"10"
                             };
    NSString * URL = @"http://www.yuntoo.com/v2/home/channel/3/refresh";
    //接收参数类型
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
    //设置超时时间
    manger.requestSerializer.timeoutInterval = 15;
    [manger GET:URL parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        //返回信息正确--数据解析
        NSArray * newData = [BeautyVideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //将最新的数据，添加到总数组的最  前 面
        NSRange range = NSMakeRange(0, newData.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.dataList insertObjects:newData atIndexes:set];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error==%@",error);
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
    }];
}
- (void)loadOldData{
    NSString * timeSp = [self getNowTime];
    NSString * pagesStr = [NSString stringWithFormat:@"%ld",(long)self.pages];
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    NSDictionary * param = @{@"client_type":@"1",
                             @"client_version":@"3.2.6",
                             @"build_version":@"100938",
                             @"uuid":@"A836978E-75CA-4713-A835-B15A64DBBBCE",
                             @"session_key":@"",
                             @"req_time":timeSp,
                             @"offset":pagesStr,
                             @"limit":@"10"
                             };
    NSString * URL = @"http://www.yuntoo.com/v2/home/channel/3/";
    //接收参数类型
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
    //设置超时时间
    manger.requestSerializer.timeoutInterval = 15;
    [manger GET:URL parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        //返回信息正确--数据解析
        NSArray * oldData = [BeautyVideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //将最新的数据，添加到总数组的最  后 面
        [self.dataList addObjectsFromArray:oldData];
        [self.tableView reloadData];
        self.pages = self.pages + 10;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error==%@",error);
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        
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



/*
 // visibleCells 获取界面上能显示出来了cell
 NSArray<JHBeautyVideoCell *> *array = [self.tableView visibleCells];
 //enumerateObjectsUsingBlock 类似于for，但是比for更快
 [array enumerateObjectsUsingBlock:^(JHBeautyVideoCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
 //        [obj cellOffset];
 }];
 */


@end
