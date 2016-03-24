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

@interface AYSNSWechatFacade () <WXApiDelegate>

@end

@implementation AYSNSWechatFacade {
    NSString *wechatopenid;
    NSString *wechattoken;
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
//                [self loginSuccessWithWeChatAsUser:wechatopenid accessToken:wechattoken infoDic:dic];
                
            }
        });
        
    });
}

- (void)loginSuccessWithWeChatAsUser:(NSString *)qq_openID accessToken:(NSString*)accessToken infoDic:(NSDictionary *)infoDic {
    // 保存 accessToken 和 qq_openID 到本地 coreData 和服务器
    //    _current_user = [self sendAuthProvidersName:@"wechat" andProvideUserId:qq_openID andProvideToken:accessToken andProvideScreenName:[infoDic valueForKey:@"nickname"]];
//    _reg_user = [self sendAuthProvidersName:@"wechat" andProvideUserId:qq_openID andProvideToken:accessToken andProvideScreenName:[infoDic valueForKey:@"nickname"]];
//    NSLog(@"login user id is: %@", _reg_user.who.user_id);
//    NSLog(@"login auth token is: %@", _reg_user.who.auth_token);
//    NSLog(@"login screen photo is: %@", _reg_user.who.screen_image);
//    
//    // 获取头像
//    if (_reg_user.who.screen_image == nil || [_reg_user.who.screen_image isEqualToString:@""]) {
//        NSData* data = [RemoteInstance remoteDownDataFromUrl:[NSURL URLWithString:[infoDic valueForKey:@"headimgurl"]]];
//        UIImage* img = [UIImage imageWithData:data];
//        
//        NSString* img_name = [TmpFileStorageModel generateFileName];
//        [TmpFileStorageModel saveToTmpDirWithImage:img withName:img_name];
//        _reg_user.who.screen_image = img_name;
//        
//        dispatch_queue_t aq = dispatch_queue_create("qq profile img queue", nil);
//        dispatch_async(aq, ^{
//            if (img) {
//                dispatch_queue_t post_queue = dispatch_queue_create("post queue", nil);
//                dispatch_async(post_queue, ^(void){
//                    [RemoteInstance uploadPicture:img withName:img_name toUrl:[NSURL URLWithString:[POST_HOST_DOMAIN stringByAppendingString:POST_UPLOAD]] callBack:^(BOOL successs, NSString *message) {
//                        if (successs) {
//                            NSLog(@"post image success");
//                        } else {
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//                            [alert show];
//                        }
//                    }];
//                });
//                
//                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//                [dic setValue:_reg_user.who.auth_token forKey:@"auth_token"];
//                [dic setValue:_reg_user.who.user_id forKey:@"user_id"];
//                [dic setValue:img_name forKey:@"screen_photo"];
//                [self updateUserProfile:[dic copy]];
//            }
//        });
//    }
//    
//    /**
//     *  4. push notification to the controller
//     *      and controller to refresh the view
//     */
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_doc.managedObjectContext save:nil];
//        NSLog(@"end get user info from weibo");
//        [[NSNotificationCenter defaultCenter] postNotificationName:kDongDaNotificationkeySNSLoginSuccess object:nil];
//    });
}
@end
