//
//  DWDTrackingUserStepsManager.h
//  dwdmonitor
//
//  Created by dianwoda on 16/9/29.
//  Copyright © 2016年 dianwoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWDTrackingUserStepsManager : NSObject
+ (DWDTrackingUserStepsManager *)sharedInstance;

@property (nonatomic, strong) NSDictionary *userStepDescDict; // 描述
@property (nonatomic,strong) NSMutableArray *tarckimgUserStepsArray;
@property (nonatomic, strong) NSMutableDictionary *userDataCountDict; // 用户数据统计
- (NSString *)contextDescription;

@end
