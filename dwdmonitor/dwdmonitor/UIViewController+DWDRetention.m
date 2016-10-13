//
//  UIViewController+DWDRetention.m
//  dwdmonitor
//
//  Created by dianwoda on 16/10/12.
//  Copyright © 2016年 dianwoda. All rights reserved.
//

#import "UIViewController+DWDRetention.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "DWDRuntimeMethod.h"
#import "DWDTrackingUserStepsManager.h"
@implementation UIViewController (DWDRetention)
+ (void)dwd_registerSwizzleMethods {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL sendActionSEL = @selector(viewWillAppear:);
        SEL dwd_sendActionSEL = @selector(dwd_viewWillAppear:);
        [DWDRuntimeMethod extendMethodsOriSEL:sendActionSEL andCusSEL:dwd_sendActionSEL andSelfClass:self];
        
        SEL sendEventSEL = @selector(viewDidDisappear:);
        SEL dwd_sendEventSEL = @selector(dwd_viewDidDisappear:);
        [DWDRuntimeMethod extendMethodsOriSEL:sendEventSEL andCusSEL:dwd_sendEventSEL andSelfClass:self];
        
        
    });
}



- (void)dwd_viewWillAppear:(BOOL)animated
{
    DWDTrackingUserStepsManager *trackingUserStepsManager = [DWDTrackingUserStepsManager sharedInstance];
    NSString *vcDesc = trackingUserStepsManager.userStepDescDict[[NSString stringWithFormat:@"%@", [self class]]][@"desc"];
    NSTimeInterval startTime = [self viewTimeCount:trackingUserStepsManager andVCDesc:vcDesc];
    
    if (startTime!=0) {
        
      
        
        
        // 使用时长
        NSMutableDictionary *vcUserDict =  trackingUserStepsManager.userDataCountDict[[NSString stringWithFormat:@"%@", [self class]]];
        if (vcUserDict!=nil) {
            
            // 添加页面的访问次数
            int vcCunts = [vcUserDict[@"counts"] intValue];
            
            if (vcCunts!=0) {
                
                
                int allcounts = [trackingUserStepsManager.userDataCountDict[[NSString stringWithFormat:@"%@", [self class]]][@"counts"] intValue];
                allcounts++;
                [trackingUserStepsManager.userDataCountDict[[NSString stringWithFormat:@"%@", [self class]]] setObject:@(allcounts) forKey:@"counts"];
            } else {
                // 创建
                
                [trackingUserStepsManager.userDataCountDict[[NSString stringWithFormat:@"%@", [self class]]] setObject:@(1) forKey:@"counts"];
            }
            
            NSMutableDictionary *timeDict = vcUserDict[@"viewTimes"];
            if (timeDict!=nil) {
                NSString *startTimeStr = timeDict[@"startTime"];
                
                if (startTimeStr!=nil) {
                    NSString *startTimes = [NSString stringWithFormat:@"%@,%f", timeDict[@"startTime"], startTime];
                    [timeDict setObject:startTimes forKey:@"startTime"];
                } else {
                    [trackingUserStepsManager.userDataCountDict[[NSString stringWithFormat:@"%@", [self class]]][@"viewTimes"] setObject:[NSString stringWithFormat:@"%f", startTime] forKey:@"startTime"];
                }
            } else {
                NSMutableDictionary *timeDict = [NSMutableDictionary dictionaryWithDictionary:@{@"startTime":[NSString stringWithFormat:@"%f", startTime]}];
                [trackingUserStepsManager.userDataCountDict[[NSString stringWithFormat:@"%@", [self class]]] setObject:timeDict forKey:@"viewTimes"];
            }
        } else {
            
            [trackingUserStepsManager.userDataCountDict setObject:[NSMutableDictionary dictionaryWithDictionary:@{@"desc":vcDesc}] forKey:[NSString stringWithFormat:@"%@", [self class]]];
            NSMutableDictionary *timeDict = [NSMutableDictionary dictionaryWithDictionary:@{@"startTime":[NSString stringWithFormat:@"%f", startTime]}];
            [trackingUserStepsManager.userDataCountDict[[NSString stringWithFormat:@"%@", [self class]]] setObject:timeDict forKey:@"viewTimes"];
            
            
            [trackingUserStepsManager.userDataCountDict[[NSString stringWithFormat:@"%@", [self class]]] setObject:@(1) forKey:@"counts"];
    
        }

        
    }
    
    
    return [self dwd_viewWillAppear:animated];
}

- (void)dwd_viewDidDisappear:(BOOL)animated
{
    
    DWDTrackingUserStepsManager *trackingUserStepsManager = [DWDTrackingUserStepsManager sharedInstance];
    NSString *vcDesc = trackingUserStepsManager.userStepDescDict[[NSString stringWithFormat:@"%@", [self class]]][@"desc"];
    NSTimeInterval endTime = [self viewTimeCount:trackingUserStepsManager andVCDesc:vcDesc];
    if (endTime!=0) {
      
        NSMutableDictionary *vcUserDict =  trackingUserStepsManager.userDataCountDict[[NSString stringWithFormat:@"%@", [self class]]];
        if (vcUserDict!=nil) {
            NSMutableDictionary *timeDict = vcUserDict[@"viewTimes"];
            if (timeDict!=nil) {
                NSString *endTimeStr = timeDict[@"endTime"];
                
                if (endTimeStr!=nil) {
                    NSString *endTimes = [NSString stringWithFormat:@"%@,%f", endTimeStr, endTime];
                    [timeDict setObject:endTimes forKey:@"endTime"];
                } else {
                    [trackingUserStepsManager.userDataCountDict[[NSString stringWithFormat:@"%@", [self class]]][@"viewTimes"] setObject:[NSString stringWithFormat:@"%f", endTime] forKey:@"endTime"];
                }
            } else {
                NSMutableDictionary *timeDict = [NSMutableDictionary dictionaryWithDictionary:@{@"endTime":[NSString stringWithFormat:@"%f", endTime]}];
                [trackingUserStepsManager.userDataCountDict[[NSString stringWithFormat:@"%@", [self class]]] setObject:timeDict forKey:@"viewTimes"];
            }
        } else {
            
            [trackingUserStepsManager.userDataCountDict setObject:[NSMutableDictionary dictionaryWithDictionary:@{@"desc":vcDesc}] forKey:[NSString stringWithFormat:@"%@", [self class]]];
            NSMutableDictionary *timeDict = [NSMutableDictionary dictionaryWithDictionary:@{@"endTime":[NSString stringWithFormat:@"%f", endTime]}];
            [trackingUserStepsManager.userDataCountDict[[NSString stringWithFormat:@"%@", [self class]]] setObject:timeDict forKey:@"viewTimes"];
            
        }
    }
    return [self dwd_viewDidDisappear:animated];
}


- (NSTimeInterval)viewTimeCount:(DWDTrackingUserStepsManager *)trackingUserStepsManager andVCDesc:(NSString *)vcDesc
{

    if (vcDesc!=nil) {
        // @{@"viewController":@[@{@"stratTime":11111,@"endTime":22222}, @{@"stratTime":11111,@"endTime":22222}],
//          @"HomeController":@[@{@"stratTime":11111,@"endTime":22222}, @{@"stratTime":11111,@"endTime":22222}]}
        // viewControllerName endTime startTime
        
        
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
        return interval;
        
    }

    return 0;
}

@end
