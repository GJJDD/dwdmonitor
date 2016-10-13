//
//  NSString+DWDDevice.m
//  dwdmonitor
//
//  Created by dianwoda on 16/9/30.
//  Copyright © 2016年 dianwoda. All rights reserved.
//

#import "NSString+DWDDevice.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <mach/mach.h>
#import <sys/mount.h>
@implementation NSString (DWDDevice)

// 屏幕分辨率
+ (NSString *)screenScale
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    //分辨率
    CGFloat scale = [UIScreen mainScreen].scale;
    
    return [NSString stringWithFormat:@"%.0f*%.0f", width*scale,height*scale];
}
// 获得设备版本号
+ (NSString *)deviceVersion
{
    return [NSString stringWithFormat:@"%@(build:%@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    
    

}


// 获得wifi名称
+ (NSString *)wifiName
{
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return nil;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}

// 获得网络类型
+ (NSString *)networktype {
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"]subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    NSString *networktype;
    switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"]integerValue]) {
        case 0:
            NSLog(@"No wifi or cellular");
            networktype = @"No wifi or cellular";
            break;
        case 1:
            NSLog(@"2G");
            networktype = @"2G";
            break;
        case 2:
            NSLog(@"3G");
             networktype = @"3G";
            break;
        case 3:
             networktype = @"4G";
            break;
        case 4:
             networktype = @"LTE";
            break;
        case 5:
            networktype = [NSString stringWithFormat:@"Wifi"];
            break;
        default:
            break;
    }
    return networktype;
}

// 获得运营商信息
+ (NSString *)getcarrierName {
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *currentCountry=[carrier carrierName];
    NSLog(@"[carrier isoCountryCode]==%@,[carrier allowsVOIP]=%d,[carrier mobileCountryCode=%@,[carrier mobileCountryCode]=%@",[carrier isoCountryCode],[carrier allowsVOIP],[carrier mobileCountryCode],[carrier mobileNetworkCode]);
    return currentCountry;
}

// 获得电量
+ (NSString *)getCurrentBatteryLevel
{
    
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    double deviceLevel = [UIDevice currentDevice].batteryLevel;
    if (deviceLevel==-1) {
        return @"100%";
    }
    return [NSString stringWithFormat:@"%.0f", deviceLevel*100];
}

// 获得总内存
+ (long long)getTotalMemorySize
{
    return [NSProcessInfo processInfo].physicalMemory;
}
// 获得剩余内存
+ (long long)getAvailableMemorySize
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    
    return ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
}


+ (NSString *)memorySize
{
 
    return [NSString stringWithFormat:@"可用内存:%@,已用内存:%@", [self fileSizeToString:[self getAvailableMemorySize]], [self fileSizeToString: [self getTotalMemorySize]-[self getAvailableMemorySize]]];
}

// 获得总磁盘
+ (long long)getTotalDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    return freeSpace;
}
// 获得可用磁盘
+ (long long)getAvailableDiskSize
{
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return freeSpace;
}
// 获得磁盘
+ (NSString *)diskSize
{
    
    return [NSString stringWithFormat:@"可用磁盘:%@,已用磁盘:%@", [self fileSizeToString:[self getAvailableDiskSize]], [self fileSizeToString: [self getTotalDiskSize]-[self getAvailableDiskSize]]];
}

// 计算磁盘空间
+ (NSString *)fileSizeToString:(unsigned long long)fileSize
{
    NSInteger KB = 1024;
    NSInteger MB = KB*KB;
    NSInteger GB = MB*KB;
    
    if (fileSize < 10)
    {
        return @"0 B";
        
    }else if (fileSize < KB)
    {
        return @"< 1 KB";
        
    }else if (fileSize < MB)
    {
        return [NSString stringWithFormat:@"%.1f KB",((CGFloat)fileSize)/KB];
        
    }else if (fileSize < GB)
    {
        return [NSString stringWithFormat:@"%.1f MB",((CGFloat)fileSize)/MB];
        
    }else
    {
        return [NSString stringWithFormat:@"%.1f GB",((CGFloat)fileSize)/GB];
    }
}

+ (NSString *)jailBreak
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        return @"已越狱";
    }
    return @"未越狱";
}

// 获取当前任务所占用的内存（单位：MB）
+ (long long)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    return taskInfo.resident_size;
}

// 使用的内存大小
+ (NSString *)usedMemorySize
{
    return [NSString fileSizeToString:[self usedMemory]];
}
@end
