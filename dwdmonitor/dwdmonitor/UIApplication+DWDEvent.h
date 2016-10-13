//
//  UIApplication+DWDEvent.h
//  dwdmonitor
//
//  Created by dianwoda on 16/9/29.
//  Copyright © 2016年 dianwoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (DWDEvent)

@property (nonatomic, strong) NSNumber *isCount;

+ (void)dwd_registerSwizzleMethods;
@end
