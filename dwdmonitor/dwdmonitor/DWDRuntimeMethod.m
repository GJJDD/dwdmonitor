//
//  DWDRuntimeMethod.m
//  dwdmonitor
//
//  Created by dianwoda on 16/10/12.
//  Copyright © 2016年 dianwoda. All rights reserved.
//

#import "DWDRuntimeMethod.h"
#import <objc/runtime.h>
#import <objc/message.h>
@implementation DWDRuntimeMethod
+ (void)extendMethodsOriSEL:(SEL)oriSEL andCusSEL:(SEL)cusSEL andSelfClass:(Class)selfClass
{
//    Class selfClass = [self class];
    Method oriMethod = class_getInstanceMethod(selfClass, oriSEL);
    Method cusMethod = class_getInstanceMethod(selfClass, cusSEL);
    BOOL addSucc = class_addMethod(selfClass, oriSEL, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
    if (addSucc) {
        class_replaceMethod(selfClass, cusSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    }else {
        method_exchangeImplementations(oriMethod, cusMethod);
    }
    
}
@end
