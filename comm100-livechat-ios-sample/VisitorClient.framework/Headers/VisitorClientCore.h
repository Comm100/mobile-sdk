//
//  VisitorClientCore.h
//  WebViewChatWindow
//
//  Created by Allon on 2018/5/23.
//  Copyright © 2018 Allon. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VisitorClientCore : NSObject

@property (nonatomic, copy) NSString * chatUrl;

+ (VisitorClientCore *) sharedVisitorClientCore;

-(void) chatReadyWithServer:(NSString *)server siteId:(int)siteId guid:(NSString *)guid;

-(void) setRemoteNotificationDeviceId:(NSString *)deviceId isDebug:(BOOL)isDebug;

-(void) registerRemoteNotification;

-(void) unregisterRemoteNotification;

@end
