//
//  AYSNSWeiboFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 3/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSNSWeiboFacade.h"
#import "WeiboSDK.h"
// weibo sdk
#import "WBHttpRequest+WeiboUser.h"
#import "WBHttpRequest+WeiboShare.h"

@interface AYSNSWeiboFacade () <WeiboSDKDelegate>

@end

@implementation AYSNSWeiboFacade {
    NSString* wbCurrentUserID;
    NSString* wbtoken;
}

#pragma mark -- weibo delegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)loginSuccessWithWeiboAsUser:(NSString*)weibo_user_id withToken:(NSString*)weibo_token {
    NSLog(@"wei bo login success");
    NSLog(@"login as user: %@", weibo_user_id);
    NSLog(@"login with token: %@", weibo_token);
    /**
     *  1. get user email in weibo profle
     */
//    [WBHttpRequest requestForUserProfile:weibo_user_id withAccessToken:weibo_token andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
//
//        NSLog(@"begin get user info from weibo");
//        NSString *title = nil;
//        UIAlertView *alert = nil;
//        
//        if (error) {
//            title = NSLocalizedString(@"请求异常", nil);
//            alert = [[UIAlertView alloc] initWithTitle:title
//                                               message:[NSString stringWithFormat:@"%@",error]
//                                              delegate:nil
//                                     cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                     otherButtonTitles:nil];
//            [alert show];
//        } else {
//            /**
//             *  2. sent user screen name to server and create auth_token
//             */
//            WeiboUser* user = (WeiboUser*)result;
//            NSString* screen_name = user.screenName;
//            NSLog(@"user name is %@", screen_name);
//            
//            /**
//             *  3. save auth_toke and weibo user profile in local DB
//             */
//            //            _current_user = [self sendAuthProvidersName:@"weibo" andProvideUserId:weibo_user_id andProvideToken:weibo_token andProvideScreenName:screen_name];
//            _reg_user = [self sendAuthProvidersName:@"weibo" andProvideUserId:weibo_user_id andProvideToken:weibo_token andProvideScreenName:screen_name];
//            NSLog(@"new user token %@", _reg_user.who.auth_token);
//            NSLog(@"new user id %@", _reg_user.who.user_id);
//            NSLog(@"new user photo %@", _reg_user.who.screen_image);
//            
//            if (_reg_user.who.screen_image == nil || [_reg_user.who.screen_image isEqualToString:@""]) {
//                
//                NSData* data = [RemoteInstance remoteDownDataFromUrl:[NSURL URLWithString:user.profileImageUrl]];
//                UIImage* img = [UIImage imageWithData:data];
//                
//                NSString* img_name = [TmpFileStorageModel generateFileName];
//                [TmpFileStorageModel saveToTmpDirWithImage:img withName:img_name];
//                _reg_user.who.screen_image = img_name;
//                
//                dispatch_queue_t aq = dispatch_queue_create("weibo profile img queue", nil);
//                dispatch_async(aq, ^{
//                    if (img) {
//                        dispatch_queue_t post_queue = dispatch_queue_create("post queue", nil);
//                        dispatch_async(post_queue, ^(void){
//                            [RemoteInstance uploadPicture:img withName:img_name toUrl:[NSURL URLWithString:[POST_HOST_DOMAIN stringByAppendingString:POST_UPLOAD]] callBack:^(BOOL successs, NSString *message) {
//                                if (successs) {
//                                    NSLog(@"post image success");
//                                } else {
//                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//                                    [alert show];
//                                }
//                            }];
//                        });
//                        
//                        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//                        [dic setValue:_reg_user.who.auth_token forKey:@"auth_token"];
//                        [dic setValue:_reg_user.who.user_id forKey:@"user_id"];
//                        [dic setValue:img_name forKey:@"screen_photo"];
//                        [self updateUserProfile:[dic copy]];
//                    }
//                });
//            }
//            
//            /**
//             *  4. push notification to the controller
//             *      and controller to refresh the view
//             */
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [_doc.managedObjectContext save:nil];
//                NSLog(@"end get user info from weibo");
//                [[NSNotificationCenter defaultCenter] postNotificationName:kDongDaNotificationkeySNSLoginSuccess object:nil];
//            });
//        }
//    }];
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = NSLocalizedString(@"发送结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            wbCurrentUserID = userID;
        }
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        /**
         * auth response
         * if success throw the user id and the token to the login model
         * otherwise show error message
         */
        if (response.statusCode == 0) { // success
//            [self loginSuccessWithWeiboAsUser:[(WBAuthorizeResponse *)response userID] withToken:[(WBAuthorizeResponse *)response accessToken]];
        } else {
            NSString *title = @"weibo auth error";
            
            NSString *message = [NSString stringWithFormat: @"some thing wrong, and error code is %ld", (long)response.statusCode];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"cancel"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else if ([response isKindOfClass:WBPaymentResponse.class])
    {
        NSString *title = NSLocalizedString(@"支付结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.payStatusCode: %@\nresponse.payStatusMessage: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBPaymentResponse *)response payStatusCode], [(WBPaymentResponse *)response payStatusMessage], NSLocalizedString(@"响应UserInfo数据", nil),response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([response isKindOfClass:WBSDKAppRecommendResponse.class]) {
        
        NSString *title = @"推荐结果";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:[NSString stringWithFormat:@"response %@", ((WBSDKAppRecommendResponse*)response)]
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}
@end
