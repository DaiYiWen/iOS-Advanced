//
//  UIViewController+Swizzling.m
//  Runtime应用
//
//  Created by admin on 2020/9/1.
//  Copyright © 2020 admin. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>

//  Method Swizzling 方案 B
typedef IMP *IMPPointer;

// 交换方法函数
static void MethodSwizzle(id self, SEL _cmd, id arg1);
// 原始方法函数指针
static void (*MethodOriginal)(id self, SEL _cmd, id arg1);

// 交换方法函数
static void MethodSwizzle(id self, SEL _cmd, id arg1) {
    
    // 在这里添加 交换方法的相关代码
    NSLog(@"swizzledFunc");
    
    MethodOriginal(self, _cmd, arg1);
}

BOOL class_swizzleMethodAndStore(Class class, SEL original, IMP replacement, IMPPointer store) {
    IMP imp = NULL;
    Method method = class_getInstanceMethod(class, original);
    if (method) {
        const char *type = method_getTypeEncoding(method);
        imp = class_replaceMethod(class, original, replacement, type);
        if (!imp) {
            imp = method_getImplementation(method);
        }
    }
    if (imp && store) { *store = imp; }
    return (imp != NULL);
}


@implementation UIViewController (Swizzling)


//  Method Swizzling 方案 A


//// 交换 原方法 和 替换方法 的方法实现
//+ (void)load {
//
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        // 当前类
//        Class class = [self class];
//
//        // 原方法名 和 替换方法名
//        SEL originalSelector = @selector(originalFunction);
//        SEL swizzledSelector = @selector(swizzledFunction);
//
//        // 原方法结构体 和 替换方法结构体
//        Method originalMethod = class_getInstanceMethod(class, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//
//        /* 如果当前类没有 原方法的 IMP，说明在从父类继承过来的方法实现，
//         * 需要在当前类中添加一个 originalSelector 方法，
//         * 但是用 替换方法 swizzledMethod 去实现它
//         */
//        BOOL didAddMethod = class_addMethod(class,
//                                            originalSelector,
//                                            method_getImplementation(swizzledMethod),
//                                            method_getTypeEncoding(swizzledMethod));
//
//        if (didAddMethod) {
//            // 原方法的 IMP 添加成功后，修改 替换方法的 IMP 为 原始方法的 IMP
//            class_replaceMethod(class,
//                                swizzledSelector,
//                                method_getImplementation(originalMethod),
//                                method_getTypeEncoding(originalMethod));
//        } else {
//            // 添加失败（说明已包含原方法的 IMP），调用交换两个方法的实现
//            method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
//    });
//}
//
//// 原始方法
//- (void)originalFunction {
//    NSLog(@"originalFunction");
//}
//
//// 替换方法
//- (void)swizzledFunction {
//    NSLog(@"swizzledFunction");
//}

//Method Swizzling 方案 B


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzle:@selector(originalFunc) with:(IMP)MethodSwizzle store:(IMP *)&MethodOriginal];
    });
}

+ (BOOL)swizzle:(SEL)original with:(IMP)replacement store:(IMPPointer)store {
    return class_swizzleMethodAndStore(self, original, replacement, store);
}

// 原始方法
- (void)originalFunc {
    NSLog(@"originalFunc");
    
}

@end
