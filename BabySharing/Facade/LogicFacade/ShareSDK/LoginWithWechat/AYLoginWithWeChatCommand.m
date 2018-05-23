//
//  AYLoginWithWeChatCommand.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/2.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYLoginWithWeChatCommand.h"
#import "AYFacade.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "AYRemoteCallCommand.h"
#import "RemoteInstance.h"
#import "AYShareFacade.h"

@implementation AYLoginWithWeChatCommand {
    
    NSString *wechatopenid;
    NSString *wechattoken;
    
}

@synthesize para = _para;

@synthesize command_type = _command_type;


- (void)performWithResult:(NSObject **)obj {
    
    AYFacade* f = FACADE(kAYFactoryManagerCommandTypeDefaultFacade, @"Share");
    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
    [notify setValue:kAYNotifyStartLogin forKey:kAYNotifyFunctionKey];
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
    [f performWithResult:&notify];
    
    NSLog(@"----------------");
    
    [ShareSDK authorize:SSDKPlatformTypeWechat settings:nil onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        
        if (state == SSDKResponseStateSuccess) {
            
            self->wechatopenid = user.uid;
            
            self->wechattoken = user.credential.token;
            
            NSLog(@"uid=%@",user.uid);
            NSLog(@"%@",user.credential);
            NSLog(@"token=%@",user.credential.token);
            NSLog(@"nickname=%@",user.nickname);
            
            //            NSString* s = [NSString stringWithFormat:@"nickname: %@ \n id : %@",user.nickname,user.uid];
            //
            //            AYShowBtmAlertView(s, BtmAlertViewTypeHideWithTimer)
            
            [self getWechatUserInfo];
            
        }else {
            
            NSLog(@"%@",error);
            
        }
        
        
    }];
    
//    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
//
//
//        
//
//    }];
    
    
    
}


- (void)getWechatUserInfo {
    // https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",wechattoken, wechatopenid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                /*
                 {
                 city = Haidian;
                 country = CN;
                 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                 language = "zh_CN";
                 nickname = "xxx";
                 openid = oyAaTjsDx7pl4xxxxxxx;
                 privilege =     (
                 );
                 province = Beijing;
                 sex = 1;
                 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                 }
                 */
                [self loginSuccessWithWeChatAsUser:self->wechatopenid accessToken:self->wechattoken infoDic:dic];
                
            }
        });
        
    });
}

