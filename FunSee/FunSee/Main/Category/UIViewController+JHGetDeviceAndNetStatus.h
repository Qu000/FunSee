//
//  UIViewController+JHGetDeviceAndNetStatus.h
//  FunSee
//
//  Created by qujiahong on 2018/5/23.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <sys/utsname.h>

#import <AFNetworking/AFNetworking.h>

@interface UIViewController (JHGetDeviceAndNetStatus)

///获取设备
- (NSString *)getDeviceModel;

///检测网络
- (void)checkNetworkManager;

///判断设备是否支持系统自带AR
- (BOOL)judgeSupportAR;
@end
