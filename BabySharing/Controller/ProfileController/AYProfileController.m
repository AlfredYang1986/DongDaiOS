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
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
    
    }
}

#pragma mark -- life cycle 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* loading_view = [self.views objectForKey:@"Loading"];
    [self.view bringSubviewToFront:loading_view];
    
    semaphore_user_info = dispatch_semaphore_create(0);
    semaphore_publish = dispatch_semaphore_create(0);
    semaphore_push = dispatch_semaphore_create(0);
    
    {
        id<AYViewBase> bkg = [self.views objectForKey:@"Image"];
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
       
        if (isPushed) {
            id<AYCommand> cmd_right_vis = [nav.commands objectForKey:@"setRightBtnVisibility:"];
            NSNumber* right_hidden = [NSNumber numberWithBool:YES];
            [cmd_right_vis performWithResult:&right_hidden];
        } else {
            id<AYCommand> cmd_left_vis = [nav.commands objectForKey:@"setLeftBtnVisibility:"];
            NSNumber* left_hidden = [NSNumber numberWithBool:YES];
            [cmd_left_vis performWithResult:&left_hidden];           
        }

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
        
        id<AYDelegateBase> cmd_pubish = [self.delegates objectForKey:@"ProfilePush"];
        
        id obj = (id)cmd_pubish;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_pubish;
        [cmd_delegate performWithResult:&obj];
        
        id<AYCommand> cmd_search = [view_table.commands objectForKey:@"registerCellWithNib:"];
        NSString* nib_search_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ProfilePushCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_search performWithResult:&nib_search_name];
    }
    {
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
        
        id<AYDelegateBase> cmd_pubish = [self.delegates objectForKey:@"ProfilePublish"];
        
        id obj = (id)cmd_pubish;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_pubish;
        [cmd_delegate performWithResult:&obj];
        
        id<AYCommand> cmd_hot_cell = [view_table.commands objectForKey:@"registerCellWithClass:"];
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYAlbumTableCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [cmd_hot_cell performWithResult:&class_name];
    
    }
    
   
}

- (void)startWaitForAllCallback {
    self.status = RemoteControllerStatusLoading;
    dispatch_queue_t wait = dispatch_queue_create("wait for query", nil);
    dispatch_async(wait, ^{
        dispatch_semaphore_wait(semaphore_user_info, dispatch_time(DISPATCH_TIME_NOW, 30.f * NSEC_PER_SEC));
        dispatch_semaphore_wait(semaphore_push, dispatch_time(DISPATCH_TIME_NOW, 30.f * NSEC_PER_SEC));
        dispatch_semaphore_wait(semaphore_publish, dispatch_time(DISPATCH_TIME_NOW, 30.f * NSEC_PER_SEC));

        dispatch_async(dispatch_get_main_queue(), ^{
            self.status = RemoteControllerStatusReady;
          
            NSUInteger publich_count, push_count = 0;
            {
                id<AYFacadeBase> f_owner_query = OWNERQUERYMODEL;
                id<AYCommand> cmd = [f_owner_query.commands objectForKey:@"EnumOwnerQueryData"];
                NSArray* result = nil;
                [cmd performWithResult:&result];
                publich_count = result.count;
                NSLog(@"result are %@", result);
                post_content = result;
                
                id<AYDelegateBase> del = [self.delegates objectForKey:@"ProfilePublish"];
                id<AYCommand> cmd_set_data = [del.commands objectForKey:@"changeQueryData:"];
                [cmd_set_data performWithResult:&result];
            }
            
            {
                id<AYFacadeBase> f_owner_query = OWNERQUERYPUSHMODEL;
                id<AYCommand> cmd = [f_owner_query.commands objectForKey:@"EnumOwnerQueryPushData"];
                NSArray* result = nil;
                [cmd performWithResult:&result];
                push_count = result.count;
                NSLog(@"result are %@", result);
                push_content = result;
                
                id<AYDelegateBase> del = [self.delegates objectForKey:@"ProfilePush"];
                id<AYCommand> cmd_set_data = [del.commands objectForKey:@"changeQueryData:"];
                [cmd_set_data performWithResult:&result];
            }
            
            id<AYViewBase> view_seg = [self.views objectForKey:@"DongDaSeg"];
            id<AYCommand> cmd_refresh_item = [view_seg.commands objectForKey:@"resetItemInfo:"];
            
            {
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                [dic setValue:[NSString stringWithFormat:@"%lu", (unsigned long)publich_count] forKey:kAYSegViewTitleKey];
                [dic setValue:[NSNumber numberWithInt:0] forKey:kAYSegViewIndexTypeKey];
                [cmd_refresh_item performWithResult:&dic];
            }
            
            {
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                [dic setValue:[NSString stringWithFormat:@"%lu", (unsigned long)push_count] forKey:kAYSegViewTitleKey];
                [dic setValue:[NSNumber numberWithInt:1] forKey:kAYSegViewIndexTypeKey];
                [cmd_refresh_item performWithResult:&dic];
            }
            
            id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
            id<AYCommand> cmd_refresh = [view_table.commands objectForKey:@"refresh"];
            [cmd_refresh performWithResult:nil];
        });
    });
}

