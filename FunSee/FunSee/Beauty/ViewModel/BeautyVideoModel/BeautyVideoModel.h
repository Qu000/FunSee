//
//  BeautyVideoModel.h
//  FunSee
//
//  Created by qujiahong on 2018/5/26.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeautyVideoModel : NSObject

///channel_name 如果不为nil -- 艺术 -- 相当于tag
@property (nonatomic, strong) NSString * channelName;

///要展示的描述信息-URL加密了的，需解码
@property (nonatomic, strong) NSString * descriptionField;

///height
@property (nonatomic, assign) NSInteger imageHeight;
///width
@property (nonatomic, assign) NSInteger imageWidth;

///封面图片
@property (nonatomic, strong) NSString * itemCoverUrl;

///itemDescription 貌似与descriptionField 一样
@property (nonatomic, strong) NSString * itemDescription;

///item id
@property (nonatomic, assign) NSInteger itemId;

///title --- 可直接展示
@property (nonatomic, strong) NSString * itemTitle;

///type - 4
@property (nonatomic, assign) NSInteger itemType;

///ref_item_id --51649
@property (nonatomic, assign) NSInteger refItemId;

///time --- 2018-05-14 15:48:07 +0800
@property (nonatomic, strong) NSString * storyCreateTime;

///storyID --- 51649
@property (nonatomic, assign) NSInteger storyId;

///tag --- 100公里,李红宏 ---要展示的
@property (nonatomic, strong) NSString * storyTag;
@property (nonatomic, strong) NSString * storyTitle;
@property (nonatomic, strong) NSString * userAvatar;
@property (nonatomic, strong) NSString * userEmail;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString * userIntro;
@property (nonatomic, assign) NSInteger userIsPro;
@property (nonatomic, strong) NSString * userNickname;
@property (nonatomic, assign) NSInteger videoId;

///video的封面图片---其实是一致的
@property (nonatomic, strong) NSString * videoImageUrl;

@property (nonatomic, strong) NSString * videoMd5;

///video的size
@property (nonatomic, assign) NSInteger videoSize;

///video的总时长 s
@property (nonatomic, assign) NSInteger videoTotalTime;

///videoUrl --- 需要的
@property (nonatomic, strong) NSString * videoUrl;


@end
