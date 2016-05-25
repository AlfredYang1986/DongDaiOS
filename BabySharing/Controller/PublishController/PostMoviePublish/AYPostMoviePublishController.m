//
//  AYPostMoviePublishController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/20/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPostMoviePublishController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

@interface AYPostMoviePublishController ()
@property (nonatomic, weak) UIView* filterView;
@end

@implementation AYPostMoviePublishController {
    NSURL* movie_url;
    UIImage* img_cover;
}

@synthesize filterView = _filterView;
@synthesize publishType = _publishType;

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
        movie_url = [args objectForKey:@"url"];
        img_cover = [args objectForKey:@"cover"];
        self.tags = [args objectForKey:@"tags"];
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainContentView.image = img_cover;
    _publishType = PostPreViewPhote;
    [self playCurrentMovie];
}

- (void)clearController {
    id<AYFacadeBase> f = [self.facades objectForKey:@"MoviePlayer"];
    id<AYCommand> cmd = [f.commands objectForKey:@"ReleaseMovie"];
    id url = movie_url;
    [cmd performWithResult:&url];
    
    [super clearController];
}

- (void)playCurrentMovie {
    id<AYFacadeBase> f = [self.facades objectForKey:@"MoviePlayer"];
    if (self.filterView == nil) {
        id<AYCommand> cmd_view = [f.commands objectForKey:@"MovieDisplayView"];
        id url = movie_url;
        [cmd_view performWithResult:&url];
        
        self.filterView = url;
#define FAKE_NAVIGATION_BAR_HEIGHT      64
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 10.5 * 2;
        CGFloat img_height = width;
        self.filterView.frame = CGRectMake(0, -FAKE_NAVIGATION_BAR_HEIGHT, width, img_height + FAKE_NAVIGATION_BAR_HEIGHT);
        [self.mainContentView addSubview:self.filterView];
    }
    
    self.filterView.hidden = NO;
    id<AYCommand> cmd_play = [f.commands objectForKey:@"PlayMovie"];
    id url = movie_url;
    [cmd_play performWithResult:&url];
}

- (void)pauseCurrentMovie {
    id<AYFacadeBase> f = [self.facades objectForKey:@"MoviePlayer"];
    self.filterView.hidden = YES;
    
    id<AYCommand> cmd_play = [f.commands objectForKey:@"PauseMovie"];
    id url = movie_url;
    [cmd_play performWithResult:&url];
}

#pragma mark -- actions
- (NSString*)getNavTitle {
    return @"视频说明";
}

- (void)setCurrentStatus:(AYPostPublishControllerStatus)status {
    [super setCurrentStatus:status];
   
    switch (self.status) {
        case AYPostPublishControllerStatusReady:
            [self playCurrentMovie];
            break;
        case AYPostPublishControllerStatusInputing:
            [self pauseCurrentMovie];
            break;
        default:
            break;
    }
}

- (void)didSelectPostBtn {
    // TODO: tags ...
    
    NSMutableDictionary* post_args = [[NSMutableDictionary alloc]init];
    [post_args setValue:img_cover forKey:@"cover_img"];
    [post_args setValue:movie_url forKey:@"movie_url"];
    [post_args setValue:self.tags forKey:@"tags"];
    
    id<AYViewBase> view_des = [self.views objectForKey:@"PublishContainer"];
    id<AYCommand> cmd_des = [view_des.commands objectForKey:@"queryUserDescription"];
    id description = nil;
    [cmd_des performWithResult:&description];
    [post_args setValue:description forKey:@"description"];
    
    id<AYFacadeBase> f = [self.facades objectForKey:@"PostRemote"];
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"PostMovie"];
    
    id<AYCommand> cmd_module_up = REVERSMODULE;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [cmd_module_up performWithResult:&dic];
    [cmd performWithResult:[post_args copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"分享视频已成功发布" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }else {
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误，视频发布出现异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }
        
    }];
    
    NSMutableDictionary* dict_sns = [[NSMutableDictionary alloc]init];
    [dict_sns setValue:img_cover forKey:@"image"];
    [dict_sns setValue:(NSString*)description forKey:@"decs"];
    [dict_sns setValue:[NSNumber numberWithInt:_publishType] forKey:@"publishType"];
    
    if ([super isShareQQ]) {
        id<AYFacadeBase> f = [self.facades objectForKey:@"SNSQQ"];
        AYRemoteCallCommand* cmd = [f.commands objectForKey:@"ShareWithQQ"];
        [cmd performWithResult:[dict_sns copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
                
            }else {
                [[[UIAlertView alloc] initWithTitle:@"通知" message:@"QQ同步分享错误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            }
        }];
    }
    
    if ([super isShareWechat]) {
        id<AYFacadeBase> f = [self.facades objectForKey:@"SNSWechat"];
        AYRemoteCallCommand* cmd = [f.commands objectForKey:@"ShareWithWechat"];
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
        [cmd performWithResult:[dict_sns copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            if (success) {
                [[[UIAlertView alloc] initWithTitle:@"通知" message:@"微博同步分享成功" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
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

- (void)KeyboardShowKeyboard:(id)args {
    [super KeyboardShowKeyboard:args];
}

- (void)KeyboardHideKeyboard:(id)args {
    [super KeyboardHideKeyboard:args];
}
@end
