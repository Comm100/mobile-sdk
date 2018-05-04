//
//  VisitorClientController.h
//  VisitorClient
//
//  Created by Allon on 5/26/15.
//  Copyright (c) 2015 Allon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisitorClientController : UIViewController<UIWebViewDelegate>{
}

-(id) initWithChatUrl:(NSString *)url;

@end