- (void)loginSuccessWithWeChatAsUser:(NSString *)whchat_openID accessToken:(NSString*)accessToken infoDic:(NSDictionary *)infoDic {
    // 保存 accessToken 和 qq_openID 到本地 coreData 和服务器
    NSString* screen_name = [infoDic valueForKey:@"nickname"];
    NSLog(@"user name is %@", screen_name);
    
    NSMutableDictionary *dic_authsns = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"wechat" forKey:@"provide_name"];
    [dic setValue:whchat_openID forKey:@"provide_uid"];
    [dic setValue:screen_name forKey:@"provide_screen_name"];
    [dic setValue:[infoDic objectForKey:@"headimgurl"] forKey:@"provide_screen_photo"];
    [dic setValue:accessToken forKey:@"provide_token"];
    
    [dic_authsns setValue:dic forKey:@"third"];
    
    id<AYFacadeBase> landing_facade = DEFAULTFACADE(@"LandingRemote");
    AYRemoteCallCommand* cmd_sns = [landing_facade.commands objectForKey:@"AuthWithSNS"];
    [cmd_sns performWithResult:[dic_authsns copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        NSLog(@"new user info %@", result);
        if (success) {
            
            AYFacade* f = LOGINMODEL;
            NSMutableDictionary *reVal = [[NSMutableDictionary alloc] initWithDictionary:[result objectForKey:@"user"]];
            [reVal setValue:[result objectForKey:kAYCommArgsAuthToken] forKey:kAYCommArgsToken];
//            {
//                NSDictionary* args = [reVal copy];
//
//                id<AYCommand> cmd = [f.commands objectForKey:@"ChangeRegUser"];
//                [cmd performWithResult:&args];
//            }
            
            NSString* screen_photo = [reVal objectForKey:kAYProfileArgsScreenPhoto];
            if (!screen_photo || [screen_photo isEqualToString:@""]) {
                NSData* data = [RemoteInstance remoteDownDataFromUrl:[NSURL URLWithString:[infoDic valueForKey:@"headimgurl"]]];
                UIImage* img = [UIImage imageWithData:data];
                
                screen_photo = [Tools getUUIDString];
                
                NSMutableDictionary* photo_dic = [[NSMutableDictionary alloc]initWithCapacity:3];
                [photo_dic setValue:screen_photo forKey:@"image"];
                [photo_dic setValue:img forKey:@"upload_image"];
                
                id<AYFacadeBase> up_facade = DEFAULTFACADE(@"FileRemote");
                AYRemoteCallCommand* up_cmd = [up_facade.commands objectForKey:@"UploadUserImage"];
                [up_cmd performWithResult:[photo_dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
                    if (success) {
                        //update profile screenphoto
                        NSMutableDictionary* dic_update = [[NSMutableDictionary alloc] init];
                        [dic_update setValue:[reVal objectForKey:kAYCommArgsToken] forKey:kAYCommArgsToken];
                        
                        NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
                        [condition setValue:[reVal objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
                        [dic_update setValue:condition forKey:kAYCommArgsCondition];
                        
                        NSMutableDictionary *profile = [[NSMutableDictionary alloc] init];
                        [profile setValue:screen_photo forKey:kAYProfileArgsScreenPhoto];
                        [dic_update setValue:profile forKey:@"profile"];
                        
                        id<AYFacadeBase> profileRemote = DEFAULTFACADE(@"ProfileRemote");
                        AYRemoteCallCommand* cmd_profile = [profileRemote.commands objectForKey:@"UpdateUserDetail"];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [cmd_profile performWithResult:[dic_update copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
                                if (success) {
                                    
                                    [reVal setValue:screen_photo forKey:kAYProfileArgsScreenPhoto];
                                    id tmp = [reVal copy];
                                    id<AYCommand> cmd = [f.commands objectForKey:@"ChangeRegUser"];
                                    [cmd performWithResult:&tmp];
                                    
                                    NSMutableDictionary* dic_result = [[NSMutableDictionary alloc]init];
                                    [dic_result setValue:@"wechat" forKey:@"provide_name"];
                                    [dic_result setValue:whchat_openID forKey:@"provide_user_id"];
                                    [dic_result setValue:accessToken forKey:@"provide_token"];
                                    [dic_result setValue:screen_name forKey:@"provide_screen_name"];
                                    [dic_result setValue:[reVal objectForKey:@"user_id"] forKey:kAYCommArgsUserID];    //user_id by connect
                                    
                                    id<AYCommand> cmd_provider = [f.commands objectForKey:@"ChangeSNSProviders"];
                                    [cmd_provider performWithResult:&dic_result];
                                    
                                    [reVal setValue:[NSNumber numberWithBool:NO] forKey:@"is_registered"];
                                    [self notifyLandingSNSLoginSuccessWithArgs:[reVal copy]];
                                    
                                    
                                } else {
                                    AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
                                }
                            }];
                        });
        
                    } else {
                        
                    }
                }];
            } else {
                
                id tmp = [reVal copy];
                id<AYCommand> cmd = [f.commands objectForKey:@"ChangeRegUser"];
                [cmd performWithResult:&tmp];
                
                NSMutableDictionary* dic_result = [[NSMutableDictionary alloc]init];
                [dic_result setValue:@"wechat" forKey:@"provide_name"];
                [dic_result setValue:whchat_openID forKey:@"provide_user_id"];
                [dic_result setValue:accessToken forKey:@"provide_token"];
                [dic_result setValue:screen_name forKey:@"provide_screen_name"];
                [dic_result setValue:[reVal objectForKey:@"user_id"] forKey:kAYCommArgsUserID];    //user_id by connect
                
                id<AYCommand> cmd_provider = [f.commands objectForKey:@"ChangeSNSProviders"];
                [cmd_provider performWithResult:&dic_result];
                
                [reVal setValue:[NSNumber numberWithBool:YES] forKey:@"is_registered"];
                [self notifyLandingSNSLoginSuccessWithArgs:[reVal copy]];
            }
            
        }
    }];
}

- (void)notifyLandingSNSLoginSuccessWithArgs:(NSDictionary*)args {
    
    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
    [notify setValue:kAYNotifySNSLoginSuccess forKey:kAYNotifyFunctionKey];
    
    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
    
    [AYShareFacade.sharedInstance performWithResult:&notify];
    
}

- (void)postPerform {
    
    
}
- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}

@end
