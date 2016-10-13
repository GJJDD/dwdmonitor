//
//  AppDelegate.m
//  dwdmonitor
//
//  Created by dianwoda on 16/9/29.
//  Copyright © 2016年 dianwoda. All rights reserved.
//

#import "AppDelegate.h"
#import "UIApplication+DWDEvent.h"
#import "DWDUncaughtExceptionHandler.h"
#import "DWDMonitorMemoryManager.h"
#import "UIViewController+DWDRetention.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    [UIApplication dwd_registerSwizzleMethods];
    [UIViewController dwd_registerSwizzleMethods];
    [DWDUncaughtExceptionHandler dwd_installUncaughtExceptionHandler];
    [DWDMonitorMemoryManager sharedInstance];
    return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"要挂了么");
}

@end
