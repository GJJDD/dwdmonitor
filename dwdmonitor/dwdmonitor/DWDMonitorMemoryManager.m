//
//  DWDMonitorMemoryManager.m
//  dwdmonitor
//
//  Created by dianwoda on 16/10/9.
//  Copyright © 2016年 dianwoda. All rights reserved.
//

#import "DWDMonitorMemoryManager.h"
#import "NSString+DWDDevice.h"
#import "NSString+DWDDate.h"
static DWDMonitorMemoryManager *monitorMemoryManager = nil;
@interface DWDMonitorMemoryManager ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation DWDMonitorMemoryManager

+ (DWDMonitorMemoryManager *)sharedInstance
{
    @synchronized(self){
        if (nil == monitorMemoryManager){
            monitorMemoryManager = [[DWDMonitorMemoryManager alloc] init];
            
        }
    }
    return monitorMemoryManager;
}
- (instancetype)init
{
    if ([super init]) {
        [self startTimer];
    }
    return self;
}



- (void)startTimer
{
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(monitorMemory) userInfo:nil repeats:YES];

}


- (void)monitorMemory
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeInterval=[date timeIntervalSinceNow]/1000;
    [self.monitorMemoryList addObject:[NSString stringWithFormat:@"时间：%@，内存大小：%@",[NSString dateWithTimeInterval:timeInterval],  [NSString usedMemorySize]]];
}

- (NSMutableArray *)monitorMemoryList
{
    if (!_monitorMemoryList) {
        _monitorMemoryList = [NSMutableArray array];
    }
    
    return _monitorMemoryList;
}
@end
