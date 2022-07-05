//
//  WKVisitorClientController.m
//  WebViewChatWindow
//
//  Created by Allon on 2018/5/17.
//  Copyright © 2018 Allon. All rights reserved.
//

#import "WKVisitorClientController.h"
#import "Field.h"
#import "VisitorClientCustomJS.h"
#import "LocalVisitorClientCore.h"

@interface WKVisitorClientController() <WKScriptMessageHandler> {}

@end


@implementation WKVisitorClientController


-(id) initWithChatUrl:(NSString *)url{
    self = [super init];
    
    if(self){
        _chatUrl = [url copy];
        _scripts = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void) fillingPrechat:(NSArray *)fields isSkip:(BOOL)isSkip {
    [_scripts addObject:[VisitorClientCustomJS buildPrechatfillingScript:fields isSkip:isSkip]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    _chatWindow = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [_chatWindow setUIDelegate:self];
    [_chatWindow setNavigationDelegate:self];
    [_chatWindow setAlpha:1.0];
    [self.view addSubview:_chatWindow];
    
    [_chatWindow setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view" : _chatWindow}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view" : _chatWindow}]];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 25, self.view.frame.size.height / 2 - 25, 50, 50)];
    [_indicator setColor:[UIColor blackColor]];
    [_indicator startAnimating];
    [self.view addSubview:_indicator];
    
    [_indicator setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_indicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_indicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    NSURL * url = [NSURL URLWithString:_chatUrl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_chatWindow loadRequest:request];
    
    [_chatWindow.configuration.userContentController addScriptMessageHandler:self name:kChatReadyHandler];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:kChatReadyHandler]){
        LocalVisitorClientCore * core = [LocalVisitorClientCore sharedVisitorClientCore];
        [core chatReadyWithServer:[message.body objectForKey:kChatReadyInfoServer]
                           siteId:[(NSNumber *)[message.body objectForKey:kChatReadyInfoSiteId] intValue]
                             guid:[message.body objectForKey:kChatReadyInfoGuid]];
    }
}


-(void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    void (^showChatWindow)(void) = ^(void){
        [self->_chatWindow setAlpha:1.0];
        [self->_indicator setAlpha:0.0];
    };
    
    void(^stopIndicator)(BOOL) = ^(BOOL finished){
        [self->_indicator stopAnimating];
    };
    
    [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:showChatWindow completion:stopIndicator];
    
    NSMutableString * scriptBuilder = [[NSMutableString alloc] init];
    [scriptBuilder appendString:@"Comm100API.onReady = function() {"];
    if (_scripts.count > 0) {
        for(int i = 0; i < _scripts.count; i++) {
            [scriptBuilder appendString:[_scripts objectAtIndex:i]];
        }
    }
    [scriptBuilder appendString:[VisitorClientCustomJS chatReadyScript]];
    [scriptBuilder appendString:@"}"];
    
    [_chatWindow evaluateJavaScript:scriptBuilder completionHandler:nil];
}

-(void) webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSString * message = [NSString stringWithFormat:@"Error: %li: %@", (long)[error code],  [error localizedDescription]];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Fail loading chat window" message: message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSString * message = [NSString stringWithFormat:@"Error: %li: %@", (long)[error code],  [error localizedDescription]];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Fail loading chat window" message: message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"decidePolicyForNavigationResponse: %@",navigationResponse.response.URL.absoluteString);

    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"decidePolicyForNavigationAction: %@",navigationAction.request.URL.absoluteString);

    if(!navigationAction.targetFrame.isMainFrame && navigationAction.navigationType == WKNavigationTypeLinkActivated){
        NSLog(@"open in new window");
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
