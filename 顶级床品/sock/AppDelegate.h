//
//  AppDelegate.h
//  sock
//
//  Created by 王浩祯 on 2018/3/6.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *appKey = @"a99ab6846e6cb30188b523cf";
static NSString *channel = @"Publish channel";
static BOOL isProduction = 1;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)UITabBarController* tbc;


@end

