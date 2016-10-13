//
//  DWDUncaughtExceptionHandler.m
//  dwdmonitor
//
//  Created by dianwoda on 16/9/29.
//  Copyright © 2016年 dianwoda. All rights reserved.
//

#import "DWDUncaughtExceptionHandler.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import "DWDTrackingUserStepsManager.h"
#import "NSString+DWDDevice.h"
@implementation DWDUncaughtExceptionHandler

+(void)dwd_installUncaughtExceptionHandler
{
    
    NSSetUncaughtExceptionHandler(&dwd_handleException);
}


@end

void dwd_handleException(NSException *exception)
{
    
    //截屏保存
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screnshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *screenshotPNG = UIImagePNGRepresentation(screnshot);//保存
    NSError *error = nil;
    //获得文件路径
    NSArray *pahts = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [pahts objectAtIndex:0];
    NSString *pngPath = [documentsPath stringByAppendingPathComponent:@"screenshot.png"];
    
    [screenshotPNG writeToFile: pngPath options: NSAtomicWrite error: &error];//写入沙盒
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];//手机型号
    //    NSString *platform = @"iPhone";
    
    if ([platform isEqualToString:@"iPhone1,1"])    platform = @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    platform = @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    platform = @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    platform = @"iPhone 4 (GSM)";
    if ([platform isEqualToString:@"iPhone3,2"])    platform = @"iPhone 4 (GSM Rev A)";
    if ([platform isEqualToString:@"iPhone3,3"])    platform = @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    platform = @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    platform = @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    platform = @"iPhone 5 (Global)";
    if ([platform isEqualToString:@"iPhone5,3"])    platform = @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    platform = @"iPhone 5c (Global)";
    if ([platform isEqualToString:@"iPhone6,1"])    platform = @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    platform = @"iPhone 5s (Global)";
    if ([platform isEqualToString:@"iPhone7,1"])    platform = @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    platform = @"iPhone 6";
    
    NSString *version = [[UIDevice currentDevice] systemVersion];//系统版本
    
    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
    NSString *reason = [exception reason];//非常重要，就是崩溃的原因
    NSString *name = [exception name];//异常类型
    NSString *screenScale = [NSString screenScale]; // 分辨率
    NSString *appStoreVersion = [NSString deviceVersion]; // app版本号
    NSString *nettype = [NSString networktype];
    NSString *carrierName = [NSString getcarrierName];
    NSString *currentBatteryLevel = [NSString getCurrentBatteryLevel];
    NSString *wifiName = [NSString wifiName];
    NSString *memorySize = [NSString memorySize];
    NSString *diskSize = [NSString diskSize];
    NSString *jailBreak = [NSString jailBreak];
    
    NSString *crashLogInfo = [NSString stringWithFormat:@"exception \n 机型 : %@ \n 分辨率：%@ \n app版本号：%@ \n 系统版本 : %@ \n 网络类型：%@ \n WIFI名称：%@ \n 运营商名称：%@ \n 电量：%@ \n 内存：%@ \n 磁盘：%@ \n 是否越狱：%@\n 异常类型 : %@ \n Crash原因 : %@ \n Call stack info : %@ \n操作步骤：\n%@", platform, screenScale,appStoreVersion,version,nettype, wifiName,carrierName,currentBatteryLevel, memorySize,diskSize, jailBreak,name, reason, arr, [[DWDTrackingUserStepsManager sharedInstance] contextDescription]];
        NSString *textPath = [documentsPath stringByAppendingPathComponent:@"exception.txt"];
        [crashLogInfo writeToFile:textPath atomically:YES encoding:NSUTF8StringEncoding error:&error];

 
    
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isOver"];
//    [[NSUserDefaults standardUserDefaults] setObject:crashLogInfo forKey:@"crashString"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
