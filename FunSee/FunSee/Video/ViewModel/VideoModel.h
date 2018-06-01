#import <UIKit/UIKit.h>

@interface VideoModel : NSObject

///发布时间 --- 我要展示的
@property (nonatomic, strong) NSString * cTime;

///favo_num
@property (nonatomic, strong) NSString * favoNum;

///id
@property (nonatomic, strong) NSString * ID;

///播放地址
@property (nonatomic, strong) NSString * mp4Url;

///封面图片
@property (nonatomic, strong) NSString * pic;

///视频简介 --- 较长篇幅
@property (nonatomic, strong) NSString * title;

///web url
@property (nonatomic, strong) NSString * url;

///获赞数
@property (nonatomic, strong) NSString * zanNum;
@end
