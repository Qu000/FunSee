//
//  JHProfileViewController.m
//  FunSee
//
//  Created by qujiahong on 2018/5/16.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHProfileViewController.h"

#import "Wave.h"

#import "JHCleanCaches.h"

#import "JHARVc.h"

#import "JHSearchVc.h"

#import "JHContactVc.h"

#import "customLayout.h"

#import "JHProfileCell.h"

@interface JHProfileViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

/** Wave*/
@property (nonatomic, strong) Wave * waveView;
/** wave的图片[头像]*/
@property (nonatomic, strong) UIImageView *iconImageView;
/** 切换模式*/
@property (nonatomic, strong) UIButton * changeBtn;
/** btnView*/
@property (nonatomic, strong) UIView * btnView;
@property(strong,nonatomic)NSArray <UIButton*> *arrayBtn;
@property(strong,nonatomic)UIButton *btnA;
@property(strong,nonatomic)UIButton *btnB;
@property(strong,nonatomic)UIButton *btnC;
@property(strong,nonatomic)UIButton *btnD;


@property (nonatomic, strong) UICollectionView *collectionView;
/** titles*/
@property (nonatomic, strong) NSArray * titles;
/** images*/
@property (nonatomic, strong) NSArray * images;

@end

@implementation JHProfileViewController

static NSString * const reuseIdentifier = @"JHProfileCell";

-(Wave *)waveView{
    
    if (!_waveView) {
        _waveView = [[Wave alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        //(0, 202, 220, 1)
        _waveView.backgroundColor = ThemeColorBar1;
        [_waveView addSubview:self.iconImageView];
        [_waveView addSubview:self.changeBtn];
        __weak typeof(self)weakSelf = self;
        _waveView.waveBlock = ^(CGFloat currentY){
            CGRect iconFrame = [weakSelf.iconImageView frame];
            iconFrame.origin.y = CGRectGetHeight(weakSelf.waveView.frame)-CGRectGetHeight(weakSelf.iconImageView.frame)+currentY-weakSelf.waveView.waveHeight;
            weakSelf.iconImageView.frame  =iconFrame;
        };
        
        [_waveView startWaveAnimation];
    }
    return _waveView;
    
}

- (UIImageView *)iconImageView{
    
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.waveView.frame.size.width/2-30, 0, 80, 80)];
        _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconImageView.layer.borderWidth = 2;
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.image = [UIImage imageNamed:@"headImage1"];
    }
    return _iconImageView;
}

- (UIButton *)changeBtn{
    if (!_changeBtn) {
        _changeBtn = [[UIButton alloc]init];
        _changeBtn.frame = CGRectMake(30, self.waveView.frame.size.height/2-30, 60, 30);
        _changeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _changeBtn.layer.borderWidth = 2;
        _changeBtn.layer.cornerRadius = 10;
        _changeBtn.tag = 1;
        [_changeBtn addTarget:self action:@selector(clickToChange:) forControlEvents:UIControlEventTouchUpInside];
        [_changeBtn setTitle:@"<->" forState:UIControlStateNormal];
    }
    return _changeBtn;
}

- (NSArray *)titles{
    if (!_titles) {
        _titles = @[@"AR",@"清除缓存",@"搜索图文",@"联系我们"];
    }
    return _titles;
}

- (NSArray *)images{
    if (!_images) {
        _images = @[@"AR_h",@"clean1",@"search1",@"contact"];
    }
    return _images;
}
#pragma mark --- System method
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self setBtnAnimation];
    
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.waveView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
    
}

- (void)setupUI{
    
    [self setupCollection];
    
}

- (void)setupCollection{
    customLayout *layout = [[customLayout alloc]initWithType:LayoutTypeRotary];
    layout.itemSize = CGSizeMake(200, 230);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.waveView.frame)+20, SCREEN_WIDTH, SCREEN_HEIGHT-280) collectionViewLayout:layout];
    
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JHProfileCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.hidden = YES;
    
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
    
    [self setupBtnView];
}
- (void)setupBtnView{
    UIView *btnView = [[UIView alloc]init];
    btnView.frame = self.collectionView.frame;
    btnView.backgroundColor = [UIColor whiteColor];
    btnView.hidden = NO;
    [self.view addSubview:btnView];
    self.btnView = btnView;
    
    [self setupButton];
}
#pragma mark --- 改变排列方式
- (void)clickToChange:(UIButton *)button{
    
    if (button.tag==1) {//隐藏btnView
        
        self.collectionView.hidden = NO;
    
        self.btnView.hidden = YES;
        
        self.changeBtn.tag++;
        
    }else{//隐藏collection
        
        self.collectionView.hidden = YES;
        
        self.btnView.hidden = NO;
        
        self.changeBtn.tag--;
    }
    
}

