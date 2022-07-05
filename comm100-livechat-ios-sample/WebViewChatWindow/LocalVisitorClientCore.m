//
//  VisitorClientCore.m
//  WebViewChatWindow
//
//  Created by Allon on 2018/5/23.
//  Copyright © 2018 Allon. All rights reserved.
//

#import "LocalVisitorClientCore.h"

@interface LocalVisitorClientCore(){
    
}

@property (nonatomic, copy) NSString * server;
@property (nonatomic) int siteId;
@property (nonatomic, copy) NSString * guid;
@property (nonatomic) BOOL chatReady;
@property (nonatomic, copy) NSString * deviceId;
@property (nonatomic, copy) NSString * thirdDeviceId;
@property (nonatomic) BOOL isUseAPNS;
@property (nonatomic) BOOL isDebug;
@property (nonatomic) BOOL isNeedPush;

@end

static LocalVisitorClientCore * instance = nil;

@implementation LocalVisitorClientCore

+ (LocalVisitorClientCore *) sharedVisitorClientCore {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [LocalVisitorClientCore alloc];
    });
    return instance;
}

-(void) chatReadyWithServer:(NSString *)server siteId:(int)siteId guid:(NSString *)guid{
    self.server = server;
    self.siteId = siteId;
    self.guid = guid;
    self.chatReady = YES;
    if(self.deviceId != nil) {
        [self setPushConfig];
    }
    [self setNeedRemoteNotificaiton:self.isNeedPush];
}

-(void) setRemoteNotificationDeviceId:(NSString *)deviceId thirdDeviceId:(NSString *)thirdDeviceId isDebug:(BOOL)isDebug{
    self.deviceId = deviceId;
    self.thirdDeviceId = thirdDeviceId;
    self.isDebug = isDebug;
    if (self.chatReady) {
        [self setPushConfig];
    }
}

-(void) useAPNS:(BOOL)use {
    self.isUseAPNS = use;
}

-(void) registerRemoteNotification {
    self.isNeedPush = true;
    [self setNeedRemoteNotificaiton:true];
}

-(void) unregisterRemoteNotification {
    self.isNeedPush = false;
    [self setNeedRemoteNotificaiton:false];
}

-(void) setNeedRemoteNotificaiton:(BOOL)needPush {
    if(self.chatReady) {
        [self post:[NSString stringWithFormat:@"%@/visitor.ashx?siteId=%d&visitorGuid=%@", self.server, self.siteId, self.guid]
               data:@[@{
                   @"type":@"setIsNeedPush",
                   @"isNeedPush":[NSNumber numberWithBool:needPush]
                   }]];
    }
}

-(void) setPushConfig{
    [self post:[NSString stringWithFormat:@"%@/visitor.ashx?siteId=%d&visitorGuid=%@", self.server, self.siteId, self.guid]
          data: @[@{
                  @"type":@"setPushConfig",
                  @"device":@"ios",
                  @"deviceId":(self.isUseAPNS ? self.deviceId : self.thirdDeviceId),
                  @"isIosDebug":[NSNumber numberWithBool:self.isDebug],
                  }]];
}

-(void) post:(NSString *)url data:(NSArray *)data {
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    NSData * datad = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:nil];
    NSLog(@"%@", [[NSString alloc] initWithData:datad encoding:NSUTF8StringEncoding]);
    
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:nil]];
    
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * rdata, NSURLResponse * response, NSError *error){
        NSLog(@"%@", response);
        NSLog(@"%@", error);
        NSLog(@"%@", [[NSString alloc] initWithData:rdata encoding:NSUTF8StringEncoding]);
    }];
    [task resume];
}

@end
