#import <UIKit/UIKit.h>
#import "FullPicModel.h"

@interface ThumbModel : NSObject

@property (nonatomic, strong) NSDictionary * full;
@property (nonatomic, strong) FullPicModel * fullModel;

@property (nonatomic, strong) NSDictionary *large;

@property (nonatomic, strong) NSDictionary *mediumLarge;

@property (nonatomic, strong) NSDictionary *postThumbnail;
@end
