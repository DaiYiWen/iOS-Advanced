//
//  ViewController.m
//  内存管理
//
//  Created by admin on 2020/8/31.
//  Copyright © 2020 admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 内存暴涨
    @autoreleasepool {
        for (int i = 0; i < 99999; ++i) {
//            UIViewController *p = [[[UIViewController alloc] init] autorelease];
        }
    }
    
    // 内存不会暴涨
    for (int i = 0; i < 99999; ++i) {
        @autoreleasepool {
//            UIViewController *p = [[[UIViewController alloc] init] autorelease];
        }
    }
}


@end
