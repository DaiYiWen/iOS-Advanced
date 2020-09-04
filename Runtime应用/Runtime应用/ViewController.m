//
//  ViewController.m
//  Runtime应用
//
//  Created by admin on 2020/9/1.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "UIViewController+Swizzling.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //简单方法
//    [self SwizzlingMethod];
//    [self originalFunction];
//    [self swizzledFunction];
    
    //Method Swizzling 方案 A
    [self originalFunction];
    [self swizzledFunction];
    
    
    //Method Swizzling 方案 B
    
    
//    [self printUITextFieldList];
}


// 交换 原方法 和 替换方法 的方法实现
- (void)SwizzlingMethod {
    // 当前类
    Class class = [self class];
    
    // 原方法名 和 替换方法名
    SEL originalSelector = @selector(originalFunction);
    SEL swizzledSelector = @selector(swizzledFunction);
    
    // 原方法结构体 和 替换方法结构体
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // 调用交换两个方法的实现
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

//// 原始方法
//- (void)originalFunction {
//    NSLog(@"originalFunction");
//}
//
//// 替换方法
//- (void)swizzledFunction {
//    NSLog(@"swizzledFunction");
//}



// 打印成员变量列表
- (void)printIvarList {
    unsigned int count;
    
    Ivar *ivarList = class_copyIvarList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        Ivar myIvar = ivarList[i];
        const char *ivarName = ivar_getName(myIvar);
        NSLog(@"ivar(%d) : %@", i, [NSString stringWithUTF8String:ivarName]);
    }
    
    free(ivarList);
}

// 打印属性列表
- (void)printPropertyList {
    unsigned int count;
    
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSLog(@"propertyName(%d) : %@", i, [NSString stringWithUTF8String:propertyName]);
    }
    
    free(propertyList);
}

// 打印协议列表
- (void)printProtocolList {
    unsigned int count;
    
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
        NSLog(@"protocol(%d) : %@", i, [NSString stringWithUTF8String:protocolName]);
    }
    
    free(protocolList);
}

- (void)printUITextFieldList {
    unsigned int count;
    
    Ivar *ivarList = class_copyIvarList([UITextField class], &count);
    for (unsigned int i = 0; i < count; i++) {
        Ivar myIvar = ivarList[i];
        const char *ivarName = ivar_getName(myIvar);
        NSLog(@"ivar(%d) : %@", i, [NSString stringWithUTF8String:ivarName]);
    }
    
    free(ivarList);
    
    objc_property_t *propertyList = class_copyPropertyList([UITextField class], &count);
    for (unsigned int i = 0; i < count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSLog(@"propertyName(%d) : %@", i, [NSString stringWithUTF8String:propertyName]);
    }
    
    free(propertyList);
}

@end
