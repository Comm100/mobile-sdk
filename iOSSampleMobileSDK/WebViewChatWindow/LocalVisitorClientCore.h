//
//  VisitorClientCore.h
//  WebViewChatWindow
//
//  Created by Allon on 2018/5/23.
//  Copyright © 2018 Allon. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LocalVisitorClientCore : NSObject

+ (LocalVisitorClientCore *) sharedVisitorClientCore;

-(void) chatReadyWithServer:(NSString *)server siteId:(int)siteId guid:(NSString *)guid;

-(void) setRemoteNotificationDeviceId:(NSString *)deviceId thirdDeviceId:(NSString *)thirdDeviceId isDebug:(BOOL)isDebug;

-(void) useAPNS:(BOOL)use;

-(void) registerRemoteNotification;

-(void) unregisterRemoteNotification;

@end
