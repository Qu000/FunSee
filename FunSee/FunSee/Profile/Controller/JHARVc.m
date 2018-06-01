//
//  JHARVc.m
//  FunSee
//
//  Created by qujiahong on 2018/5/21.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "JHARVc.h"

#import <SceneKit/SceneKit.h>

#import <ARKit/ARKit.h>

#import "Ship.h"

#import "Bullet.h"

#import <AudioToolbox/AudioToolbox.h>

@interface JHARVc ()<ARSCNViewDelegate,SCNPhysicsContactDelegate>

@property(nonatomic, strong) UILabel * score;
/** 记录分数*/
@property (nonatomic, assign) NSInteger scoreInter;

//视图
@property(nonatomic, strong) ARSCNView * jhARSCNView;

//会话
@property(nonatomic, strong) ARSession * jhARSession;

//跟踪会话
@property(nonatomic, strong) ARWorldTrackingConfiguration * jhARWTkConfiguration;

/** btn*/
@property (nonatomic, strong) UIButton * btn;

@end

@implementation JHARVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(10, 20, 40, 40);//Y->60
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickToBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    self.btn = backBtn;
    
    self.view.backgroundColor = ThemeColorBar1;
    
    [self.view addSubview:self.jhARSCNView];
    
    [self initUI];
    
    [self addNewShip];
    
}

- (void)clickToBack{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)toPlaySoundWithSoundStr:(NSString *)soundStr{
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@.mp3",soundStr] withExtension:nil];
    
    //创建声音对象
    SystemSoundID outSystemSoundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &outSystemSoundID);
    
    //播放音效
    AudioServicesPlaySystemSound(outSystemSoundID);
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.jhARSCNView.session runWithConfiguration:self.jhARWTkConfiguration];
    
}

#pragma mark - 初始化UI

-(void)initUI {
    
    UILabel * score = [[UILabel alloc]init];
    
    score.frame = CGRectMake(self.view.frame.size.width/2-70, 70, 140, 24);//Y->84
    self.scoreInter = 0;
    score.text = @"您还未击中本coder!";//已击中coder%ld次啦
    
    [score setFont:[UIFont systemFontOfSize:13]];
    
    score.textColor = [UIColor whiteColor];
    
    score.textAlignment = NSTextAlignmentCenter;
    
    self.score = score;
    
    [self.view addSubview:score];
}

#pragma mark - 私有方法


- (void)addNewShip {
    
    Ship * cubeNode = [[Ship alloc]init];
    
    float x = [self floatBetween];
    float y = [self floatBetween];
    
    cubeNode.position = SCNVector3Make(x, y, -1);
    
    [self.jhARSCNView.scene.rootNode addChildNode:cubeNode];
    
}


//生产随机数
- (CGFloat )floatBetween {
    
    CGFloat a = (float)(1+arc4random()%99)/100-0.5;
    
    NSLog(@"a == %f",a);
    
    return a;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"发射子弹球");
    
    [self toPlaySoundWithSoundStr:@"torpedo"];
    
    Bullet * bulletsNode = [[Bullet alloc]init];
    
    NSArray * arr = [self getUserVector];
    
    NSValue * dirValue = arr[0];
    NSValue * posValue = arr[1];
    
    SCNVector3 direction = [dirValue SCNVector3Value];
    SCNVector3 position  = [posValue SCNVector3Value];
    
    bulletsNode.position = position;
    
    SCNVector3 bulletDirection = direction;
    
    [bulletsNode.physicsBody applyForce:bulletDirection impulse:YES];
    
    [self.jhARSCNView.scene.rootNode addChildNode:bulletsNode];
    
}

