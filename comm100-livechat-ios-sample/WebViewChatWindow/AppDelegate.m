//
//  AppDelegate.m
//  WebViewChatWindow
//
//  Created by Allon on 5/14/15.
//  Copyright (c) 2015 Allon. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#import <VisitorClient/VisitorClientCore.h>
#endif
@interface AppDelegate () <JPUSHRegisterDelegate>

@end

@implementation AppDelegate

static NSString * _apnsDeviceId;
static NSString * _thirdDeviceId;
static BOOL _isUseAPNS = true;

+(NSString *) apnsDeviceId {
    return _apnsDeviceId;
}

+(NSString *) thirdDeviceId {
    return _thirdDeviceId;
}

+(void) setIsUseAPNS:(BOOL)isUseAPNS{
    _isUseAPNS = isUseAPNS;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
//                                                                                          | UIUserNotificationTypeSound
//                                                                                          | UIUserNotificationTypeAlert) categories:nil];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:@"dca78eb7c81e4244fb6254c0"
                          channel:@"chat_channel"
                 apsForProduction:false
            advertisingIdentifier:advertisingId];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID successed：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID failed，code：%d",resCode);
        }
    }];
    
    return YES;
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
-(void) application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}
#endif

-(void) application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken{
    
    [JPUSHService registerDeviceToken:devToken];
    
    _thirdDeviceId = [JPUSHService registrationID];
    
    NSString *devStrToken = [[NSString stringWithFormat:@"%@",devToken] stringByReplacingOccurrencesOfString:@" " withString:@""];
    int length = (int)devStrToken.length;
    _apnsDeviceId = [[devStrToken substringToIndex:length - 1] substringFromIndex:1];
    NSString * deviceId = _isUseAPNS ? _apnsDeviceId : _thirdDeviceId;
    
    [[VisitorClientCore sharedVisitorClientCore] setRemoteNotificationDeviceId:deviceId isDebug:YES];
}

-(void) application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Failed Register Remote Notification" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler: (void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
UIBackgroundTaskIdentifier bgTask;
- (void)applicationDidEnterBackground:(UIApplication *)application {
    UIApplication *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[VisitorClientCore sharedVisitorClientCore] registerRemoteNotification];
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    });
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    UIApplication *app = [UIApplication sharedApplication];
    [app setApplicationIconBadgeNumber:0];
    [app cancelAllLocalNotifications];
     [[VisitorClientCore sharedVisitorClientCore] unregisterRemoteNotification];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif

@end
