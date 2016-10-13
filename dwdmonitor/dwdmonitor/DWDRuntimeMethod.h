//
//  DWDRuntimeMethod.h
//  dwdmonitor
//
//  Created by dianwoda on 16/10/12.
//  Copyright © 2016年 dianwoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWDRuntimeMethod : NSObject
+ (void)extendMethodsOriSEL:(SEL)oriSEL andCusSEL:(SEL)cusSEL andSelfClass:(Class)selfClass;
@end
