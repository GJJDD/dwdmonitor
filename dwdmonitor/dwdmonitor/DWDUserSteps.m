//
//  DWDUserSteps.m
//  dwdmonitor
//
//  Created by dianwoda on 16/9/29.
//  Copyright © 2016年 dianwoda. All rights reserved.
//

#import "DWDUserSteps.h"

@implementation DWDUserSteps


- (instancetype)initWithActionName:(NSString *)actionName andTarget:(NSString *)target andStepsTime:(NSString *)stepsTime
{
    if (self = [super init]) {
        self.actionName = actionName;
        self.target = target;
        self.stepsTime = stepsTime;
    }
    
    return self;
}
@end
