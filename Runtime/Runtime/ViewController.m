//
//  ViewController.m
//  Runtime
//
//  Created by admin on 2020/9/1.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ViewController.h"
#include "objc/runtime.h"

@interface Person : NSObject

- (void)fun;

@end

@implementation Person

- (void)fun {
    NSLog(@"fun");
}

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 执行 fun 函数
     [self performSelector:@selector(fun)];
    
    
    //runtime基础
}

//// 重写 resolveInstanceMethod: 添加对象方法实现
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    if (sel == @selector(fun)) { // 如果是执行 fun 函数，就动态解析，指定新的 IMP
//        class_addMethod([self class], sel, (IMP)funMethod, "v@:");
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}
//
//void funMethod(id obj, SEL _cmd) {
//    NSLog(@"funMethod"); //新的 fun 函数
//}




//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    return YES; // 为了进行下一步 消息接受者重定向
//}
//
//// 消息接受者重定向
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    if (aSelector == @selector(fun)) {
//        return [[Person alloc] init];
//        // 返回 Person 对象，让 Person 对象接收这个消息
//    }
//
//    return [super forwardingTargetForSelector:aSelector];
//}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return YES; // 为了进行下一步 消息接受者重定向
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return nil; // 为了进行下一步 消息重定向
}

// 获取函数的参数和返回值类型，返回签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"fun"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    
    return [super methodSignatureForSelector:aSelector];
}

// 消息重定向
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;   // 从 anInvocation 中获取消息
    
    Person *p = [[Person alloc] init];

    if([p respondsToSelector:sel]) {   // 判断 Person 对象方法是否可以响应 sel
        [anInvocation invokeWithTarget:p];  // 若可以响应，则将消息转发给其他对象处理
    } else {
        [self doesNotRecognizeSelector:sel];  // 若仍然无法响应，则报错：找不到响应方法
    }
}

@end
