#import <UIKit/UIKit.h>
#import "StoryGifImgList.h"

@interface SearchModel : NSObject

///client_version null
@property (nonatomic, strong) NSObject * clientVersion;

@property (nonatomic, assign) NSInteger imageHeight;
@property (nonatomic, assign) NSInteger imageWidth;


@property (nonatomic, strong) NSString * itemCoverUrl;

///item_story_type 1-2-3-4
@property (nonatomic, assign) NSInteger itemStoryType;

///scroll 0
@property (nonatomic, assign) NSInteger scroll;

///status 2
@property (nonatomic, assign) NSInteger status;

///story_cover 要展示的--图片--
@property (nonatomic, strong) NSString * storyCover;

///story_cover_info ---规格---
@property (nonatomic, strong) NSString * storyCoverInfo;


@property (nonatomic, strong) NSString * storyCoverUrl;

///story_create_time --2016-05-29 20:54:30 +0800--
@property (nonatomic, strong) NSString * storyCreateTime;

///story_desc 我要展示的--描述--
@property (nonatomic, strong) NSString * storyDesc;
@property (nonatomic, strong) StoryGifImgList * storyGifImgList;

///story_id ---27381---详情界面要使用
@property (nonatomic, assign) NSInteger storyId;

@property (nonatomic, strong) NSString * storyLocation;
@property (nonatomic, strong) NSString * storyNewCover;
@property (nonatomic, assign) NSInteger storyReadingCount;
@property (nonatomic, strong) NSString * storyTag;
@property (nonatomic, strong) NSString * storyTitle;
@property (nonatomic, strong) NSString * userAvatar;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString * userIntro;
@property (nonatomic, assign) NSInteger userIsPro;
@property (nonatomic, strong) NSString * userNickname;
@property (nonatomic, assign) NSInteger videoId;
@property (nonatomic, strong) NSString * videoImageUrl;
@property (nonatomic, strong) NSString * videoMd5;
@property (nonatomic, strong) NSObject * videoShareCoverImage;
@property (nonatomic, assign) NSInteger videoSize;
@property (nonatomic, assign) NSInteger videoTotalTime;
@property (nonatomic, strong) NSString * videoUrl;
@end
