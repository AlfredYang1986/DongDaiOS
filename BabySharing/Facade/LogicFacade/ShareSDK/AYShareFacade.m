//
//  AYShareFacade.m
//  BabySharing
//
//  Created by 王坤田 on 2018/4/2.
//  Copyright © 2018 Alfred Yang. All rights reserved.
//

#import "AYShareFacade.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>



//微信SDK头文件
#import "WXApi.h"


static NSString* const kWechatID = @"wx66d179d99c9ba7d6";
static NSString* const kWechatSecret = @"469c1beed3ecaa3a836767a5999beeb1";
static NSString* const kWechatDescription = @"wechat";

static AYShareFacade* instance = nil;

@implementation AYShareFacade

+ (AYShareFacade *)sharedInstance {
    
    @synchronized (self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    return instance;
    
}


+ (id) allocWithZone:(NSZone *)zone {
    @synchronized (self) {
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}


- (void)postPerform {
    
    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
    [notify setValue:kAYNotifyWechatAPIReady forKey:kAYNotifyFunctionKey];
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
    [self performWithResult:&notify];
    
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)] onImport:^(SSDKPlatformType platformType) {
        
        switch (platformType) {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;

            default:
                break;
        }
        
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        
        switch (platformType) {
            case SSDKPlatformTypeWechat:
                
                [appInfo SSDKSetupWeChatByAppId:kWechatID appSecret:kWechatSecret];
                break;
                
            default:
                break;
        }
        
    }];
    
}

-(void)onResp:(BaseResp *)resp
{
    NSLog(@"The response of wechat.");
}

@end
