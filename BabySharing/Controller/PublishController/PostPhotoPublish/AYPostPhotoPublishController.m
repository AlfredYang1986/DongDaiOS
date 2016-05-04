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

@interface AYPostPhotoPublishController ()


@end

@implementation AYPostPhotoPublishController {
    UIImage* post_image;
}

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
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"分享已成功发布" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        id<AYCommand> cmd = REVERSMODULE;
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
        [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
        [cmd performWithResult:&dic];
    }];
    
    if ([super isShareQQ]) {
        
        id<AYFacadeBase> f = [self.facades objectForKey:@"SNSQQ"];
        AYRemoteCallCommand* cmd = [f.commands objectForKey:@"ShareWithQQ"];
        
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setValue:post_image forKey:@"image"];
        [dict setValue:(NSString*)description forKey:@"decs"];
        
        [cmd performWithResult:[dict copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
                
            }else {
                [[[UIAlertView alloc] initWithTitle:@"通知" message:@"QQ分享错误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            }
        }];
    }
    
    if ([super isShareWechat]) {
        
        id<AYFacadeBase> f = [self.facades objectForKey:@"SNSWechat"];
        AYRemoteCallCommand* cmd = [f.commands objectForKey:@"ShareWithWechat"];
        
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setValue:post_image forKey:@"image"];
        [dict setValue:(NSString*)description forKey:@"decs"];
        
        [cmd performWithResult:[dict copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
                
            } else {
                [[[UIAlertView alloc] initWithTitle:@"通知" message:@"微信同步分享错误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            }
        }];
    }
    
    if ([super isShareWeibo]) {
        
        id<AYFacadeBase> f = [self.facades objectForKey:@"SNSWeibo"];
        AYRemoteCallCommand* cmd = [f.commands objectForKey:@"ShareWithWeibo"];
        
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        [dict setValue:post_image forKey:@"image"];
        [dict setValue:(NSString*)description forKey:@"decs"];
        
        [cmd performWithResult:[dict copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            if (success) {
//                [[[UIAlertView alloc] initWithTitle:@"通知" message:@"微博同步分享成功" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            } else {
                NSString* msg = (NSString*)result;
                NSLog(@"%@",msg);
                [[[UIAlertView alloc] initWithTitle:@"通知" message:@"微博同步分享错误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            }
        }];
        
    }
}
@end
