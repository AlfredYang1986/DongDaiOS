//
//  AYSNSQQFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 3/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSNSQQFacade.h"
#import "AYNotifyDefines.h"
// qq sdk
#import "TencentOAuth.h"

static NSString* const kQQTencentID = @"1104831230";
static NSString* const kQQTencentPermissionUserInfo = @"get_user_info";
static NSString* const kQQTencentPermissionSimpleUserInfo = @"get_simple_userinfo";
static NSString* const kQQTencentPermissionAdd = @"add_t";

@interface AYSNSQQFacade () <TencentSessionDelegate>

@end

@implementation AYSNSQQFacade {
}

- (void)postPerform {
    _qq_oauth = [[TencentOAuth alloc] initWithAppId:kQQTencentID andDelegate:self];
    _qq_oauth.redirectURI = nil;
    _permissions =  @[kQQTencentPermissionUserInfo, kQQTencentPermissionSimpleUserInfo, kQQTencentPermissionUserInfo];
   
    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
    [notify setValue:kAYNotifyQQAPIReady forKey:kAYNotifyFunctionKey];
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
    [self performWithResult:&notify];
}

#pragma mark - qq login and call back
- (void)loginSuccessWithQQAsUser:(NSString *)qq_openID accessToken:(NSString*)accessToken infoDic:(NSDictionary *)infoDic {
    // 保存 accessToken 和 qq_openID 到本地 coreData 和服务器
    //    _current_user = [self sendAuthProvidersName:@"qq" andProvideUserId:qq_openID andProvideToken:accessToken andProvideScreenName:[infoDic valueForKey:@"nickname"]];
//    _reg_user = [self sendAuthProvidersName:@"qq" andProvideUserId:qq_openID andProvideToken:accessToken andProvideScreenName:[infoDic valueForKey:@"nickname"]];
//    NSLog(@"login user id is: %@", _reg_user.who.user_id);
//    NSLog(@"login auth token is: %@", _reg_user.who.auth_token);
//    NSLog(@"login screen photo is: %@", _reg_user.who.screen_image);
//    
//    // 获取头像
//    if (_reg_user.who.screen_image == nil || [_reg_user.who.screen_image isEqualToString:@""]) {
//        
//        NSData* data = [RemoteInstance remoteDownDataFromUrl:[NSURL URLWithString:[infoDic valueForKey:@"figureurl_qq_2"]]];
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

#pragma mark -- tencent delegate
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin {
    NSLog(@"login succss with token : %@", _qq_oauth.accessToken);
    if (_qq_oauth.accessToken && 0 != [_qq_oauth.accessToken length]) {
        //  记录登录用户的OpenID、Token以及过期时间
        NSLog(@"openId === %@", [_qq_oauth getUserOpenID]);
        NSLog(@"login succss with token : %@", _qq_oauth.accessToken);
        NSLog(@"获取用户信息 === %c", [_qq_oauth getUserInfo]);
    } else {
        NSLog(@"login error");
    }
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        NSLog(@"login user cancel");
    } else {
        NSLog(@"login failed");
    }
}

/**
 * 登录时网络有问题的回调
 */
-(void)tencentDidNotNetWork {
    NSLog(@"login with no network");
}

/**
 * 获取用户信息的回调
 */
- (void)getUserInfoResponse:(APIResponse *)response {
    if (response.retCode == URLREQUEST_SUCCEED) {
        [self loginSuccessWithQQAsUser:_qq_oauth.openId accessToken:_qq_oauth.accessToken infoDic:response.jsonResponse];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"通知" message:@"获取QQ详细信息失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
    }
}
@end
