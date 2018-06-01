#import <UIKit/UIKit.h>
#import "RemindsModel.h"
#import "ThumbModel.h"

@interface BeautyWordModel : NSObject

///图片类别信息数组
@property (nonatomic, strong) NSArray * categories;
///图片类别信息model
@property (nonatomic, strong) RemindsModel * categoriesModel;

///date---我要展示的
@property (nonatomic, strong) NSString * date;

///描述信息--较长--含html标签
@property (nonatomic, strong) NSString * excerpt;

///id
@property (nonatomic, assign) NSInteger ID;

///modified----2016-07-04 10:22:30
@property (nonatomic, strong) NSString * modified;

///status---publish
@property (nonatomic, strong) NSString * status;

///图片
@property (nonatomic, strong) NSString * thumbnail;
@property (nonatomic, strong) NSString * thumbnailSize;

///图片详细信息
@property (nonatomic, strong) NSDictionary * thumbnailImages;
@property (nonatomic, strong) ThumbModel * thumbModel;

///title标题---我要展示的
@property (nonatomic, strong) NSString * title;

///title_plain
@property (nonatomic, strong) NSString * titlePlain;

///post
@property (nonatomic, strong) NSString * type;

///详情页访问URL
@property (nonatomic, strong) NSString * url;
@end
