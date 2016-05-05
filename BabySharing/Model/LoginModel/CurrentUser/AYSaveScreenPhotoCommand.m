//
//  AYSaveScreenPhotoCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 5/5/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSaveScreenPhotoCommand.h"
#import "AYCommandDefines.h"
#import "AYNotifyDefines.h"
#import "AYFactoryManager.h"

#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"

#import "AYModelFacade.h"
#import "AYModel.h"

@implementation AYSaveScreenPhotoCommand


@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    /**
     * 1. xml 下找到 LOGINMODEL
     * 2. 添加一个Command 叫什么随便，功能如下
     *     2.1  读取当前user（CurrentToken） （已有）
     *     2.2  拿到当前user的LoginToken
     *     2.3  修改LoginToken中screen_image值（值为screen_photo）
     *     2.4  保存context
     * 3. 返回打印log
     */
    NSDictionary* dic = (NSDictionary*)*obj;
//    NSString* screen_photo = [(NSDictionary*)*obj objectForKey:@"screenImageKey"];
    
    AYModelFacade* f = LOGINMODEL;
    CurrentToken* tmp = [CurrentToken enumCurrentLoginUserInContext:f.doc.managedObjectContext];
    NSString* user_id = tmp.who.user_id;
    
//    LoginToken* login_token = tmp.who;
//    login_token.screen_image = screen_photo;
    
    LoginToken* token = [LoginToken createTokenInContext:f.doc.managedObjectContext withUserID:user_id andAttrs:dic];
    
    [CurrentToken changeCurrentLoginUser:token inContext:f.doc.managedObjectContext];
    [f.doc.managedObjectContext save:nil];
    
    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
    [notify setValue:kAYCurrentLoginUserChanged forKey:kAYNotifyFunctionKey];
    
    NSMutableDictionary* cur = [[NSMutableDictionary alloc]initWithCapacity:1];
    
    [cur setValue:tmp.who.screen_image forKey:@"screen_photo"];
    
    [notify setValue:[cur copy] forKey:kAYNotifyArgsKey];
    AYModel* m = MODEL;
    [m performWithResult:&notify];
    
    
//    *obj = [cur copy];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end