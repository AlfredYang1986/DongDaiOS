//
//  AYProfileController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYProfileController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYDongDaSegDefines.h"

#define STATUS_BAR_HEIGHT       20
#define FAKE_BAR_HEIGHT        44

#define QUERY_VIEW_MARGIN_LEFT      10.5
#define QUERY_VIEW_MARGIN_RIGHT     QUERY_VIEW_MARGIN_LEFT
#define QUERY_VIEW_MARGIN_UP        STATUS_BAR_HEIGHT
#define QUERY_VIEW_MARGIN_BOTTOM    0

#define HEADER_VIEW_HEIGHT          183

#define MARGIN_LEFT                 10.5
#define MARGIN_RIGHT                10.5

#define SEG_CTR_HEIGHT              49

@implementation AYProfileController {
    BOOL isPushed;
}

#pragma mark -- life cycle 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        id<AYViewBase> bkg = [self.views objectForKey:@"BackgroundImage"];
        id<AYCommand> cmd_bkg = [bkg.commands objectForKey:@"setBackgroundImage:"];
        UIImage* bg = PNGRESOURCE(@"profile_background_image");
        [cmd_bkg performWithResult:&bg];
       
        [self.view sendSubviewToBack:(UIView*)bkg];
    }

    {
        id<AYViewBase> nav = [self.views objectForKey:@"FakeNavBar"];
        id<AYCommand> cmd_nav = [nav.commands objectForKey:@"setBackGroundColor:"];
        UIColor* c_nav = [UIColor clearColor];
        [cmd_nav performWithResult:&c_nav];
        
        id<AYCommand> cmd_left_vis = [nav.commands objectForKey:@"setLeftBtnVisibility:"];
        NSNumber* left_hidden = [NSNumber numberWithBool:YES];
        [cmd_left_vis performWithResult:&left_hidden];
        
        [self.view bringSubviewToFront:(UIView*)nav];
    }

    {
        id<AYViewBase> seg = [self.views objectForKey:@"DongDaSeg"];
        id<AYCommand> cmd_info = [seg.commands objectForKey:@"setSegInfo:"];
        
        id<AYCommand> cmd_add_item = [seg.commands objectForKey:@"addItem:"];
        NSMutableDictionary* dic_add_item_0 = [[NSMutableDictionary alloc]init];
        [dic_add_item_0 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitleWithSubTitle] forKey:kAYSegViewItemTypeKey];
        [dic_add_item_0 setValue:@"0" forKey:kAYSegViewTitleKey];
        [dic_add_item_0 setValue:@"发布" forKey:kAYSegViewSubTitleKey];
        [cmd_add_item performWithResult:&dic_add_item_0];

        NSMutableDictionary* dic_add_item_1 = [[NSMutableDictionary alloc]init];
        [dic_add_item_1 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitleWithSubTitle] forKey:kAYSegViewItemTypeKey];
        [dic_add_item_1 setValue:@"0" forKey:kAYSegViewTitleKey];
        [dic_add_item_1 setValue:@"咚" forKey:kAYSegViewSubTitleKey];
        [cmd_add_item performWithResult:&dic_add_item_1];
        
        NSMutableDictionary* dic_user_info = [[NSMutableDictionary alloc]init];
        [dic_user_info setValue:[NSNumber numberWithFloat:4.f] forKey:kAYSegViewCornerRadiusKey];
        [dic_user_info setValue:[UIColor whiteColor] forKey:kAYSegViewBackgroundColorKey];
        [dic_user_info setValue:[NSNumber numberWithBool:YES] forKey:kAYSegViewLineHiddenKey];
        [dic_user_info setValue:[NSNumber numberWithInt:0] forKey:kAYSegViewCurrentSelectKey];
        [dic_user_info setValue:[NSNumber numberWithFloat:0.4f * [UIScreen mainScreen].bounds.size.width] forKey:kAYSegViewMarginBetweenKey];
        
        [cmd_info performWithResult:&dic_user_info];
    }
    
    {
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
        
        id<AYDelegateBase> cmd_pubish = [self.delegates objectForKey:@"ProfilePublish"];
//        id<AYDelegateBase> cmd_push = [self.delegates objectForKey:@"ProfilePush"];
        
        id obj = (id)cmd_pubish;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_pubish;
        [cmd_delegate performWithResult:&obj];
        
//        id<AYCommand> cmd_header = [view_table.commands objectForKey:@"registerHeaderAndFooterWithNib:"];
//        NSString* nib_header_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:RoleTagSearchHeader] stringByAppendingString:kAYFactoryManagerViewsuffix];
//        [cmd_header performWithResult:&nib_header_name];
//        
//        id<AYCommand> cmd_hot_cell = [view_table.commands objectForKey:@"registerCellWithClass:"];
//        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:RoleTagHotCell] stringByAppendingString:kAYFactoryManagerViewsuffix];
//        [cmd_hot_cell performWithResult:&class_name];
    }
   
    id<AYFacadeBase> f_login_model = LOGINMODEL;
    id<AYCommand> cmd = [f_login_model.commands objectForKey:@"QueryCurrentLoginUser"];
    id obj = nil;
    [cmd performWithResult:&obj];
    
    NSLog(@"current login user is %@", obj);
    
    NSMutableDictionary* dic_user_info = [obj mutableCopy];
    [dic_user_info setValue:[dic_user_info objectForKey:@"user_id"] forKey:@"owner_user_id"];
    
    id<AYFacadeBase> f_profile = [self.facades objectForKey:@"ProfileRemote"];
    AYRemoteCallCommand* cmd_user_info = [f_profile.commands objectForKey:@"QueryUserProfile"];
    [cmd_user_info performWithResult:[dic_user_info copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        NSLog(@"User info are %@", result);
        
        id<AYViewBase> header = [self.views objectForKey:@"ProfileHeader"];
        id<AYCommand> cmd = [header.commands objectForKey:@"setUserInfo:"];
        NSDictionary* reVal = [result copy];
        [cmd performWithResult:&reVal];
    }];
}

