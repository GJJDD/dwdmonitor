//
//  NSString+DWDDate.m
//  dwdmonitor
//
//  Created by dianwoda on 16/9/30.
//  Copyright © 2016年 dianwoda. All rights reserved.
//

#import "NSString+DWDDate.h"

@implementation NSString (DWDDate)

+ (NSString *)dateWithTimeInterval:(NSTimeInterval)eventTimeInterval
{
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:eventTimeInterval/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [formatter stringFromDate:date];
}
@end
