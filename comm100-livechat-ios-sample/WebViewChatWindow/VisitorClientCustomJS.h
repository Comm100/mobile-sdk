//
//  VisitorClientCustomJS.h
//  WebViewChatWindow
//
//  Created by Allon on 2018/5/23.
//  Copyright © 2018 Allon. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kChatReadyHandler @"chatOnReadyHandler"

#define kChatReadyInfoGuid @"guid"

#define kChatReadyInfoServer @"server"

#define kChatReadyInfoSiteId @"siteId"

@interface VisitorClientCustomJS : NSObject {}

extern NSString * const chatReadyHandler;

+ (NSString *)chatReadyScript;
+ (NSString *)buildPrechatfillingScript:(NSArray *)fields isSkip:(BOOL)isSkip;

@end
