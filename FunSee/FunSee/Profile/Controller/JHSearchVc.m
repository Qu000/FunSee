//
//  JHSpeechVc.m
//  FunSee
//
//  Created by qujiahong on 2018/5/22.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHSearchVc.h"

#import <Speech/Speech.h>

#import <AVFoundation/AVFoundation.h>

#import "JHSearchCell.h"

#import "SearchModel.h"

#import "JHSearchDetailVc.h"

#define Spacing 15
@interface JHSearchVc ()<SFSpeechRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) SFSpeechRecognizer *speechRecognizer;
@property (nonatomic,strong) AVAudioEngine *audioEngine;
@property (nonatomic,strong) SFSpeechRecognitionTask *recognitionTask;

///搜索框
@property (weak, nonatomic) IBOutlet UITextField *searchText;


@property (nonatomic,strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;

///悬浮按钮
@property (nonatomic, strong) UIImageView * recordImage;
@property (nonatomic, strong) UIButton * recordButton;
@property(nonatomic, strong) UIWindow *window;


@property (nonatomic, strong) UICollectionView *collectionView;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray * dataList;

@end

@implementation JHSearchVc

static NSString * const reuseIdentifier = @"JHSearchCell";

#pragma mark --- 懒加载
- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}


#pragma mark --- System method
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //延时加载window,注意我们需要在rootWindow创建完成之后再创建这个悬浮的按钮
    [self performSelector:@selector(createBtn) withObject:nil afterDelay:1];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self tapBackgroundToClose];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    for (UIView * view in _window.subviews) {
        if ([view isMemberOfClass:[self.recordImage class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)createBtn{
    
    self.recordImage = [[UIImageView alloc]init];
    self.recordImage.userInteractionEnabled = YES;
    [self.recordImage setImage:[UIImage imageNamed:@"luyin2"]];
    self.recordImage.frame = CGRectMake(0, 0, 70, 70);
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGesture:)];
    self.recordImage.layer.cornerRadius = 35;
    self.recordImage.layer.masksToBounds = YES;
    [self addAnimationForView:self.recordImage withRect:self.recordImage.frame];
    [self.recordImage addGestureRecognizer:longGesture];
    
    _window = [[UIWindow alloc]initWithFrame: CGRectMake(SCREEN_WIDTH - 90, SCREEN_HEIGHT - 90, 70, 70)];
    _window.windowLevel = UIWindowLevelAlert+1;
    
    [_window addSubview:self.recordImage];
    [_window makeKeyAndVisible];//关键语句,显示window
}
- (void)setupUI{
    
    CGFloat itemW = (SCREEN_WIDTH - Spacing*3)/2;
    CGFloat itemH = itemW+50;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumLineSpacing = Spacing;//垂直方向
    layout.minimumInteritemSpacing = Spacing;//水平方向
    
    CGFloat collectionY = CGRectGetMaxY(self.searchText.frame)+20;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, collectionY, SCREEN_WIDTH, SCREEN_HEIGHT-collectionY) collectionViewLayout:layout];
    
    //设置左右缩进
    collectionView.contentInset = UIEdgeInsetsMake(0, Spacing, 0, Spacing);
   
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JHSearchCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
    self.collectionView.hidden = YES;
    
}


#pragma mark --- 关闭键盘
-(void)tapBackgroundToClose{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackground)];
    
    [tap setNumberOfTapsRequired:2];
    
    [self.view addGestureRecognizer:tap];
    
}
-(void)tapBackground{
    
    [self.searchText resignFirstResponder];
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataList.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHSearchCell *cell = (JHSearchCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.model = self.dataList[indexPath.row];
    
    cell.backgroundColor = JHRGB(240, 240, 240);
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    SearchModel *model = self.dataList[indexPath.row];
    JHSearchDetailVc *detailVc = [[JHSearchDetailVc alloc]init];
    detailVc.searchID = [NSString stringWithFormat:@"%ld",(long)model.storyId];
    
    [self presentViewController:detailVc animated:YES completion:nil];

}

#pragma mark --- 关于按钮点击事件
///点击开始搜索
- (IBAction)clickToSearch:(id)sender {
    if (self.searchText.text.length!=0) {
        
        [self.dataList removeAllObjects];
        self.collectionView.hidden = NO;
        [self startSearch];
        
    }else{
        
        self.collectionView.hidden = YES;
        
        [self showHint:@"您的搜索栏为空哟!"];
    }
}

#pragma mark --- 发起搜索
- (void)startSearch{
    
    NSString *nowTime = [self getNowTime];
    
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    
    NSString *searchStr = [self changeUrlStringToEncodingString:self.searchText.text];
    //%E6%90%9E%E7%AC%91//1527128306
    NSString * URL = [NSString stringWithFormat:@"http://www.yuntoo.com/api/search/story/%@?start=0&limit=20&client_type=1&client_version=3.2.7&build_version=100942&uuid=DB82C673-C9A9-42D5-A709-428041796AE7&session_key=&req_time=%@",searchStr,nowTime];
    //接收参数类型
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
    //设置超时时间
    manger.requestSerializer.timeoutInterval = 15;
    [manger GET:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //返回信息正确--数据解析
        NSArray * newData = [SearchModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        if ([self isNotEmpty:newData]) {
            
            [self.dataList addObjectsFromArray:newData];
            
            self.collectionView.hidden = NO;
            
            [self.collectionView reloadData];
        }else{
            [self showHint:@"暂搜索资料哟!"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error==%@",error);
        self.collectionView.hidden = YES;
        [self showHint:@"请检查您的网络!"];
        
    }];
}
///点击back
- (IBAction)clickToBack:(id)sender {
    
     [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma maek --- URL编码
- (NSString *)changeUrlStringToEncodingString:(NSString *)urlString{
    NSString * encodingString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return encodingString;
}


#pragma mark --- 语音
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    __weak typeof(self) weakSelf = self;
    [SFSpeechRecognizer  requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:

                    [weakSelf showHint:@"语音识别未授权"];
                    
                    break;
                case SFSpeechRecognizerAuthorizationStatusDenied:
                   
                    [weakSelf showHint:@"用户未授权使用语音识别"];
                    
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    
                    [weakSelf showHint:@"语音识别在这台设备上受到限制"];
                    
                    
                    break;
                case SFSpeechRecognizerAuthorizationStatusAuthorized:

                    [weakSelf showHint:@"可以开始语音搜索哟!"];
                    
                    break;
                    
                default:
                    break;
            }
            
        });
    }];
}

