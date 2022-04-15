//
//  AppDelegate.h
//  WebViewChatWindow
//
//  Created by Allon on 5/14/15.
//  Copyright (c) 2015 Allon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(NSString *) apnsDeviceId;
+(NSString *) thirdDeviceId;
+(void) setIsUseAPNS:(BOOL)isUseAPNS;

@end

