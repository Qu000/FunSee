//
//  JHVideoViewController.m
//  FunSee
//
//  Created by qujiahong on 2018/5/16.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHVideoViewController.h"

#import "JHVideoCell.h"

#import "VideoFrameModel.h"

#import "JHRefresh.h"

#import "JHPlayViewController.h"

#import "CLPlayerView.h"

@interface JHVideoViewController ()<UITableViewDelegate,UITableViewDataSource,JHVideoCellDelegate>

///数据表
@property (nonatomic, strong) UITableView * tableView;

/**
 * 数据源
 * 里面都是VideoFrameModel模型，一个VideoFrameModel对象就是一条段子
 */
@property (nonatomic, strong) NSMutableArray * dataList;

///page参数
@property (nonatomic, assign)NSInteger page;

@property (nonatomic, strong)NSMutableArray *newsFrames;

/**CLplayer*/
@property (nonatomic, weak) CLPlayerView *playerView;
/**记录Cell*/
@property (nonatomic, assign) UITableViewCell *cell;

@end

static NSString *reuseIdentifier = @"JHVideoCell";

@implementation JHVideoViewController

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
    
    self.navigationItem.title = @"Fun看";
    
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHVideoCell class]) bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);

    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg-1"]];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //防止reloadData之后，cell乱跳
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.page = 48818;
    if (self.page <= 100) {
        self.page = 48818;
    }
    self.tableView.mj_header = [JHRefresh headerWithRefreshingBlock:^{
        self.dataList = [NSMutableArray array];
        NSLog(@"下拉刷新-视频");
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
    
    NSString * URL = @"http://gaoxiaoshipin.vipappsina.com/index.php/NewApi38/index/markId/0/random/0/sw/1";
    //接收参数类型
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
    //设置超时时间
    manger.requestSerializer.timeoutInterval = 15;
    [manger GET:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.tableView.mj_header endRefreshing];
        //返回信息正确--数据解析
        NSArray * newData = [VideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"rows"]];
        
        //将newsModel转为newsFrameModel
        NSArray *newFrames = [self videoFramesWithNews:newData];
        
        if ([self isNotEmpty:newFrames]) {//newData
            
            //将最新的数据，添加到总数组的最  前 面
            NSRange range = NSMakeRange(0, newFrames.count);
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.dataList insertObjects:newFrames atIndexes:set];
            [self.tableView reloadData];
        }else{
            [self showHint:@"暂无新视频哟!"];
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
    
    NSString * URL = [NSString stringWithFormat:@"http://gaoxiaoshipin.vipappsina.com/index.php/NewApi38/index/lastId/%@/random_more/0/sw/1",pagesStr];
    //接收参数类型
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
    //设置超时时间
    manger.requestSerializer.timeoutInterval = 15;
    [manger GET:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        //返回信息正确--数据解析
        NSArray * oldData = [VideoModel mj_objectArrayWithKeyValuesArray:responseObject];
        //将newsModel转为newsFrameModel
        NSArray *oldFrames = [self videoFramesWithNews:oldData];
        
        //将最新的数据，添加到总数组的最  后 面
        [self.dataList addObjectsFromArray:oldFrames];
        [self.tableView reloadData];
        self.page = self.page - 15;
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
    
    VideoFrameModel *model = self.dataList[indexPath.row];
    return model.cellH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (self.dataList.count) {
        __block VideoFrameModel * model = self.dataList[indexPath.row];
        cell.modelF = model;
        
        cell.delegate = self;
       
    }
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
- (void)tableViewCellPlayVideoWithCell:(JHVideoCell *)cell{
    if ([cell.modelF.model.mp4Url isEqualToString:@"web"]) {
        
        JHPlayViewController *playVC = [[JHPlayViewController alloc]init];
        playVC.index = 1;
        playVC.model = cell.modelF;
        [self presentViewController:playVC animated:YES completion:nil];
        
    }else{
        //记录被点击的Cell
        _cell = cell;
        //销毁播放器
        [_playerView destroyPlayer];
        CLPlayerView *playerView = [[CLPlayerView alloc] initWithFrame:CGRectMake(0, cell.modelF.picF.origin.y, SCREEN_WIDTH, SCREEN_WIDTH*3/4)];//cell.width  cell.height
        playerView.progressPlayFinishColor = JHRGB(57, 185, 170);
        playerView.progressBackgroundColor = ThemeColorBar1;
        playerView.progressBufferColor = JHRGB(255, 205, 237);
        _playerView = playerView;
        
        [cell.contentView addSubview:_playerView];
        //视频地址
        
        _playerView.url = [NSURL URLWithString:cell.modelF.model.mp4Url];
        
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
    
}
/**
 *  将NewsModel模型转为NewsFrameModel模型
 */
- (NSArray *)videoFramesWithNews:(NSArray *)video
{
    NSMutableArray *frames = [NSMutableArray array];
    for (VideoModel *model in video) {
        VideoFrameModel *f = [[VideoFrameModel alloc] init];
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


#pragma mark --- 检测横竖屏
- (void)viewWillLayoutSubviews{
    
    [self shouldRotateToOrientation:(UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation];
    
}
- (void)shouldRotateToOrientation:(UIDeviceOrientation)orientation {
    if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
        //竖屏
        
    }else{
        //横屏
        
        
    }
}


@end
