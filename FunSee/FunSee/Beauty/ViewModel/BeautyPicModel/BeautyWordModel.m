//
//	Post.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "BeautyWordModel.h"

NSString *const kPostCategories = @"categories";
NSString *const kPostDate = @"date";
NSString *const kPostExcerpt = @"excerpt";
NSString *const kPostIdField = @"id";
NSString *const kPostModified = @"modified";
NSString *const kPostStatus = @"status";
NSString *const kPostThumbnail = @"thumbnail";
NSString *const kPostThumbnailImages = @"thumbnail_images";
NSString *const kPostThumbnailSize = @"thumbnail_size";
NSString *const kPostTitle = @"title";
NSString *const kPostTitlePlain = @"title_plain";
NSString *const kPostType = @"type";
NSString *const kPostUrl = @"url";

@interface BeautyWordModel ()
@end
@implementation BeautyWordModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id",
             @"thumbnailImages":@"thumbnail_images",
             @"thumbnailSize":@"thumbnail_size",
             @"titlePlain":@"title_plain"
             };
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"categories":[RemindsModel class]};
}

@end