#pragma mark --- btnView内容
-(void)setupButton
{
    CGFloat margin=50;
    CGFloat width=(self.view.frame.size.width-margin*3)/2;
    CGFloat height =width;
    
    UIButton *btnA=[UIButton buttonWithType:UIButtonTypeCustom];
    btnA.frame=CGRectMake(margin,90,width,height);
    [btnA addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    [btnA setTitle:self.titles[0] forState:UIControlStateNormal];
    btnA.backgroundColor=[UIColor colorWithRed:0.67f green:0.87f blue:0.92f alpha:1.00f];
    btnA.layer.cornerRadius=width/2;
    [self.btnView addSubview:btnA];
    self.btnA=btnA;
    
    UIButton *btnB=[UIButton buttonWithType:UIButtonTypeCustom];
    btnB.layer.cornerRadius=width/2;
    btnB.frame=CGRectMake(CGRectGetMaxX(btnA.frame)+margin,CGRectGetMinY(btnA.frame),width,height);
    [btnB addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    [btnB setTitle:self.titles[1] forState:UIControlStateNormal];
    btnB.backgroundColor=[UIColor colorWithRed:0.96f green:0.76f blue:0.78f alpha:1.00f];
    [self.btnView addSubview:btnB];
    self.btnB=btnB;
    
    UIButton *btnC=[UIButton buttonWithType:UIButtonTypeCustom];
    btnC.layer.cornerRadius=width/2;
    btnC.frame=CGRectMake(CGRectGetMinX(btnA.frame),CGRectGetMaxY(btnA.frame)+margin,width,height);
    [btnC addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    [btnC setTitle:self.titles[2] forState:UIControlStateNormal];
    btnC.backgroundColor=[UIColor colorWithRed:0.99f green:0.89f blue:0.49f alpha:1.00f];
    [self.btnView addSubview:btnC];
    self.btnC=btnC;
    
    UIButton *btnD=[UIButton buttonWithType:UIButtonTypeCustom];
    btnD.layer.cornerRadius=width/2;
    btnD.frame=CGRectMake(CGRectGetMaxX(btnC.frame)+margin,CGRectGetMinY(btnC.frame),width,height);
    [btnD addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    [btnD setTitle:self.titles[3] forState:UIControlStateNormal];
    btnD.backgroundColor=[UIColor colorWithRed:0.53f green:0.82f blue:0.93f alpha:1.00f];
    [self.btnView addSubview:btnD];
    self.btnD=btnD;
    
    self.arrayBtn=@[btnA,btnB,btnC,btnD];
    
}

-(void)btnclick:(UIButton *)btn
{
    BOOL support = [self judgeSupportAR];
    UIDevice *device = [[UIDevice alloc]init];
    CGFloat systemVersion = [device.systemVersion floatValue];
    
    if(btn == self.btnA)
    {
        if (support) {//A9、A10处理器
            JHARVc *arVc = [[JHARVc alloc]init];
            [self presentViewController:arVc animated:YES completion:nil];
            
        }else{
            if (systemVersion>=11.0) {
                [self showInfo:@"该设备暂不支持该功能,请更换设备哟!"];
            }else{
                [self showInfo:@"请将设备升级到11.0之上哟!"];
            }
        }
        
    }else if(btn == self.btnB)
    {
        [self cleanCaches];
        
    }else if(btn == self.btnC)
    {
        //搜索资讯
        JHSearchVc *speechVc = [[JHSearchVc alloc]init];
        [self presentViewController:speechVc animated:YES completion:nil];
        
    }else if(btn == self.btnD)
    {
        //联系我们
        JHContactVc *contactVc = [[JHContactVc alloc]init];
        contactVc.view.layer.cornerRadius = 16;
        contactVc.view.layer.masksToBounds = YES;
        [self presentViewController:contactVc animated:YES completion:nil];
    }
    
}
-(void)setBtnAnimation
{
    
    for (UIButton *btn in self.arrayBtn) {
        
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        pathAnimation.calculationMode = kCAAnimationPaced;
        pathAnimation.fillMode = kCAFillModeForwards;
        
        pathAnimation.repeatCount = MAXFLOAT;
        pathAnimation.autoreverses=YES;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        
        if(btn == self.btnA)
        {
            pathAnimation.duration=5;
            
        }else if(btn == self.btnB)
        {
            pathAnimation.duration=6;
            
        }else if(btn == self.btnC)
        {
            pathAnimation.duration=7;
            
        }else if(btn == self.btnD)
        {
            pathAnimation.duration=4;
        }
        
        
        UIBezierPath *path=[UIBezierPath bezierPathWithOvalInRect:CGRectInset(btn.frame, btn.frame.size.width/2-5, btn.frame.size.width/2-5)];
        pathAnimation.path=path.CGPath;
        [btn.layer addAnimation:pathAnimation forKey:@"pathAnimation"];
        
        CAKeyframeAnimation *scaleX=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
        
        scaleX.values   = @[@1.0, @1.1, @1.0];
        scaleX.keyTimes = @[@0.0, @0.5,@1.0];
        scaleX.repeatCount = MAXFLOAT;
        scaleX.autoreverses = YES;
        
        
        if(btn == self.btnA)
        {
            scaleX.duration=4;
            
        }else if(btn == self.btnB)
        {
            scaleX.duration=5;
            
        }else if(btn == self.btnC)
        {
            scaleX.duration=7;
            
        }else if(btn == self.btnD)
        {
            scaleX.duration=6;
        }
        
        [btn.layer addAnimation:scaleX forKey:@"scaleX"];
        
        
        CAKeyframeAnimation *scaleY=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
        
        scaleY.values   = @[@1.0, @1.1, @1.0];
        scaleY.keyTimes = @[@0.0, @0.5,@1.0];
        scaleY.repeatCount = MAXFLOAT;
        scaleY.autoreverses = YES;
        if(btn == self.btnA)
        {
            scaleY.duration=6;
            
        }else if(btn == self.btnB)
        {
            scaleY.duration=7;
            
        }else if(btn == self.btnC)
        {
            scaleY.duration=4;
            
        }else if(btn == self.btnD)
        {
            scaleY.duration=5;
        }
        
        [btn.layer addAnimation:scaleY forKey:@"scaleY"];
        
        
        
    }
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.titles.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHProfileCell *cell = (JHProfileCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    [cell setDataWithTitles:self.titles[indexPath.row] images:self.images[indexPath.row]];
    cell.backgroundColor = JHRGB(240, 240, 240);
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = YES;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL support = [self judgeSupportAR];
    
    UIDevice *device = [[UIDevice alloc]init];
    CGFloat systemVersion = [device.systemVersion floatValue];
    
    switch (indexPath.row) {
        case 0://AR
            {
                if (support) {//A9、A10处理器
                    JHARVc *arVc = [[JHARVc alloc]init];
                    [self presentViewController:arVc animated:YES completion:nil];
                    
                }else{
                    if (systemVersion>=11.0) {
                        [self showInfo:@"该设备暂不支持该功能,请更换设备哟!"];
                    }else{
                        [self showInfo:@"请将设备升级到11.0之上哟!"];
                    }
                }
            }
            break;
        case 1:
        {
            [self cleanCaches];
        }
            break;
        case 2:
        {
            //搜索资讯
            JHSearchVc *speechVc = [[JHSearchVc alloc]init];
            [self presentViewController:speechVc animated:YES completion:nil];
        }
            break;
        case 3:
        {
            //搜索资讯
            JHContactVc *contactVc = [[JHContactVc alloc]init];
            contactVc.view.layer.cornerRadius = 16;
            contactVc.view.layer.masksToBounds = YES;
            [self presentViewController:contactVc animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

- (void)cleanCaches{
    // 1.计算缓存大小
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    float size = [JHCleanCaches folderSizeAtPath:cachesDir];
    
    [self showHint:[NSString stringWithFormat:@"已清理%.2lfM缓存", size]];
    // 清理缓存
    [JHCleanCaches clearCache:cachesDir];
}


@end
