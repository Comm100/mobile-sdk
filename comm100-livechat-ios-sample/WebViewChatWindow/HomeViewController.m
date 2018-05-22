//
//  HomeViewController.m
//  WebViewChatWindow
//
//  Created by Allon on 5/27/15.
//  Copyright (c) 2015 Allon. All rights reserved.

//

#import "HomeViewController.h"
#import "UINavModalWebView.h"
#import <VisitorClient/VisitorClientController.h>

@implementation HomeViewController

-(void) viewDidLoad{
    [self setTitle:@"Comm100 Live Chat Client Demo"];
}

-(IBAction)startChat:(id)sender{
    
    // please replace your own siteId & planId
    NSString * chatUrl = @"https://chatserver.comm100.com/chatwindowmobile.aspx?siteId=10000&planId=5000239";
    
    VisitorClientController * visitorClient = [[VisitorClientController alloc] initWithChatUrl:chatUrl];
    
    /* ## System Fields ##
     *  You should use type to indentify the system fields. The following are the system fields type that we support:
     *
     *  "name": Name field
     *  "email": Email field
     *  "phone": Phone field
     *  "company": Company field
     *  "product": Product and Service field
     *  "department": Department field
     *  "ticket": Ticket field
     */
    Field * name = [[Field alloc] initWithType:@"name" value:@"name-allon2233"];
    Field * email = [[Field alloc] initWithType:@"email" value:@"email-allon2233@email.com"];
    
    /* ## Custom Fields ##
     *  For custom fields you should use field label to identify. This is the field name you defined in prechat.
     */
    Field * account = [[Field alloc] initWithLabel:@"Account" value:@"allon account"];
    
    // fill prechat form and skip (auto submit) these in chat window.
    [visitorClient fillingPrechat:@[name, email, account] isSkip:YES];
    
    UINavModalWebView * navController = [[UINavModalWebView alloc] initWithRootViewController:visitorClient];
    
    visitorClient.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(BACK:)];
    
    visitorClient.navigationItem.title = @"Chat";
    
    [self presentViewController:navController animated:true completion:nil];
    
}

-(void) BACK:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
