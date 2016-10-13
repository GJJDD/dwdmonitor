//
//  DWDMonitorMemoryManager.h
//  dwdmonitor
//
//  Created by dianwoda on 16/10/9.
//  Copyright © 2016年 dianwoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWDMonitorMemoryManager : NSObject
+ (DWDMonitorMemoryManager *)sharedInstance;
@property (nonatomic, strong) NSMutableArray *monitorMemoryList;
@end
