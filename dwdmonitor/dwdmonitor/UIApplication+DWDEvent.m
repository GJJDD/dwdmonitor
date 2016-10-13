//
//  UIApplication+DWDEvent.m
//  dwdmonitor
//
//  Created by dianwoda on 16/9/29.
//  Copyright © 2016年 dianwoda. All rights reserved.
//

#import "UIApplication+DWDEvent.h"
#import "DWDRuntimeMethod.h"
#import "DWDTrackingUserStepsManager.h"
#import "DWDUserSteps.h"
#import "NSString+DWDDate.h"
#import "NSString+DWDDevice.h"
#import <objc/runtime.h>
#import <objc/message.h>

static const void *isCountKey = &isCountKey;
@implementation UIApplication (DWDEvent)
@dynamic isCount;




- (NSNumber *)isCount
{
    return objc_getAssociatedObject(self, isCountKey);
}

- (void)setIsCount:(NSNumber *)isCount
{
    
     objc_setAssociatedObject(self, isCountKey, isCount, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (void)dwd_registerSwizzleMethods {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL sendActionSEL = @selector(sendAction:to:from:forEvent:);
        SEL dwd_sendActionSEL = @selector(dwd_sendAction:to:from:forEvent:);
        [DWDRuntimeMethod extendMethodsOriSEL:sendActionSEL andCusSEL:dwd_sendActionSEL andSelfClass:self];
        
        
        SEL sendEventSEL = @selector(sendEvent:);
        SEL dwd_sendEventSEL = @selector(dwd_sendEvent:);
        [DWDRuntimeMethod extendMethodsOriSEL:sendEventSEL andCusSEL:dwd_sendEventSEL andSelfClass:self];
    });
}




- (BOOL)dwd_sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event {
    
     NSLog(@"%@", target);
    // {"viewController_click:":{"counts":@(10), "desc":"这是一个订单详情页面","riderId":11,"cityid":1,"deviceid":1}, "viewController_xxx:":{"counts":@(14), "desc":"这是一个个人中心页面"}]
//    NSLog(@"%@----------%@-------------%@", [sender class],NSStringFromSelector(action), [target class]);
    // 记录target和action
    DWDTrackingUserStepsManager *trackingUserStepsManager = [DWDTrackingUserStepsManager sharedInstance];
    NSString *userSteps = [NSString stringWithFormat:@"操作时间：%@，操作类名：%@，操作方法：%@，操作前内存：%@", [NSString dateWithTimeInterval:event.timestamp],[target class],NSStringFromSelector(action), [NSString usedMemorySize]];
//    DWDUserSteps *userSteps = [[DWDUserSteps alloc] initWithActionName:[NSString stringWithFormat:@"%@", NSStringFromSelector(action)] andTarget:[NSString stringWithFormat:@"%@",  [target class]] andStepsTime:[NSString dateWithTimeInterval:event.timestamp]];
    [trackingUserStepsManager.tarckimgUserStepsArray addObject:userSteps];
    
    [self countEventWithTarget:target andAction:action andManager:trackingUserStepsManager];

    
    return [self dwd_sendAction:action to:target from:sender forEvent:event];
}


- (void)dwd_sendEvent:(UIEvent *)event
{
    
    [self eventCount:event];

    return [self dwd_sendEvent:event];
}


- (void)eventCount:(UIEvent *)event;
{
    if (self.isCount.boolValue) {
        UITouch *touch = [[event allTouches] anyObject];
        UIGestureRecognizer *gestureRecognizer = [touch.gestureRecognizers firstObject];
        if (gestureRecognizer) {
            id target = [[gestureRecognizer valueForKeyPath:@"_targets"] firstObject];
            id targetVc = [target valueForKeyPath:@"_target"];
            UIView *view = [gestureRecognizer valueForKeyPath:@"_view"];
//            NSString *action = NSStringFromSelector((__bridge void *)[target performSelector:@selector(action)]);
            
            DWDTrackingUserStepsManager *trackingUserStepsManager = [DWDTrackingUserStepsManager sharedInstance];
            [self countEventWithTarget:targetVc andAction:(__bridge void *)[target performSelector:@selector(action)] andManager:trackingUserStepsManager];
        }
        
    }
    self.isCount = [NSNumber numberWithBool:!self.isCount.boolValue];
   
    
    
}



// 统计事件
- (void)countEventWithTarget:(id)target andAction:(SEL)action andManager:(DWDTrackingUserStepsManager *)trackingUserStepsManager
{
    
//    NSString *key = [NSString stringWithFormat:@"%@_%@", [target class],NSStringFromSelector(action)];
    
    NSString *merhoddesc = trackingUserStepsManager.userStepDescDict[[NSString stringWithFormat:@"%@", [target class]]][NSStringFromSelector(action)][@"desc"];
    NSString *vcdesc = trackingUserStepsManager.userStepDescDict[[NSString stringWithFormat:@"%@", [target class]]][@"desc"];
    NSLog(@"%@", merhoddesc);
    if (merhoddesc!=nil && ![merhoddesc isEqualToString:@""]) {
        
        NSMutableDictionary *vcUserDatadict = trackingUserStepsManager.userDataCountDict[[NSString stringWithFormat:@"%@", [target class]]];
        if (vcUserDatadict!=nil) {
            NSMutableDictionary *methodDict = vcUserDatadict[NSStringFromSelector(action)];
            if (methodDict!=nil) {
                int counts = [methodDict[@"counts"] intValue];
                counts++;
                methodDict[@"counts"] = @(counts);
            } else {
                
                [trackingUserStepsManager.userDataCountDict[[NSString stringWithFormat:@"%@", [target class]]] setObject:[NSMutableDictionary dictionaryWithDictionary:@{@"desc":merhoddesc,@"counts":@(1)}] forKey:NSStringFromSelector(action)];
//                methodDict =[NSMutableDictionary dictionaryWithDictionary:@{@"desc":merhoddesc,@"counts":@(1)}];
            }
        } else {
            
            
            [trackingUserStepsManager.userDataCountDict setObject:[NSMutableDictionary dictionaryWithDictionary:@{@"desc":vcdesc}] forKey:[NSString stringWithFormat:@"%@", [target class]]];
     
            [trackingUserStepsManager.userDataCountDict[[NSString stringWithFormat:@"%@", [target class]]] setObject:[NSMutableDictionary dictionaryWithDictionary:@{@"desc":merhoddesc,@"counts":@(1)}] forKey:NSStringFromSelector(action)];
        }
    }
    

}

@end
