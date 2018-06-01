//
//  BeautyVideoModel.m
//  FunSee
//
//  Created by qujiahong on 2018/5/26.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "BeautyVideoModel.h"

@implementation BeautyVideoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"channelName":@"channel_name",
             @"descriptionField":@"description",
             @"imageHeight":@"image_height",
             @"imageWidth":@"image_width",
             @"itemCoverUrl":@"item_cover_url",
             @"itemStoryType":@"item_story_type",
             @"storyCover":@"story_cover",
             @"storyCoverInfo":@"story_cover_info",
             @"storyCoverUrl":@"story_cover_url",
             @"storyCreateTime":@"story_create_time",
             @"storyDesc":@"story_desc",
             @"storyGifImgList":@"story_gif_img_list",
             @"storyId":@"story_id",
             @"storyLocation":@"story_location",
             @"storyNewCover":@"story_new_cover",
             @"storyReadingCount":@"story_reading_count",
             @"storyTag":@"story_tag",
             @"storyTitle":@"story_title",
             @"userAvatar":@"user_avatar",
             @"userId":@"user_id",
             @"userIntro":@"user_intro",
             @"userIsPro":@"user_is_pro",
             @"userNickname":@"user_nickname",
             @"videoId":@"video_id",
             @"videoImageUrl":@"video_image_url",
             @"videoMd5":@"video_md5",
             @"videoShareCoverImage":@"video_share_cover_image",
             @"videoSize":@"video_size",
             @"videoTotalTime":@"video_total_time",
             @"videoUrl":@"video_url"
             };
}

@end
