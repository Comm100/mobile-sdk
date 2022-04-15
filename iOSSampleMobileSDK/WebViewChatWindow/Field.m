//
//  Field.m
//  WebViewChatWindow
//
//  Created by Allon on 2018/5/23.
//  Copyright © 2018 Allon. All rights reserved.
//

#import "Field.h"

@implementation Field

-(id) initWithType:(NSString *)type value:(NSString *)value {
    self = [super init];
    
    if(self){
        self.type = type;
        self.value = value;
    }
    return self;
}

-(id) initWithLabel:(NSString *)label value:(NSString *)value {
    self = [super init];
    
    if(self){
        self.label = label;
        self.value = value;
    }
    return self;
}

@end
