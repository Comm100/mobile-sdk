//
//  HomeViewController.m
//  WebViewChatWindow
//
//  Created by Allon on 5/27/15.
//  Copyright (c) 2015 Allon. All rights reserved.
//

#import <VisitorClient/VisitorClientController.h>
#import "HomeViewController.h"

@implementation HomeViewController

-(void) viewDidLoad{
    [self setTitle:@"Comm100 Live Chat Client Demo"];
}

-(IBAction)startChat:(id)sender{
    NSString * chatUrl = @"https://chatserver.comm100.com/chatwindowmobile.aspx?siteId=10000&planId=5000239";
    
    VisitorClientController * visitorClient = [[VisitorClientController alloc] initWithChatUrl:chatUrl];
    
    [self.navigationController pushViewController:visitorClient animated:YES];
    
}

@end
