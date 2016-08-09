//
//  AYCollectServController.m
//  BabySharing
//
//  Created by Alfred Yang on 8/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYCollectServController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"
#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"

#import "AYDongDaSegDefines.h"
#import "AYSearchDefines.h"

#import "Tools.h"

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height

@interface AYCollectServController ()

@end

@implementation AYCollectServController{
    NSMutableArray *loading_status;
    
    int serviceType; //0收藏的服务 /1自己发布的服务
    
}

- (void)postPerform{
    
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        serviceType = ((NSNumber*)[dic objectForKey:kAYControllerChangeArgsKey]).intValue;
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:(UIView*)view_title];
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    
    id<AYDelegateBase> cmd_collect = [self.delegates objectForKey:@"CollectServ"];
    
    id obj = (id)cmd_collect;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_collect;
    [cmd_delegate performWithResult:&obj];
    
    id<AYCommand> cmd_search = [view_table.commands objectForKey:@"registerCellWithNib:"];
    NSString* nib_search_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"CLResultCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_search performWithResult:&nib_search_name];
    
    
    NSDictionary* info = nil;
    CURRENUSER(info)
    
    if (serviceType == 1) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:[info objectForKey:@"user_id"]  forKey:@"owner_id"];
        id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
        AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"QueryMyService"];
        [cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
                id<AYCommand> cmd_change_data = [cmd_collect.commands objectForKey:@"changeQueryData:"];
                NSArray *data = [result objectForKey:@"result"];
                [cmd_change_data performWithResult:&data];
                
                id<AYCommand> refresh = [view_table.commands objectForKey:@"refresh"];
                [refresh performWithResult:nil];
                
            } else {
                NSLog(@"push error with:%@",result);
                [[[UIAlertView alloc]initWithTitle:@"错误" message:@"error" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            }
        }];
    }
    
    if (serviceType == 1) {
        UIButton *confirmSerBtn = [[UIButton alloc]init];
        confirmSerBtn.backgroundColor = [Tools themeColor];
        [confirmSerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:confirmSerBtn];
        [confirmSerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
        }];
        [confirmSerBtn setTitle:@"发布新服务" forState:UIControlStateNormal];
        [confirmSerBtn addTarget:self action:@selector(conmitMyService) forControlEvents:UIControlEventTouchDown];
    }
    
    loading_status = [[NSMutableArray alloc]init];
    {
        UIView* view_loading = [self.views objectForKey:@"Loading"];
        [self.view bringSubviewToFront:view_loading];
        view_loading.hidden = YES;
    }
    
    UIView* headView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 10)];
    headView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.f];
    [self.view addSubview:headView];
    
    CALayer* line2 = [CALayer layer];
    line2.borderColor = [UIColor colorWithWhite:0.6922 alpha:0.10].CGColor;
    line2.borderWidth = 1.f;
    line2.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    [headView.layer addSublayer:line2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, width, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 20, width, 44);
    view.backgroundColor = [UIColor whiteColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    id<AYCommand> cmd_left_vis = [((id<AYViewBase>)view).commands objectForKey:@"setRightBtnVisibility:"];
    NSNumber* left_hidden = [NSNumber numberWithBool:YES];
    [cmd_left_vis performWithResult:&left_hidden];
    
//    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
//    [bar_right_btn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.f] forState:UIControlStateNormal];
//    [bar_right_btn setTitle:@"  " forState:UIControlStateNormal];
//    bar_right_btn.titleLabel.font = [UIFont systemFontOfSize:17.f];
//    [bar_right_btn sizeToFit];
//    bar_right_btn.center = CGPointMake(width - 15.5 - bar_right_btn.frame.size.width / 2, 44 / 2);
//    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
//    [cmd_right performWithResult:&bar_right_btn];
    
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    UILabel* titleView = (UILabel*)view;
    titleView.text = (serviceType == 1) ? @"我发布的服务" : @"我心仪的服务";
    titleView.font = [UIFont systemFontOfSize:16.f];
    titleView.textColor = [UIColor colorWithWhite:0.4 alpha:1.f];
    [titleView sizeToFit];
    titleView.center = CGPointMake(SCREEN_WIDTH / 2, 44 / 2);
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64 + 10, SCREEN_WIDTH, SCREEN_HEIGHT - 74 - (serviceType == 1?44:0));
    
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsHorizontalScrollIndicator = NO;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.f];
    return nil;
}

- (id)LoadingLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    return nil;
}

#pragma mark -- actions
- (void)conmitMyService {
    id<AYCommand> setting = DEFAULTCONTROLLER(@"NapArea");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [dic_push setValue:@"" forKey:kAYControllerChangeArgsKey];
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

@end
