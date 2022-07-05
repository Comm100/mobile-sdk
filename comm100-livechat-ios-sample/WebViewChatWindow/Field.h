//
//  Field.h
//  WebViewChatWindow
//
//  Created by Allon on 2018/5/23.
//  Copyright © 2018 Allon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Field : NSObject

@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * label;
@property (nonatomic, copy) NSString * value;

-(id) initWithType:(NSString *)type value:(NSString *)value;
-(id) initWithLabel:(NSString *)label value:(NSString *)value;

@end
