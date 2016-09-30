//
//  AYCommentServiceController.m
//  BabySharing
//
//  Created by Alfred Yang on 25/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYCommentServiceController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#import "AYDongDaSegDefines.h"
#import "AYSearchDefines.h"

#define kTableViewY                   270

@interface AYCommentServiceController ()

@end

@implementation AYCommentServiceController {
    
    NSDictionary *notify_args;
    NSMutableArray *service_rangs;
    
    UIImageView *userPhoto;
    UILabel *nameLabel;
}

- (void)postPerform{
    
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        notify_args = [dic objectForKey:kAYControllerChangeArgsKey];
        //        NSLog(@"%@",order_info);
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    service_rangs = [NSMutableArray array];
    for (int i = 0; i < 3; ++i) {
        [service_rangs addObject:[NSNumber numberWithInt:0]];
    }
    
    UILabel *tipsLabel = [UILabel new];
    tipsLabel = [Tools setLabelWith:tipsLabel andText:@"请评价您体验的服务" andTextColor:[UIColor whiteColor] andFontSize:17.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(90);
        make.centerX.equalTo(self.view);
    }];
    
    userPhoto = [[UIImageView alloc]init];
    userPhoto.image = IMGRESOURCE(@"default_user");
    userPhoto.layer.cornerRadius = 35.f;
    userPhoto.clipsToBounds = YES;
    userPhoto.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25f].CGColor;
    userPhoto.layer.borderWidth = 2.f;
    [self.view addSubview:userPhoto];
    [userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLabel.mas_bottom).offset(25);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    
    
    nameLabel = [[UILabel alloc]init];
    nameLabel = [Tools setLabelWith:nameLabel andText:@"服务者" andTextColor:[Tools whiteColor] andFontSize:15.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userPhoto.mas_bottom).offset(25);
        make.centerX.equalTo(self.view);
    }];
    
//    UILabel *countLabel = [[UILabel alloc]init];
//    countLabel = [Tools setLabelWith:countLabel andText:@"服务主题" andTextColor:[Tools whiteColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
//    [self.view addSubview:countLabel];
//    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(nameLabel.mas_bottom).offset(10);
//        make.centerX.equalTo(self.view);
//    }];
    
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"CommentService"];
    
    id obj = (id)cmd_recommend;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_recommend;
    [cmd_delegate performWithResult:&obj];
    
    id<AYCommand> cmd_clsss = [view_table.commands objectForKey:@"registerCellWithClass:"];
    NSString* head_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ServQualityCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_clsss performWithResult:&head_name];
    /****************************************/
    
    UIButton *botBtn = [[UIButton alloc]init];
    [self.view addSubview:botBtn];
    botBtn.backgroundColor = [Tools themeColor];
    [botBtn setTitle:@"提交" forState:UIControlStateNormal];
    botBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [botBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [botBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-20);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH - 30);
        make.height.mas_equalTo(44);
    }];
    [botBtn addTarget:self action:@selector(didBotBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    id<AYFacadeBase> f_name_photo = DEFAULTFACADE(@"ScreenNameAndPhotoCache");
    AYRemoteCallCommand* cmd_name_photo = [f_name_photo.commands objectForKey:@"QueryScreenNameAndPhoto"];
    
    NSMutableDictionary* dic_owner_id = [[NSMutableDictionary alloc]init];
    [dic_owner_id setValue:[notify_args objectForKey:@"sender_id"] forKey:@"user_id"];
    [cmd_name_photo performWithResult:[dic_owner_id copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            NSString *photo_name = [result objectForKey:@"screen_photo"];
            
            id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
            AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            [dic setValue:photo_name forKey:@"image"];
            [dic setValue:@"img_icon" forKey:@"expect_size"];
            [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
                UIImage* img = (UIImage*)result;
                if (img != nil) {
                    [userPhoto setImage:img];
                }
            }];
            
            NSString *user_name = [result objectForKey:@"screen_name"];
            nameLabel.text = user_name;
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    view.backgroundColor = [UIColor clearColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 54);
    view.backgroundColor = [UIColor clearColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_white");
    [cmd_left performWithResult:&left];
    
    id<AYCommand> cmd_right_vis = [bar.commands objectForKey:@"setRightBtnVisibility:"];
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    [cmd_right_vis performWithResult:&right_hidden];
    
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, kTableViewY, SCREEN_WIDTH, SCREEN_HEIGHT - kTableViewY - 100);
    view.backgroundColor = [Tools blackColor];
    return nil;
}

#pragma mark -- textViewDelegate


#pragma mark -- actions
- (void)didBotBtnClick {
    
    if ([service_rangs containsObject:[NSNumber numberWithInt:0]]) {
        kAYUIAlertView(@"提示", @"评价未完成");
        return;
    }
    
    id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
    AYRemoteCallCommand *cmd_reject = [facade.commands objectForKey:@"RejectOrder"];
    
    NSDictionary* info = nil;
    CURRENUSER(info)
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dic setValue:[info objectForKey:@"user_id"] forKey:@"user_id"];
//    [dic setValue:order_id forKey:@"order_id"];
//    [dic setValue:seasonOfTextView.text forKey:@"season_reject"];
    
    [cmd_reject performWithResult:dic andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            kAYUIAlertView(@"提示", @"评论已成功发布");
            [self leftBtnSelected];
        } else {
            
        }
    }];
}

#pragma mark -- notification
- (id)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    id<AYCommand> cmd = REVERSMODULE;
    [cmd performWithResult:&dic];
    
    return nil;
}

- (id)didSetServiceRang:(NSDictionary*)args {
    
    NSNumber *index_tag = [args objectForKey:@"index_tag"];
    NSNumber *star_rang = [args objectForKey:@"star_rang"];
    
    [service_rangs replaceObjectAtIndex:index_tag.intValue withObject:star_rang];
    
    return nil;
}

@end