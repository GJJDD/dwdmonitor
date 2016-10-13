//
//  DWDTrackingUserStepsManager.m
//  dwdmonitor
//
//  Created by dianwoda on 16/9/29.
//  Copyright © 2016年 dianwoda. All rights reserved.
//

#import "DWDTrackingUserStepsManager.h"


static DWDTrackingUserStepsManager *trackingUserStepsManager = nil;

@implementation DWDTrackingUserStepsManager


- (NSDictionary *)userStepDescDict
{
    if (!_userStepDescDict) {
        _userStepDescDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UserStepDesc" ofType:@"plist"]];
    }
    return _userStepDescDict;
}

+ (DWDTrackingUserStepsManager *)sharedInstance
{
    @synchronized(self){
        if (nil == trackingUserStepsManager){
            trackingUserStepsManager = [[DWDTrackingUserStepsManager alloc] init];
        }
    }
    return trackingUserStepsManager;
}



- (NSString *)contextDescription
{
    NSMutableString *userSteps = [NSMutableString string];
    
    for (NSString *userStep in self.tarckimgUserStepsArray) {
        [userSteps appendString:[NSString stringWithFormat:@"%@\n", userStep]];
    }
    
    return userSteps;
}

#pragma mark - 懒加载
- (NSMutableArray *)tarckimgUserStepsArray
{
    if (!_tarckimgUserStepsArray) {
        _tarckimgUserStepsArray = [NSMutableArray array];
    }
    
    return _tarckimgUserStepsArray;
}
- (NSMutableDictionary *)userDataCountDict
{
    if (!_userDataCountDict) {
        _userDataCountDict = [NSMutableDictionary dictionary];
    }
    
    return _userDataCountDict;
}

@end
