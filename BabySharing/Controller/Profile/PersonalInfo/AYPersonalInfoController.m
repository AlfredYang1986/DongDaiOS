//
//  AYPersonalInfoController.m
//  BabySharing
//
//  Created by Alfred Yang on 27/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPersonalInfoController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"

#define userPhotoInitHeight         250

@implementation AYPersonalInfoController {
    
    NSDictionary *personal_info;
    UIImageView *coverImg;
}

- (void)postPerform{
    
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        personal_info = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        NSDictionary *tmp = [dic objectForKey:kAYControllerChangeArgsKey];
        
        kAYDelegatesSendMessage(@"PersonalInfo", @"changeQueryData:", &tmp)
        kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    id<AYDelegateBase> cmd_collect = [self.delegates objectForKey:@"PersonalInfo"];
    id obj = (id)cmd_collect;
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
    
    obj = (id)cmd_collect;
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
    
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"PersonalInfoHeadCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
    
    class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"PersonalDescCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
    
    class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"PersonalValidateCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
    
    NSDictionary *tmp = [personal_info copy];
    kAYDelegatesSendMessage(@"PersonalInfo", @"changeQueryData:", &tmp)
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    UITableView *tableView = (UITableView*)view_table;
    coverImg = [[UIImageView alloc]init];
//    coverImg.image = [UIImage imageNamed:@"default_image"];
    coverImg.backgroundColor = [UIColor lightGrayColor];
    coverImg.contentMode = UIViewContentModeScaleAspectFill;
    coverImg.clipsToBounds = YES;
    [tableView addSubview:coverImg];
    [coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableView).offset(- userPhotoInitHeight);
        make.centerX.equalTo(tableView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, userPhotoInitHeight));
    }];
    
    NSString* photo_name = [personal_info objectForKey:@"screen_photo"];
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSString *pre = cmd.route;
    [coverImg sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:photo_name]] placeholderImage:IMGRESOURCE(@"default_image")];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    view.backgroundColor = [UIColor whiteColor];
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    NSString *title = @"个人资料";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
    
    NSDictionary* info = nil;
    CURRENUSER(info)
    NSString *user_id = [personal_info objectForKey:@"user_id"];
    
    if ([user_id isEqualToString:[info objectForKey:@"user_id"]]) {
        
        UIButton* bar_right_btn = [[UIButton alloc]init];
        bar_right_btn = [Tools setButton:bar_right_btn withTitle:@"编辑" andTitleColor:[Tools blackColor] andFontSize:16.f andBackgroundColor:nil];
        [bar_right_btn sizeToFit];
        bar_right_btn.center = CGPointMake(SCREEN_WIDTH - 15.5 - bar_right_btn.frame.size.width / 2, 44 / 2);
        kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
    } else {
        
        NSNumber* left_hidden = [NSNumber numberWithBool:YES];
        kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &left_hidden)
    }
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH);
    ((UITableView*)view).contentInset = UIEdgeInsetsMake(userPhotoInitHeight, 0, 0, 0);
    return nil;
}

- (id)LoadingLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    return nil;
}

#pragma mark -- actions

#pragma mark -- notifies
- (id)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    
    AYViewController* des = DEFAULTCONTROLLER(@"PersonalSetting");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[personal_info copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    return nil;
}

- (id)scrollOffsetY:(NSNumber*)args {
    CGFloat offset_y = args.floatValue;
    CGFloat offsetH = userPhotoInitHeight + offset_y;
    
    if (offsetH < 0) {
        id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
        UITableView *tableView = (UITableView*)view_notify;
        
        [coverImg mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(tableView);
            make.top.equalTo(tableView).offset(- userPhotoInitHeight + offsetH);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH , userPhotoInitHeight - offsetH));
            
//            make.top.equalTo(tableView).offset(-kFlexibleHeight + offsetH);
//            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - (SCREEN_WIDTH * offsetH / kFlexibleHeight), kFlexibleHeight - offsetH));
        }];
    }
    return nil;
}

@end
