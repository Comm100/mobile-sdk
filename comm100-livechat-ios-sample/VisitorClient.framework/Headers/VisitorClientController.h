//
//  WKVisitorClientController.h
//  WebViewChatWindow
//
//  Created by Allon on 2018/5/17.
//  Copyright © 2018 Allon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface Field : NSObject

@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * label;
@property (nonatomic, copy) NSString * value;

-(id) initWithType:(NSString *)type value:(NSString *)value;
-(id) initWithLabel:(NSString *)label value:(NSString *)value;

@end

@interface VisitorClientController : UIViewController <WKUIDelegate, WKNavigationDelegate>{
    WKWebView * _chatWindow;
    UIActivityIndicatorView * _indicator;
    NSString * _chatUrl;
    NSString * _script;
}

-(id) initWithChatUrl:(NSString *)url;

-(void) fillingPrechat:(NSArray *)fields isSkip:(BOOL)isSkip;

@end
