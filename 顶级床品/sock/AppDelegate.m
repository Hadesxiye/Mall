//
//  AppDelegate.m
//  sock
//
//  Created by 王浩祯 on 2018/3/6.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "AppDelegate.h"
#import "homeVC.h"
#import "MineVC.h"
#import "BrandVC.h"
#import "hDisplayView.h"

#define MainScreen_width  [UIScreen mainScreen].bounds.size.width//宽
#define MainScreen_height [UIScreen mainScreen].bounds.size.height//高

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[homeVC alloc]init]];

    [self.window makeKeyAndVisible];
    
    homeVC* home = [[homeVC alloc]init];
    BrandVC* brand = [[BrandVC alloc] init];
    MineVC* mine = [[MineVC alloc]init];
    
    
    //创建导航控制器
    UINavigationController* nav1 = [[UINavigationController alloc]initWithRootViewController:home];
    UINavigationController* nav2 = [[UINavigationController alloc] initWithRootViewController:brand];
    UINavigationController* nav3 = [[UINavigationController alloc]initWithRootViewController:mine];
    

    //背景色
    home.view.backgroundColor = [UIColor whiteColor];
    mine.view.backgroundColor = [UIColor whiteColor];
    brand.view.backgroundColor = [UIColor whiteColor];
    //title
    home.title = @"首页";
    brand.title = @"品牌";
    mine.title = @"我的";
    
    //tabBar
    NSArray* arr = [NSArray arrayWithObjects:nav1,nav2,nav3, nil];
    
    _tbc = [[UITabBarController alloc]init];
    
    
    _tbc.viewControllers = arr;
    
    UIImage *image1 = [[UIImage imageNamed:@"首页"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage1 = [[UIImage imageNamed:@"首页选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *image2 = [[UIImage imageNamed:@"品牌"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage2 = [[UIImage imageNamed:@"品牌选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
 
    UIImage *image3 = [[UIImage imageNamed:@"我的"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectImage3 = [[UIImage imageNamed:@"我的选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    
    [nav1 setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"首页" image:image1 selectedImage:selectImage1]];
    [nav2 setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"品牌" image:image2 selectedImage:selectImage2]];
    [nav3 setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"我的" image:image3 selectedImage:selectImage3]];
    
    
    self.window.rootViewController = _tbc;
    
    _tbc.tabBar.tintColor = [UIColor blackColor];
    
    _tbc.delegate = self;
    
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://119.148.162.231:8080/appImg/20180426164402.png"]]];
    if (image == nil) {
        hDisplayView *hvc = [[hDisplayView alloc]initWithFrame:CGRectMake(0, 0, MainScreen_width, MainScreen_height)];
    
        [self.window.rootViewController.view addSubview:hvc];
    
        [UIView animateWithDuration:0.25 animations:^{
            hvc.frame = CGRectMake(0, 0, MainScreen_width, MainScreen_height);
        }];
    }
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:YES
            advertisingIdentifier:advertisingId];
   
    //[NSThread sleepForTimeInterval:1];
    return YES;
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}



@end
