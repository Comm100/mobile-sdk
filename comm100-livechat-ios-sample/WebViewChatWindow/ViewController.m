//
//  ViewController.m
//  WebViewChatWindow
//
//  Created by Allon on 5/14/15.
//  Copyright (c) 2015 Allon. All rights reserved.
//

#import "ViewController.h"

//@interface UIWebView (JavaScriptAlert) <UIAlertViewDelegate>
//
//-(void) webView:(UIWebView *) sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame;
//
//@end
//
//
//@implementation UIWebView (JavaScriptAlert)
//
//-(void) webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect *)frame{
//    
//    
//    
//    UIAlertView * customAlert = [[UIAlertView alloc] initWithTitle:@"XIUPIN" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    
//    [customAlert show];
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"%@",alertView.message);
//}
//@end



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://kftest.xiupin.com/livechatserver/Mobile/chatwindow.aspx?planId=31&ifApp=1"]];
    [webView loadRequest:request];
    webView.delegate = self;
}
- (void)webViewDidStartLoad:(UIWebView *)w{
    NSString * innerHtml =[w stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('script')[0].outerHTML"];
    if([innerHtml containsString:@"留言提交成功"]){
        w.hidden = YES;
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)w{
    
    NSString * innerHtml =[w stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('script')[0].innerHTML"];
    if([innerHtml containsString:@"留言提交成功"]){
        //close comm100 chat window
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
