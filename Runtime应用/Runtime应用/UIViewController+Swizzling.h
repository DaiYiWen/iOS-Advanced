//
//  UIViewController+Swizzling.h
//  Runtime应用
//
//  Created by admin on 2020/9/1.
//  Copyright © 2020 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Swizzling)

- (void)originalFunction;
- (void)swizzledFunction;

- (void)originalFunc;
@end

NS_ASSUME_NONNULL_END
