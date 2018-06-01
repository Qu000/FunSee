//
//  JHCleanCaches.h
//  FunSee
//
//  Created by qujiahong on 2018/5/20.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHCleanCaches : NSObject

+ (float)fileSizeAtPath:(NSString *)path;

+ (float)folderSizeAtPath:(NSString *)path;

+ (void)clearCache:(NSString *)path;

@end
