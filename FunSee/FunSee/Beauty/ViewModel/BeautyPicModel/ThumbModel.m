//
//	ThumbnailImage.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "ThumbModel.h"

NSString *const kThumbnailImageFull = @"full";
NSString *const kThumbnailImageLarge = @"large";
NSString *const kThumbnailImageMediumLarge = @"medium_large";
NSString *const kThumbnailImagePostthumbnail = @"post-thumbnail";

@interface ThumbModel ()
@end
@implementation ThumbModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"mediumLarge":@"medium_large",
             @"postThumbnail":@"post-thumbnail",
             @"titlePlain":@"title_plain"
             };
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"full":[FullPicModel class]};
}

@end