- (void)removeNodeWithAnimation:(SCNNode *)node explosion:(BOOL)explosion {
    
    NSLog(@"粒子动画");
    
    if (explosion) {
        
        [self toPlaySoundWithSoundStr:@"explosion"];
        
        SCNParticleSystem * particleSystem = [SCNParticleSystem particleSystemNamed:@"explosion" inDirectory:nil];
        
        SCNNode * systemNode = [[SCNNode alloc]init];
        
        [systemNode addParticleSystem:particleSystem];
        
        systemNode.position = node.position;
        
        [self.jhARSCNView.scene.rootNode addChildNode:systemNode];
        
    }
    
    [node removeFromParentNode];
    
}

- (NSArray *)getUserVector {
    
    ARFrame * frame = self.jhARSCNView.session.currentFrame;
    
    if (frame) {
        
        SCNMatrix4 mat = SCNMatrix4FromMat4(frame.camera.transform);
        
        SCNVector3 dir = SCNVector3Make(-1* mat.m31, -1* mat.m32 , -1* mat.m33);
        
        SCNVector3 pos = SCNVector3Make(mat.m41,mat.m42 ,mat.m43);
        
        NSValue * dirValue = [NSValue valueWithSCNVector3:dir];
        NSValue * posValue = [NSValue valueWithSCNVector3:pos];
        
        return @[dirValue,posValue];
        
    }else {
        
        NSValue * dirValue = [NSValue valueWithSCNVector3:(SCNVector3Make(0, 0, -1))];
        NSValue * posValue = [NSValue valueWithSCNVector3:(SCNVector3Make(0, 0, -0.2))];
        
        return @[dirValue,posValue];
    }
    
}
#pragma mark --- ARSCNViewDelegate

- (void)session:(ARSession *)session didFailWithError:(NSError *)error {
    // Present an error message to the user
    
}

- (void)sessionWasInterrupted:(ARSession *)session {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
    
}

- (void)sessionInterruptionEnded:(ARSession *)session {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    
}

#pragma mark --- SCNPhysicsContactDelegate
// 这里是自己独立开一条线程出来
- (void)physicsWorld:(SCNPhysicsWorld *)world didBeginContact:(SCNPhysicsContact *)contact {
    
    NSLog(@"触发");
    
    [self toPlaySoundWithSoundStr:@"collision"];
    
    if (contact.nodeA.physicsBody.categoryBitMask == 2 ||
        contact.nodeB.physicsBody.categoryBitMask == 2) {
        
        [self removeNodeWithAnimation:contact.nodeB explosion:NO];
        
        self.scoreInter ++;
        
        dispatch_sync(dispatch_get_main_queue(), ^(){
            self.score.text = [NSString stringWithFormat:@"您已击中coder%ld次啦!", self.scoreInter];
            NSLog(@"self.score.text=%@",self.score.text);
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self removeNodeWithAnimation:contact.nodeA explosion:YES];
            [self addNewShip];
            
        });
        
    }
    
}



#pragma mark - 访问器方法

- (ARSCNView *)jhARSCNView {
    
    if (_jhARSCNView == nil) {
        
        _jhARSCNView = [[ARSCNView alloc]init];
        
        _jhARSCNView.frame = CGRectMake(0, CGRectGetMaxY(self.btn.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT-84);//self.view.frame
        
        _jhARSCNView.delegate = self;
        
        _jhARSCNView.showsStatistics = YES;
        
        SCNScene * scene= [[SCNScene alloc]init];
        _jhARSCNView.scene = scene;
        
        _jhARSCNView.scene.physicsWorld.contactDelegate = self;
        
    }
    
    return _jhARSCNView;
}

- (ARSession *)jhARSession {
    
    if (_jhARSession == nil) {
        _jhARSession = [[ARSession alloc]init];
    }
    
    return _jhARSession;
    
}

- (ARWorldTrackingConfiguration *)jhARWTkConfiguration {
    
    if (_jhARWTkConfiguration == nil) {
        _jhARWTkConfiguration = [[ARWorldTrackingConfiguration alloc]init];
        _jhARWTkConfiguration.planeDetection = ARPlaneDetectionHorizontal;
    }
    
    return _jhARWTkConfiguration;
    
}


@end
