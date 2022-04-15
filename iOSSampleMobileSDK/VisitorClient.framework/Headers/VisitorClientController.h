//
//  WKVisitorClientController.h
//  WebViewChatWindow
//
//  Created by Allon on 2018/5/17.
//  Copyright © 2018 Allon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface VisitorClientController : UIViewController <WKUIDelegate, WKNavigationDelegate>{
    WKWebView * _chatWindow;
    UIActivityIndicatorView * _indicator;
    NSString * _chatUrl;
    NSMutableArray * _scripts;
}

-(id) initWithChatUrl:(NSString *)url;

-(void) fillingPrechat:(NSArray *)fields isSkip:(BOOL)isSkip;

@end
