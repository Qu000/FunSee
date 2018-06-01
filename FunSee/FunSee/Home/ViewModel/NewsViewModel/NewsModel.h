#import <UIKit/UIKit.h>

@interface NewsModel : NSObject

///段子内容
@property (nonatomic, strong) NSString * content;

///段子发布时间
@property (nonatomic, strong) NSString * date;

///段子id
@property (nonatomic, assign) NSInteger ID;

///page
@property (nonatomic, strong) NSString * type;

@end