- (void)refreshProfileData {
    id<AYFacadeBase> f_login_model = LOGINMODEL;
    id<AYCommand> cmd = [f_login_model.commands objectForKey:@"QueryCurrentLoginUser"];
    id obj = nil;
    [cmd performWithResult:&obj];
    NSLog(@"current login user is %@", obj);
    if (owner_id == nil) {
        owner_id = [obj objectForKey:@"user_id"];
    }
   
    [self startWaitForAllCallback];
    
    {
        NSMutableDictionary* dic_user_info = [obj mutableCopy];
        [dic_user_info setValue:owner_id forKey:@"owner_user_id"];
        
        id<AYFacadeBase> f_profile = [self.facades objectForKey:@"ProfileRemote"];
        AYRemoteCallCommand* cmd_user_info = [f_profile.commands objectForKey:@"QueryUserProfile"];
        [cmd_user_info performWithResult:[dic_user_info copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            NSLog(@"User info are %@", result);
            screen_name = [result objectForKey:@"screen_name"];
            
            id<AYViewBase> header = [self.views objectForKey:@"ProfileHeader"];
            id<AYCommand> cmd = [header.commands objectForKey:@"setUserInfo:"];
            NSDictionary* reVal = [result copy];
            [cmd performWithResult:&reVal];
            profile_dic = result;
        }];
    }
    
    {
        id<AYFacadeBase> f_query_content = [self.facades objectForKey:@"ContentQueryRemote"];
        AYRemoteCallCommand* cmd_query_content = [f_query_content.commands objectForKey:@"QueryHomeContent"];
        
        NSMutableDictionary* dic_conditions = [[NSMutableDictionary alloc]init];
        [dic_conditions setObject:owner_id forKey:@"owner_id"];
        
        NSMutableDictionary* dic = [obj mutableCopy];
        [dic setValue:[dic_conditions copy] forKey:@"conditions"];
        [dic setValue:[NSNumber numberWithInteger:0] forKey:@"skip"];
        
        [cmd_query_content performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            NSLog(@"user post result %@", result);
           
            NSDictionary* args = [result copy];
            
            id<AYFacadeBase> f_owner_query = OWNERQUERYMODEL;
            id<AYCommand> cmd = [f_owner_query.commands objectForKey:@"RefrashOwnerQueryData"];
            [cmd performWithResult:&args];
        }];
    }
    
    {
        id<AYFacadeBase> f_query_content = [self.facades objectForKey:@"ContentQueryRemote"];
        AYRemoteCallCommand* cmd_query_push = [f_query_content.commands objectForKey:@"QueryPushContent"];
        
        NSMutableDictionary* dic = [obj mutableCopy];
        [dic setObject:owner_id forKey:@"owner_id"];
        [dic setValue:[NSNumber numberWithInteger:0] forKey:@"skip"];
        
        [cmd_query_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            NSLog(@"user push result %@", result);
            
            NSDictionary* args = [result copy];
            
            id<AYFacadeBase> f_owner_query = OWNERQUERYPUSHMODEL;
            id<AYCommand> cmd = [f_owner_query.commands objectForKey:@"RefrashOwnerQueryPushData"];
            [cmd performWithResult:&args];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    [self refreshProfileData];
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
    view.frame = CGRectMake(QUERY_VIEW_MARGIN_LEFT, QUERY_VIEW_MARGIN_UP + HEADER_VIEW_HEIGHT + SEG_CTR_HEIGHT - 3, [UIScreen mainScreen].bounds.size.width - QUERY_VIEW_MARGIN_LEFT - QUERY_VIEW_MARGIN_RIGHT, [UIScreen mainScreen].bounds.size.height - QUERY_VIEW_MARGIN_UP - QUERY_VIEW_MARGIN_BOTTOM - HEADER_VIEW_HEIGHT - 100 + PUSHED_MODIFY);
    UIView* head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 8)];
    head.backgroundColor = [UIColor whiteColor];
    ((UITableView*)view).tableHeaderView = head;
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
//    ((UITableView*)view).
    return nil;
}

