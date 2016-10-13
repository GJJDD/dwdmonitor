//
//  NSString+DWDDevice.h
//  dwdmonitor
//
//  Created by dianwoda on 16/9/30.
//  Copyright © 2016年 dianwoda. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface NSString (DWDDevice)

+ (NSString *)screenScale;
+ (NSString *)deviceVersion;
+ (NSString *)wifiName;
+ (NSString *)networktype;
+ (NSString *)getcarrierName;
+ (NSString *)getCurrentBatteryLevel;
+ (NSString *)memorySize;
+ (NSString *)diskSize;
+ (NSString *)jailBreak;
+ (NSString *)usedMemorySize;
@end
