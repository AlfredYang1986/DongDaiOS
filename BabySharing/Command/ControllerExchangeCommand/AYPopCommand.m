//
//  AYPopCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/29/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPopCommand.h"
#import "AYCommandDefines.h"
#import "AYControllerActionDefines.h"
#import "AYViewController.h"

@implementation AYPopCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"pop command perfrom");
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if (![[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopValue]) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"pop command 只能出来pop 操作" userInfo:nil];
    }
    
    AYViewController* source = [dic objectForKey:kAYControllerActionSourceControllerKey];
//    AYViewController* des = [dic objectForKey:kAYControllerActionDestinationControllerKey];
    
    if (source.navigationController == nil) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"pop command source controler 必须是一个navigation controller" userInfo:nil];
    }
    
//    id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
//    if (tmp != nil) {
//        NSMutableDictionary* dic_init =[[NSMutableDictionary alloc]init];
//        [dic_init setValue:kAYControllerActionInitValue forKey:kAYControllerActionKey];
//        [dic_init setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
//        [des performWithResult:&dic_init];
//    }
    
    [source.navigationController popViewControllerAnimated:YES];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
