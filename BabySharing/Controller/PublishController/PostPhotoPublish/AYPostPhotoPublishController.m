//
//  AYPostPhotoPublishController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/20/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPostPhotoPublishController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"

@interface AYPostPhotoPublishController ()


@end

@implementation AYPostPhotoPublishController {
    UIImage* post_image;
}

@synthesize publishType = _publishType;

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
//        post_image = [dic objectForKey:kAYControllerChangeArgsKey];
        NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
        post_image = [args objectForKey:@"image"];
        self.tags = [args objectForKey:@"tags"];
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainContentView.image = post_image;
//    self.mainContentView.backgroundColor = [UIColor colorWithRed:253/255 green:1/255 blue:1/255 alpha:0.2];
    _publishType = PostPreViewPhote;
}

#pragma mark -- actions
- (NSString*)getNavTitle {
    return @"图片说明";
}

- (void)didSelectPostBtn {
    // TODO: tags ...
//    NSLog(@"%d",[super isShareQQ]? 1 : 0);
    NSArray* images = @[post_image];
    NSMutableDictionary* post_args = [[NSMutableDictionary alloc]init];
    [post_args setValue:images forKey:@"images"];
    [post_args setValue:self.tags forKey:@"tags"];
    
    id<AYViewBase> view_des = [self.views objectForKey:@"PublishContainer"];
    id<AYCommand> cmd_des = [view_des.commands objectForKey:@"queryUserDescription"];
    id description = nil;
    [cmd_des performWithResult:&description];
    [post_args setValue:description forKey:@"description"];
    
    id<AYFacadeBase> f = [self.facades objectForKey:@"PostRemote"];
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"PostPhotos"];
   
    [cmd performWithResult:[post_args copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
//        if (success) {
//            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"分享已成功发布" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            id<AYCommand> cmd = REVERSMODULE;
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            [dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
            [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
            [cmd performWithResult:&dic];
//        }
    }];
    
    AYModelFacade* fl = LOGINMODEL;
    CurrentToken* tmp = [CurrentToken enumCurrentLoginUserInContext:fl.doc.managedObjectContext];
    NSLog(@"sunfei -- %@",tmp);
    NSString* photo_name = tmp.who.screen_image;
//    NSString* photo_name = @"AE37CA0F-A5AF-43AD-B8FA-8B7D1B17B9D1";
    NSString* screen_name = tmp.who.screen_name;
    
    id<AYFacadeBase> fp = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd_fp = [fp.commands objectForKey:@"DownloadUserFiles"];
    
    NSMutableDictionary* dic_load_img = [[NSMutableDictionary alloc]init];
    [dic_load_img setValue:photo_name forKey:@"image"];
    [dic_load_img setValue:@"img_icon" forKey:@"expect_size"];
    
    [cmd_fp performWithResult:[dic_load_img copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        UIImage* img = (UIImage*)result;
        if (img != nil) {
            NSMutableDictionary* dict_sns = [[NSMutableDictionary alloc]init];
            UIImage *shareImage = [Tools addPortraitToImage:post_image userHead:img userName:screen_name];
            [dict_sns setValue:shareImage forKey:@"image"];
            [dict_sns setValue:(NSString*)description forKey:@"decs"];
            [dict_sns setValue:[NSNumber numberWithInt:_publishType] forKey:@"publishType"];
            
            if ([super isShareQQ]) {
                
                id<AYFacadeBase> f = [self.facades objectForKey:@"SNSQQ"];
                AYRemoteCallCommand* cmd = [f.commands objectForKey:@"ShareWithQQ"];
                
                //        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
                //        [dict setValue:post_image forKey:@"image"];
                //        [dict setValue:(NSString*)description forKey:@"decs"];
                //        [dict setValue:[NSNumber numberWithInt:_publishType] forKey:@"publishType"];
                
                [cmd performWithResult:[dict_sns copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
                    if (success) {
                        
                    }else {
                        [[[UIAlertView alloc] initWithTitle:@"通知" message:@"QQ分享错误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
                    }
                }];
            }
            
            if ([super isShareWechat]) {
                
                id<AYFacadeBase> f = [self.facades objectForKey:@"SNSWechat"];
                AYRemoteCallCommand* cmd = [f.commands objectForKey:@"ShareWithWechat"];
                
                //        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
                //        [dict setValue:post_image forKey:@"image"];
                //        [dict setValue:(NSString*)description forKey:@"decs"];
                
                [cmd performWithResult:[dict_sns copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
                    if (success) {
                        
                    } else {
                        [[[UIAlertView alloc] initWithTitle:@"通知" message:@"微信同步分享错误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
                    }
                }];
            }
            
            if ([super isShareWeibo]) {
                
                id<AYFacadeBase> f = [self.facades objectForKey:@"SNSWeibo"];
                AYRemoteCallCommand* cmd = [f.commands objectForKey:@"ShareWithWeibo"];
                
                //        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
                //        [dict setValue:post_image forKey:@"image"];
                //        [dict setValue:(NSString*)description forKey:@"decs"];
                
                [cmd performWithResult:[dict_sns copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
                    if (success) {
                        //                [[[UIAlertView alloc] initWithTitle:@"通知" message:@"微博同步分享成功" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
                    } else {
                        NSString* msg = (NSString*)result;
                        if ([msg isEqualToString:@"weiboNotAuth"]) {
                            [[[UIAlertView alloc] initWithTitle:@"通知" message:@"微博同步分享请先绑定微博或用微博登录" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show];
                        }else
                        [[[UIAlertView alloc] initWithTitle:@"通知" message:@"微博同步分享错误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
                        
                    }
                }];
                
            }
            
        }
    }];
    
}
@end
