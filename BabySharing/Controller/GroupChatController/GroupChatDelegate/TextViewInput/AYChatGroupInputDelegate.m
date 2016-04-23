//
//  AYChatGroupInputDelegate.m
//  BabySharing
//
//  Created by BM on 4/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYChatGroupInputDelegate.h"
#import "AYFactoryManager.h"

@implementation AYChatGroupInputDelegate
#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryDelegate;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

#pragma mark -- text view delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        //        GotyeOCRoom* room = [GotyeOCRoom roomWithId:_group_id.longLongValue];
//        GotyeOCGroup* group = [GotyeOCGroup groupWithId:_group_id.longLongValue];
//        GotyeOCMessage* m = [GotyeOCMessage createTextMessage:group text:textView.text];
//        [GotyeOCAPI sendMessage:m];
        
        id<AYCommand> cmd = [self.notifies objectForKey:@"sendMessage:"];
        id args = textView.text;
        [cmd performWithResult:&args];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}
@end