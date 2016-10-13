//
//  NSString+DWDDate.h
//  dwdmonitor
//
//  Created by dianwoda on 16/9/30.
//  Copyright © 2016年 dianwoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DWDDate)
+ (NSString *)dateWithTimeInterval:(NSTimeInterval)eventTimeInterval;
@end
