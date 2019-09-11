//
//  VisitorClientCustomJS.m
//  WebViewChatWindow
//
//  Created by Allon on 2018/5/23.
//  Copyright © 2018 Allon. All rights reserved.
//

#import "VisitorClientCustomJS.h"
#import "Field.h"

@implementation VisitorClientCustomJS

+(NSString *) chatReadyScript {
    NSMutableString * scriptBuilder = [[NSMutableString alloc] init];
    
    [scriptBuilder appendString:@"var chat_ready_info = {"];
    [scriptBuilder appendFormat:@"  %@: Comm100API.get('livechat.visitor.guid'),", kChatReadyInfoGuid];
    [scriptBuilder appendFormat:@"  %@: Comm100API.main,", kChatReadyInfoServer];
    [scriptBuilder appendFormat:@"  %@: Comm100API.site_id,", kChatReadyInfoSiteId];
    [scriptBuilder appendString:@"};"];
    [scriptBuilder appendFormat:@"window.webkit.messageHandlers.%@.postMessage(chat_ready_info);", kChatReadyHandler];
    
    return scriptBuilder;
}

+ (NSString *) buildPrechatfillingScript:(NSArray *)fields isSkip:(BOOL)isSkip {
    
    NSMutableString * scriptBuilder = [[NSMutableString alloc] init];
    
    [scriptBuilder appendString:@"  var visitor_info_with_type = {};"];
    [scriptBuilder appendString:@"  var visitor_info_with_label = {};"];
    for(int i=0; i< [fields count]; i++) {
        Field * field = [fields objectAtIndex:i];
        if (field.type != nil) {
            [scriptBuilder appendFormat:@"  visitor_info_with_type['%@'] = '%@';", field.type, field.value];
        } else {
            [scriptBuilder appendFormat:@"  visitor_info_with_label['%@'] = '%@';", field.label, field.value];
        }
    }
    [scriptBuilder appendString:@"  var fields = Comm100API.get('livechat.prechat.fields', Comm100API.main_code_plan);"];
    [scriptBuilder appendString:@"  var newFields = fields.map(function(field) {"];
    [scriptBuilder appendString:@"    if(visitor_info_with_type[field.type] !== undefined) {"];
    [scriptBuilder appendString:@"      return Object.assign({}, field, { value: visitor_info_with_type[field.type] });"];
    [scriptBuilder appendString:@"    }"];
    [scriptBuilder appendString:@"    if(visitor_info_with_label[field.label] !== undefined) {"];
    [scriptBuilder appendString:@"      return Object.assign({}, field, { value: visitor_info_with_label[field.label] });"];
    [scriptBuilder appendString:@"    }"];
    [scriptBuilder appendString:@"    return field;"];
    [scriptBuilder appendString:@"  });"];
    [scriptBuilder appendString:@"  Comm100API.set('livechat.prechat.fields', newFields, Comm100API.main_code_plan);"];
    if (isSkip) {
        [scriptBuilder appendString:@"  Comm100API.set('livechat.prechat.isSkip', true);"];
    }
    
    return scriptBuilder;
}

@end
