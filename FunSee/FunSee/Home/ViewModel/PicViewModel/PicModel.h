#import <UIKit/UIKit.h>

@interface PicModel : NSObject

///创建时间
@property (nonatomic, strong) NSString * cTime;
@property (nonatomic, strong) NSString * cateId;
@property (nonatomic, strong) NSString * downUrl;
@property (nonatomic, strong) NSString * favoNum;

///id
@property (nonatomic, strong) NSString * ID;

///web
@property (nonatomic, strong) NSString * mp4Url;

///picture的url
@property (nonatomic, strong) NSString * pic;

///picture的height
@property (nonatomic, strong) NSString * picH;

///picture的格式
@property (nonatomic, strong) NSString * picT;

///picture的width
@property (nonatomic, strong) NSString * picW;

///返回时间-今天 13:14 --我需要显示的
@property (nonatomic, strong) NSString * timeStr;

///picture的title
@property (nonatomic, strong) NSString * title;

///uid
@property (nonatomic, strong) NSString * uid;

///uname --- 来源
@property (nonatomic, strong) NSString * uname;
@property (nonatomic, strong) NSString * webUrl;

///被赞数
@property (nonatomic, strong) NSString * zanNum;
@end
