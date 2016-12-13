//
//  AYSNSWechatFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 3/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSNSWechatFacade.h"
#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "AYFactoryManager.h"
#import "AYNotifyDefines.h"
#import "AYRemoteCallCommand.h"
#import "Tools.h"
#import "WeiboSDK.h"
#import "AYModel.h"
#import "RemoteInstance.h"
#import "TmpFileStorageModel.h"

static NSString* const kWechatID = @"wx66d179d99c9ba7d6";
static NSString* const kWechatSecret = @"469c1beed3ecaa3a836767a5999beeb1";
static NSString* const kWechatDescription = @"wechat";

@interface AYSNSWechatFacade () <WXApiDelegate>

@end

@implementation AYSNSWechatFacade {
    NSString *wechatopenid;
    NSString *wechattoken;
}

- (void)postPerform {
    [WXApi registerApp:kWechatID withDescription:kWechatDescription];
    
    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
    [notify setValue:kAYNotifyWechatAPIReady forKey:kAYNotifyFunctionKey];
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
    [self performWithResult:&notify];
}

/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req {
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode == 0) {
            [self getWeChatOpenIdWithCode:aresp.code];
        } else {
            NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
            [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
            [notify setValue:kAYNotifyEndLogin forKey:kAYNotifyFunctionKey];
            
            int code = aresp.errCode;
            [notify setValue:[NSNumber numberWithInt:code] forKey:kAYNotifyArgsKey];
            [self performWithResult:&notify];
        }
    } else if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode) {
            case WXSuccess: {
                    //服务器端查询支付通知或查询API返回的结果再提示成功
                    NSLog(@"支付成功");
                    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
                    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
                    [notify setValue:kAYNotifyWechatPaySuccess forKey:kAYNotifyFunctionKey];
                    
                    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
                    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
                    [self performWithResult:&notify];
                }
                break;
            default: {
                    NSLog(@"支付失败，retcode=%d",resp.errCode);
                    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
                    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
                    [notify setValue:kAYNotifyWechatPayFailed forKey:kAYNotifyFunctionKey];
                    
                    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
                    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
                    [self performWithResult:&notify];
                }
                break;
        }
    }
}

- (void)getWeChatOpenIdWithCode:(NSString *)code {
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",@"wx66d179d99c9ba7d6",@"469c1beed3ecaa3a836767a5999beeb1",code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                wechatopenid = [dic objectForKey:@"openid"];
                wechattoken = [dic objectForKey:@"access_token"];
                [self getWechatUserInfo];
            }
        });
    });
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
                [self loginSuccessWithWeChatAsUser:wechatopenid accessToken:wechattoken infoDic:dic];
                
            }
        });
        
    });
}

- (void)loginSuccessWithWeChatAsUser:(NSString *)whchat_openID accessToken:(NSString*)accessToken infoDic:(NSDictionary *)infoDic {
    // 保存 accessToken 和 qq_openID 到本地 coreData 和服务器
    
    /**
     *  2. sent user screen name to server and create auth_token
     */
    NSString* screen_name = [infoDic valueForKey:@"nickname"];
    NSLog(@"user name is %@", screen_name);
    
    /**
     *  3. save auth_toke and weibo user profile in local DB
     */
    id<AYFacadeBase> landing_facade = DEFAULTFACADE(@"LandingRemote");
    AYRemoteCallCommand* cmd_sns = [landing_facade.commands objectForKey:@"AuthWithSNS"];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"wechat" forKey:@"provide_name"];
    [dic setValue:screen_name forKey:@"provide_screen_name"];
    [dic setValue:@"" forKey:@"provide_screen_photo"];
    [dic setValue:whchat_openID forKey:@"provide_uid"];
    [dic setValue:accessToken forKey:@"provide_token"];
    [dic setValue:[Tools getDeviceUUID] forKey:@"uuid"];
   
    [cmd_sns performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        NSLog(@"new user info %@", result);
   
        NSMutableDictionary* reVal = [result mutableCopy];
        
//        AYModel* m = MODEL;
//        id<AYFacadeBase> f = [m.facades objectForKey:@"LoginModel"];
        id<AYFacadeBase> f = LOGINMODEL;
        id<AYCommand> cmd = [f.commands objectForKey:@"ChangeRegUser"];

        id dic = [result copy];
        [cmd performWithResult:&dic];
        NSLog(@"change tmp reg user %@", dic);
        
        NSMutableDictionary* dic_result = [[NSMutableDictionary alloc]init];
        [dic_result setValue:@"wechat" forKey:@"provide_name"];
        [dic_result setValue:whchat_openID forKey:@"provide_user_id"];
        [dic_result setValue:accessToken forKey:@"provide_token"];
        [dic_result setValue:screen_name forKey:@"provide_screen_name"];
        [dic_result setValue:[result objectForKey:@"user_id"] forKey:@"user_id"];
        
        id<AYCommand> cmd_provider = [f.commands objectForKey:@"ChangeSNSProviders"];
        [cmd_provider performWithResult:&dic_result];
        
        NSString* screen_photo = [result objectForKey:@"screen_photo"];
        
        if (screen_photo == nil || [screen_photo isEqualToString:@""]) {
            NSData* data = [RemoteInstance remoteDownDataFromUrl:[NSURL URLWithString:[infoDic valueForKey:@"headimgurl"]]];
            UIImage* img = [UIImage imageWithData:data];

            screen_photo = [TmpFileStorageModel generateFileName];
            [TmpFileStorageModel saveToTmpDirWithImage:img withName:screen_photo];

            NSMutableDictionary* photo_dic = [[NSMutableDictionary alloc]initWithCapacity:3];
            [photo_dic setValue:screen_photo forKey:@"image"];
            [photo_dic setValue:@"img_thum" forKey:@"expect_size"];
            [photo_dic setValue:img forKey:@"upload_image"];

            id<AYFacadeBase> up_facade = DEFAULTFACADE(@"FileRemote");
            AYRemoteCallCommand* up_cmd = [up_facade.commands objectForKey:@"UploadUserImage"];
            [up_cmd performWithResult:[photo_dic copy] andFinishBlack:^(BOOL success, NSDictionary * re) {
                NSLog(@"upload result are %d", success);
                NSMutableDictionary* dic_up = [[NSMutableDictionary alloc]init];
                [dic_up setValue:[result objectForKey:@"auth_token"] forKey:@"auth_token"];
                [dic_up setValue:[result objectForKey:@"user_id"] forKey:@"user_id"];
                [dic_up setValue:screen_photo forKey:@"screen_photo"];
                [reVal setValue:screen_photo forKey:@"screen_photo"];

                id<AYFacadeBase> profileRemote = DEFAULTFACADE(@"ProfileRemote");
                AYRemoteCallCommand* cmd_profile = [profileRemote.commands objectForKey:@"UpdateUserDetail"];
                [cmd_profile performWithResult:[dic_up copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
                    NSLog(@"Update user detail remote result: %@", result);
                    if (success) {
                        NSDictionary* args = [result copy];
                        id<AYCommand> cmd2 = [f.commands objectForKey:@"UpdateRegUserProfile"];
                        [cmd2 performWithResult:&args];
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"昵称设置错误" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                        [alert show];
                    }
                }];
            }];
        }
        
        /**
         *  4. push notification to the controller
         *      and controller to refresh the view
         */
        NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
        [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
        [notify setValue:kAYNotifySNSLoginSuccess forKey:kAYNotifyFunctionKey];
        
        [notify setValue:[reVal copy] forKey:kAYNotifyArgsKey];
        [self performWithResult:&notify];
    }];
}
@end
