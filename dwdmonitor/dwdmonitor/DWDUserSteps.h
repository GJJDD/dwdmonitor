//
//  DWDUserSteps.h
//  dwdmonitor
//
//  Created by dianwoda on 16/9/29.
//  Copyright © 2016年 dianwoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWDUserSteps : NSObject

@property (nonatomic, copy) NSString *actionName;
@property (nonatomic, copy) NSString *target;
@property (nonatomic, copy) NSString *stepsTime;
- (instancetype)initWithActionName:(NSString *)actionName andTarget:(NSString *)target andStepsTime:(NSString *)stepsTime;

@end
