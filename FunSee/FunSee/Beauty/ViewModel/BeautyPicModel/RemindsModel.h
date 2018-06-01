#import <UIKit/UIKit.h>

@interface RemindsModel : NSObject

///description
@property (nonatomic, strong) NSString * descriptionField;

///id
@property (nonatomic, assign) NSInteger ID;

///parent---0
@property (nonatomic, assign) NSInteger parent;

///post_count
@property (nonatomic, assign) NSInteger postCount;

///%e7%be%8e%e6%96%87
@property (nonatomic, strong) NSString * slug;

///title--我要展示的--美文、散文、等类别
@property (nonatomic, strong) NSString * title;
@end
