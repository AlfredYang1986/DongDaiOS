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
#import "AYAlbumDefines.h"
#import "AYRemoteCallDefines.h"
#import "Tools.h"

#import "AYModelFacade.h"
#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"

#define STATUS_BAR_HEIGHT       20
#define FAKE_BAR_HEIGHT        44
#define SCREEN_WIDTH                [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT               [UIScreen mainScreen].bounds.size.height

#define QUERY_VIEW_MARGIN_LEFT      10.5
#define QUERY_VIEW_MARGIN_RIGHT     QUERY_VIEW_MARGIN_LEFT
#define QUERY_VIEW_MARGIN_UP        STATUS_BAR_HEIGHT
#define QUERY_VIEW_MARGIN_BOTTOM    0

#define HEADER_VIEW_HEIGHT          183

#define MARGIN_LEFT                 10.5
#define MARGIN_RIGHT                10.5

#define SEG_CTR_HEIGHT              49

@interface AYProfileController ()
@property (nonatomic, setter=setCurrentStatus:) RemoteControllerStatus status;
@end

@implementation AYProfileController {
    BOOL isPushed;
    NSString* owner_id;
    NSString* screen_name;
    NSDictionary* profile_dic;
    NSArray* post_content;
    NSArray* push_content;
    
    UIView *cover;
    
    dispatch_semaphore_t semaphore_publish;
    dispatch_semaphore_t semaphore_push;
    dispatch_semaphore_t semaphore_user_info;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        owner_id = [dic objectForKey:kAYControllerChangeArgsKey];
        isPushed = YES;
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        NSString *info = [dic objectForKey:kAYControllerChangeArgsKey];
        if ([info isEqualToString:@"infoChanged"]) {
            id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
            id<AYCommand> refresh = [view_notify.commands objectForKey:@"refresh"];
            [refresh performWithResult:nil];
        }
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools garyBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    id<AYViewBase> nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYCommand> cmd_nav = [nav.commands objectForKey:@"setBackGroundColor:"];
    UIColor* c_nav = [UIColor whiteColor];
    [cmd_nav performWithResult:&c_nav];
    
    id<AYCommand> cmd_right_vis = [nav.commands objectForKey:@"setRightBtnVisibility:"];
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    [cmd_right_vis performWithResult:&right_hidden];
    if (!isPushed) {
        
        id<AYCommand> cmd_left_vis = [nav.commands objectForKey:@"setLeftBtnVisibility:"];
        NSNumber* left_hidden = [NSNumber numberWithBool:YES];
        [cmd_left_vis performWithResult:&left_hidden];
    }
    
    AYModelFacade* f = LOGINMODEL;
    CurrentToken* tmp = [CurrentToken enumCurrentLoginUserInContext:f.doc.managedObjectContext];
    NSMutableDictionary* cur = [[NSMutableDictionary alloc]initWithCapacity:4];
    [cur setValue:tmp.who.user_id forKey:@"user_id"];
    [cur setValue:tmp.who.auth_token forKey:@"auth_token"];
    [cur setValue:tmp.who.screen_image forKey:@"screen_photo"];
    [cur setValue:tmp.who.screen_name forKey:@"screen_name"];
    [cur setValue:tmp.who.role_tag forKey:@"role_tag"];
    NSLog(@"michauxs -- %@",tmp.who);
    
    {
        id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
        id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"Profile"];
        
        id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
        
        id obj = (id)cmd_notify;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_notify;
        [cmd_delegate performWithResult:&obj];
        
        id<AYCommand> cmd_cell = [view_notify.commands objectForKey:@"registerCellWithNib:"];
        NSString* class_name = @"AYProfileHeadCellView";
        [cmd_cell performWithResult:&class_name];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    view.backgroundColor = [UIColor clearColor];
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;

    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, FAKE_BAR_HEIGHT);
    id<AYViewBase> bar = (id<AYViewBase>)view;
    if (isPushed) {
        id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
        UIImage* left = IMGRESOURCE(@"bar_left_black");
        [cmd_left performWithResult:&left];
    }
    
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, FAKE_BAR_HEIGHT - 0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
    [view.layer addSublayer:line];
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UILabel* titleView = (UILabel*)view;
    titleView.text = @"我的";
    titleView.font = [UIFont systemFontOfSize:16.f];
    titleView.textColor = [Tools blackColor];
    [titleView sizeToFit];
    titleView.center = CGPointMake(width / 2, 44 / 2 + 20);
    return nil;
}

#pragma mark -- notification
- (id)queryIsGridSelected:(id)obj {
    //    NSInteger index = ((NSNumber*)obj).integerValue;
    return [NSNumber numberWithBool:NO];
}


- (id)SamePersonBtnSelected {
    NSLog(@"push to person setting");
    
    AYViewController* des = DEFAULTCONTROLLER(@"PersonalSetting");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:profile_dic forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
    return nil;
}

- (id)queryTargetID {
    id result = owner_id;
    return result;
}

- (id)relationChanged:(id)args {
    NSNumber* new_relations = (NSNumber*)args;
    NSLog(@"new relations %@", new_relations);
    
    id<AYViewBase> view_header = [self.views objectForKey:@"ProfileHeader"];
    id<AYCommand> cmd = [view_header.commands objectForKey:@"changeRelations:"];
    [cmd performWithResult:&new_relations];
    
    return nil;
}

- (id)startRemoteCall:(id)obj {
    return nil;
}

-(id)sendRegMessage{
    AYViewController* des = DEFAULTCONTROLLER(@"TabBarService");
    
    NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc]init];
    [dic_show_module setValue:kAYControllerActionShowModuleValue forKey:kAYControllerActionKey];
    [dic_show_module setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_show_module setValue:self.tabBarController forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd_show_module = SHOWMODULE;
    [cmd_show_module performWithResult:&dic_show_module];
    
    return nil;
}
#pragma mark -- status

@end