#pragma mark --- 录音按钮--可改为手势长按
- (void)longGesture:(UILongPressGestureRecognizer *)gesture{
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            //处理开始录音
        {
            self.searchText.text = @"";
            self.recordImage.layer.masksToBounds = NO;
            [self startRecording];
        }
            break;
        case UIGestureRecognizerStateEnded:
            //处理结束录音
        {
            self.recordImage.layer.masksToBounds = YES;
            [self endRecording];
        }
            break;
        default:
            break;
    }
}




#pragma mark --- 结束录音
- (void)endRecording{
    [self.audioEngine stop];
    if (_recognitionRequest) {
        [_recognitionRequest endAudio];
    }
    
    if (_recognitionTask) {
        [_recognitionTask cancel];
        _recognitionTask = nil;
    }

}
- (void)startRecording{
    if (_recognitionTask) {
        [_recognitionTask cancel];
        _recognitionTask = nil;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error;
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    NSParameterAssert(!error);
    [audioSession setMode:AVAudioSessionModeMeasurement error:&error];
    NSParameterAssert(!error);
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    NSParameterAssert(!error);
    
    _recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
    NSAssert(inputNode, @"录入设备没有准备好");
    NSAssert(_recognitionRequest, @"请求初始化失败");
    _recognitionRequest.shouldReportPartialResults = YES;
    __weak typeof(self) weakSelf = self;
    _recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:_recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        BOOL isFinal = NO;
        if (result) {
            strongSelf.searchText.text = result.bestTranscription.formattedString;
            
            isFinal = result.isFinal;
        }
        if (error || isFinal) {
            [self.audioEngine stop];
            [inputNode removeTapOnBus:0];
            strongSelf.recognitionTask = nil;
            strongSelf.recognitionRequest = nil;
            
        }
        
    }];
    
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    //在添加tap之前先移除上一个  不然有可能报"Terminating app due to uncaught exception 'com.apple.coreaudio.avfaudio',"之类的错误
    [inputNode removeTapOnBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.recognitionRequest) {
            [strongSelf.recognitionRequest appendAudioPCMBuffer:buffer];
        }
    }];
    
    [self.audioEngine prepare];
    [self.audioEngine startAndReturnError:&error];
    NSParameterAssert(!error);
    self.searchText.text = @"";
}
#pragma mark - property
- (AVAudioEngine *)audioEngine{
    if (!_audioEngine) {
        _audioEngine = [[AVAudioEngine alloc] init];
    }
    return _audioEngine;
}
- (SFSpeechRecognizer *)speechRecognizer{
    if (!_speechRecognizer) {
        //腰围语音识别对象设置语言，这里设置的是中文
        NSLocale *local =[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        
        _speechRecognizer =[[SFSpeechRecognizer alloc] initWithLocale:local];
        _speechRecognizer.delegate = self;
    }
    return _speechRecognizer;
}
#pragma mark - SFSpeechRecognizerDelegate
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available{
    if (available) {
        //开始录音
    }
    else{
        //语音识别不可用
    }
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

#pragma mark --- 脉冲动画

- (void)addAnimationForView:(UIView *)view withRect:(CGRect)rect{
    CALayer *layer = [CALayer layer];//创建一个layer，最后用来添加到view的图层上展示动画用
    NSInteger repeatCount = 3;//设置重复次数3次
    NSInteger keepTiming = 3;// 设置每段动画持续时间3秒
    
    for (NSInteger i = 0; i< repeatCount; i++) {//每次执行，创建相关动画
        // 每个动画对应一个图层。3个动画，需要有3个图层
        CALayer *animateLayer = [CALayer layer];
        animateLayer.borderColor = JHRGB(25,193,182).CGColor;
        animateLayer.borderWidth = 3.5;
        animateLayer.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
        animateLayer.cornerRadius = rect.size.height/2;
        //到此。每一个图层的大小，形状。颜色设置完毕。
        // 设置图层的scale 使用CABasicAnimation
        CABasicAnimation *basicAni = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        basicAni.fromValue = @1.0f;
        basicAni.toValue = @2.4f;
        
        //设置图层的透明度，使用关键帧动画
        CAKeyframeAnimation *keyani = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        keyani.values = @[@1, @0.9, @0.8, @0.7, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0];
        keyani.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
        
        //我们要让一个动画同时执行scale 和 opacity的变化，需要将他们都加入到layer的动画组
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.fillMode = kCAFillModeBackwards;
        group.duration = keepTiming;
        group.repeatCount = HUGE;
        group.beginTime = CACurrentMediaTime() + (double)i * keepTiming / (double)repeatCount;
        
        group.animations = @[keyani,basicAni];
        [animateLayer addAnimation:group forKey:@"plus"];
        [layer addSublayer:animateLayer];
    }
    [view.layer addSublayer:layer];
}


@end
