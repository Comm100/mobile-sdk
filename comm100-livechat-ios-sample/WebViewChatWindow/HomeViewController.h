//
//  HomeViewController.h
//  WebViewChatWindow
//
//  Created by Allon on 5/27/15.
//  Copyright (c) 2015 Allon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController{

    IBOutlet UIBarButtonItem * bbChatNow;
    
    __weak IBOutlet UISwitch *switchIsAPNS;
    __weak IBOutlet UITextView *txtServerUrl;
}

-(IBAction) startChat:(id)sender;

@end
