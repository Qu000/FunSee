//
//  NSString+Time.m
//  Fun_iOS
//
//  Created by qujiahong on 2018/5/11.
//  Copyright © 2018年 瞿嘉洪. All rights reserved.
//

#import "NSString+Time.h"

@implementation NSString (Time)
+ (NSString *)stringWithTime:(CGFloat)time;
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    
    if (time >= 3600) {
        [dateFmt setDateFormat:@"HH:mm:ss"];
    } else {
        [dateFmt setDateFormat:@"mm:ss"];
    }
    return [dateFmt stringFromDate:date];
}
@end
