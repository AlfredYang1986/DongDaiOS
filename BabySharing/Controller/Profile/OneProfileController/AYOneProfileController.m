//
//  AYOneProfileController.m
//  BabySharing
//
//  Created by Alfred Yang on 11/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOneProfileController.h"
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
#import "AYModelFacade.h"

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


@implementation AYOneProfileController {
    
    NSString* owner_id;
    
    UIView *cover;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        owner_id = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools garyBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    id<AYDelegateBase> cmd_collect = [self.delegates objectForKey:@"OneProfile"];
    id obj = (id)cmd_collect;
    kAYViewsSendMessage(@"Table", @"registerDatasource:", &obj)
    
    obj = (id)cmd_collect;
    kAYViewsSendMessage(@"Table", @"registerDelegate:", &obj)
    
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"PersonalInfoHeadCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    kAYViewsSendMessage(kAYTableView, @"registerCellWithClass:", &class_name)
    
    class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"PersonalDescCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    kAYViewsSendMessage(@"Table", @"registerCellWithClass:", &class_name)
    
    class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"PersonalValidateCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    kAYViewsSendMessage(@"Table", @"registerCellWithClass:", &class_name)
    
    
    id<AYFacadeBase> remote = [self.facades objectForKey:@"ProfileRemote"];
    AYRemoteCallCommand* cmd = [remote.commands objectForKey:@"QueryUserProfile"];
    NSDictionary* user = nil;
    CURRENUSER(user);
    
    NSMutableDictionary* dic = [user mutableCopy];
    [dic setValue:owner_id forKey:@"owner_user_id"];
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            
            NSDictionary *tmp = [result copy];
            kAYDelegatesSendMessage(@"OneProfile", @"changeQueryData:", &tmp)
            kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
            
            NSString *title = [result objectForKey:@"screen_name"];
            kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
        }
    }];
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
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    view.backgroundColor = [UIColor clearColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, FAKE_BAR_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    
    NSString *title = @"看护妈妈";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    UIImage *right = IMGRESOURCE(@"tips_off_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnImgMessage, &right)
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报该用户", nil];
    [sheet showInView:self.view];
    
    return nil;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
        NSMutableDictionary *expose = [[NSMutableDictionary alloc]init];
        [expose setValue:[NSNumber numberWithInt:0] forKey:@"expose_type"];
        [expose setValue:owner_id forKey:@"user_id"];
        
        id<AYFacadeBase> expose_remote = [self.facades objectForKey:@"ExposeRemote"];
        AYRemoteCallCommand* cmd = [expose_remote.commands objectForKey:@"ExposeUser"];
        [cmd performWithResult:expose andFinishBlack:^(BOOL success, NSDictionary * result) {
            if (success) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"我们将尽快审查您举报的用户！\n感谢您的监督和支持！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            }else {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"举报发生未知错误，请检查网络是否正常连接！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            }
        }];
    } else  {
        
    }
}

- (id)didAllContent {
    id<AYCommand> des = DEFAULTCONTROLLER(@"ContentList");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [dic setValue:[args copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = SHOWMODULEUP;
    [cmd_show_module performWithResult:&dic];
    return nil;
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

#pragma mark -- status

@end
