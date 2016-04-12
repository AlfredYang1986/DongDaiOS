//
//  AYSettingController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/12/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSettingController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "OBShapedButton.h"
#import "AYResourceManager.h"
#import "AYNotifyDefines.h"
#import "AYFacadeBase.h"

#define SCREEN_WIDTH                [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT               [UIScreen mainScreen].bounds.size.height

@implementation AYSettingController
@synthesize para = _para;

@synthesize commands = _commands;
@synthesize facades = _facades;
@synthesize views = _views;
@synthesize delegates = _delegates;

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
        id<AYCommand> cmd_view_title = [view_title.commands objectForKey:@"changeNevigationBarTitle:"];
        NSString* title = @"设置";
        [cmd_view_title performWithResult:&title];
    }
    
    {
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
        
        id<AYDelegateBase> cmd_setting = [self.delegates objectForKey:@"AppSetting"];
        
        id obj = (id)cmd_setting;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_setting;
        [cmd_delegate performWithResult:&obj];
    }
    
    CALayer* line = [CALayer layer];
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.10].CGColor;
    line.borderWidth = 1.f;
    line.frame = CGRectMake(0, 73, [UIScreen mainScreen].bounds.size.width, 1);
    [self.view.layer addSublayer:line];
    
    OBShapedButton* logout_btn = [[OBShapedButton alloc]initWithFrame:CGRectMake(17.5, SCREEN_HEIGHT - 17.5 - 64 - 49 - 44, SCREEN_WIDTH - 2 * 17.5, 44)];
    [logout_btn setBackgroundImage:PNGRESOURCE(@"profile_logout_btn_bg") forState:UIControlStateNormal];
    logout_btn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [logout_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logout_btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logout_btn addTarget:self action:@selector(signOutSelected) forControlEvents:UIControlEventTouchUpInside];
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    [(UIView*)view_table addSubview:logout_btn];
}

#pragma mark -- layout
- (id)TableLayout:(UIView*)view {
    view.frame = self.view.bounds;
    ((UITableView*)view).scrollEnabled = NO;
    [((UITableView*)view) setSeparatorColor:[UIColor clearColor]];
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    self.navigationItem.titleView = view;
    return nil;
}

- (id)SetNevigationBarLeftBtnLayout:(UIView*)view {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    return nil;
}

#pragma mark -- notification
- (id)popToPreviousWithoutSave {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

#pragma mark -- actions
- (void)signOutSelected {
    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
    [notify setValue:kAYNotifyCurrentUserLogout forKey:kAYNotifyFunctionKey];
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
    
    id<AYFacadeBase> f = LOGINMODEL;
    [f performWithResult:&notify];
}
@end
