//
//  AYShareWithWeiboCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/5/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYShareWithWeiboCommand.h"
#import "AYNotifyDefines.h"
#import "AYFacade.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

#import "WeiboSDK.h"
// weibo sdk
#import "WBHttpRequest+WeiboUser.h"
#import "WBHttpRequest+WeiboShare.h"

#import "Providers.h"
#import "Providers+ContextOpt.h"
#import "AYModelFacade.h"

@implementation AYShareWithWeiboCommand
//@synthesize para = _para;

//- (void)postPerform {
//
//}

//- (void)performWithResult:(NSObject**)obj {
- (void)performWithResult:(NSDictionary *)args andFinishBlack:(asynCommandFinishBlock)block {
//    NSDictionary* args = (NSDictionary*)*obj;
    
    NSDictionary* user = nil;
    CURRENUSER(user)
    NSMutableArray* dic = [user mutableCopy];
    
    AYModelFacade* fl = LOGINMODEL;
    Providers* cur = [Providers enumProvideInContext:fl.doc.managedObjectContext ByName:@"weibo" andCurrentUserID:[dic valueForKey:@"user_id"]];

    if (cur == nil) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"请先绑定微博或用微博登录" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
//        [alert show];
        block(NO, (NSDictionary*)@"weibo not authorization");
        
    } else {
        dispatch_queue_t wb_query_queue = dispatch_queue_create("wb share queus", nil);
        dispatch_async(wb_query_queue, ^{
            WBImageObject* img_obj = [WBImageObject object];
            img_obj.imageData = UIImagePNGRepresentation([args objectForKey:@"image"]);
            [WBHttpRequest requestForShareAStatus:[args objectForKey:@"decs"] contatinsAPicture:img_obj orPictureUrl:nil withAccessToken:cur.provider_token andOtherProperties:nil queue:[NSOperationQueue currentQueue] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
                NSLog(@"result is %@", result);
                NSLog(@"error is %@", error.domain);
                if (error.code == 0) {
                    block(YES, result);
                } else block(NO, (NSDictionary*)error.domain);
            }];
        });
    }
}

//- (NSString*)getCommandType {
//    return kAYFactoryManagerCommandTypeModule;
//}

@end
