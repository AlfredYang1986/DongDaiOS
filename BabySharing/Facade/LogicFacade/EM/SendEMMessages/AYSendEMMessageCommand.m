//
//  AYSendMessageCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSendEMMessageCommand.h"
#import "GotyeOCAPI.h"

@implementation AYSendEMMessageCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    NSNumber* group_id = [dic objectForKey:@"group_id"];
    NSString* text = [dic objectForKey:@"text"];
    
    GotyeOCGroup* group = [GotyeOCGroup groupWithId:group_id.longLongValue];
    GotyeOCMessage* m = [GotyeOCMessage createTextMessage:group text:text];
    [GotyeOCAPI sendMessage:m];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