#pragma mark -- layout
- (id)ProfileHeaderLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, STATUS_BAR_HEIGHT, width, HEADER_VIEW_HEIGHT);
    view.backgroundColor = [UIColor clearColor];
    return nil;
}

- (id)DongDaSegLayout:(UIView*)view {
    view.frame = CGRectMake(MARGIN_LEFT, QUERY_VIEW_MARGIN_UP + HEADER_VIEW_HEIGHT, [UIScreen mainScreen].bounds.size.width - MARGIN_LEFT - MARGIN_RIGHT, SEG_CTR_HEIGHT);
    return nil;
}

- (id)TableLayout:(UIView*)view {
#define PUSHED_MODIFY           (isPushed ? 49 : 0)
    view.frame = CGRectMake(QUERY_VIEW_MARGIN_LEFT, QUERY_VIEW_MARGIN_UP + HEADER_VIEW_HEIGHT + SEG_CTR_HEIGHT - 2, [UIScreen mainScreen].bounds.size.width - QUERY_VIEW_MARGIN_LEFT - QUERY_VIEW_MARGIN_RIGHT, [UIScreen mainScreen].bounds.size.height - QUERY_VIEW_MARGIN_UP - QUERY_VIEW_MARGIN_BOTTOM - HEADER_VIEW_HEIGHT - 100 + PUSHED_MODIFY);
    view.backgroundColor = [UIColor greenColor];
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return nil;
}

- (id)SetNevigationBarLeftBtnLayout:(UIView*)view {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    if (self.navigationController.navigationBar.hidden == YES) {
        view.hidden = YES;
    }
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    self.navigationItem.titleView = view;
    if (self.navigationController.navigationBar.hidden == YES) {
        view.hidden = YES;
    }
    return nil;
}

- (id)BackgroundImageLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    view.frame = CGRectMake(0, 0, width, height);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, STATUS_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, FAKE_BAR_HEIGHT);
    return nil;
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)rightBtnSelected {
    NSLog(@"setting view controller");
    return nil;
}

- (id)segValueChanged:(id)args {
    
    id<AYViewBase> seg = (id<AYViewBase>)args;
    id<AYCommand> cmd = [seg.commands objectForKey:@"queryCurrentSelectedIndex"];
    NSNumber* index = nil;
    [cmd performWithResult:&index];
   
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    
    switch (index.intValue) {
        case 0: {
                id<AYDelegateBase> cmd_pubish = [self.delegates objectForKey:@"ProfilePublish"];
        
                id obj = (id)cmd_pubish;
                [cmd_datasource performWithResult:&obj];
                obj = (id)cmd_pubish;
                [cmd_delegate performWithResult:&obj];
            }
            break;
        case 1: {
                id<AYDelegateBase> cmd_push = [self.delegates objectForKey:@"ProfilePush"];
                
                id obj = (id)cmd_push;
                [cmd_datasource performWithResult:&obj];
                obj = (id)cmd_push;
                [cmd_delegate performWithResult:&obj];
            }
            break;
        default:
            break;
    }
    
    id<AYCommand> refresh = [view_table.commands objectForKey:@"refresh"];
    [refresh performWithResult:nil];
    
    return nil;
}
@end
