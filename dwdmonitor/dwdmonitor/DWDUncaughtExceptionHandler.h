//
//  DWDUncaughtExceptionHandler.h
//  dwdmonitor
//
//  Created by dianwoda on 16/9/29.
//  Copyright © 2016年 dianwoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWDUncaughtExceptionHandler : NSObject
+(void)dwd_installUncaughtExceptionHandler;
@end
void dwd_handleException(NSException *exception);