- (id)ImageLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    view.frame = CGRectMake(0, 0, width, height);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, STATUS_BAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, FAKE_BAR_HEIGHT);
    return nil;
}

- (id)LoadingLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    view.frame = CGRectMake(0, 0, width, height);
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
   
    id<AYCommand> setting = DEFAULTCONTROLLER(@"Setting");
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [self performWithResult:&dic];
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

- (id)queryIsGridSelected:(id)obj {
//    NSInteger index = ((NSNumber*)obj).integerValue;
    return [NSNumber numberWithBool:NO];
}

- (id)selectedValueChanged:(id)obj {
    NSNumber* new_current = [NSNumber numberWithInteger:((NSNumber*)obj).integerValue];
    NSLog(@"%@ is selected", new_current);
    
    AYViewController* des = DEFAULTCONTROLLER(@"Home");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [args setValue:screen_name forKey:@"home_title"];
    
    id<AYViewBase> seg = [self.views objectForKey:@"DongDaSeg"];
    id<AYCommand> cmd_seg = [seg.commands objectForKey:@"queryCurrentSelectedIndex"];
    NSNumber* index = nil;
    [cmd_seg performWithResult:&index];
   
    if (index.integerValue == 0) {
        [args setValue:post_content forKey:@"content"];
    } else {
        [args setValue:push_content forKey:@"content"];
    }
    
    [args setValue:new_current forKey:@"start_index"];
    
    [dic_push setValue:[args copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
   
    return nil;
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

- (id)endRemoteCall:(id)obj {
    NSString* cmd_name = (NSString*)obj;
    
    if ([cmd_name containsString:@"QueryUserProfile"]) {
        dispatch_semaphore_signal(semaphore_user_info);
    } else if ([cmd_name containsString:@"QueryHomeContent"]) {
        dispatch_semaphore_signal(semaphore_publish);
    } else if ([cmd_name containsString:@"QueryPushContent"]) {
        dispatch_semaphore_signal(semaphore_push);
    }
    
    return nil;
}


#pragma mark -- status
- (void)setCurrentStatus:(RemoteControllerStatus)new_status {
    _status = new_status;
    
    UIView* loading_view = [self.views objectForKey:@"Loading"];
    
    switch (_status) {
        case RemoteControllerStatusReady: {
            loading_view.hidden = YES;
            [loading_view removeFromSuperview];
            [[((id<AYViewBase>)loading_view).commands objectForKey:@"stopGif"] performWithResult:nil];
        }
            break;
        case RemoteControllerStatusPrepare:
        case RemoteControllerStatusLoading: {
            loading_view.hidden = NO;
            [[((id<AYViewBase>)loading_view).commands objectForKey:@"startGif"] performWithResult:nil];
        }
            break;
        default:
            @throw [[NSException alloc]initWithName:@"Error" reason:@"状态设置错误" userInfo:nil];
            break;
    }
}
@end
