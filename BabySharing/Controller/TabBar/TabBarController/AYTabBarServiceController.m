//
//  AYTabBarServiceController.m
//  BabySharing
//
//  Created by Alfred Yang on 11/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYTabBarServiceController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "DongDaTabBar.h"
#import "AYViewController.h"
#import "AYCommand.h"
#import "AYViewBase.h"
#import "DongDaTabBarItem.h"

@implementation AYTabBarServiceController{
    
    UIImage* img_home_with_no_message;
    UIImage* img_home_with_unread_message;
    
    int isExchangeModel;
    int expectIndex;
}

@synthesize para = _para;

@synthesize commands = _commands;
@synthesize facades = _facades;
@synthesize views = _views;
@synthesize delegates = _delegates;

#pragma mark -- commands
- (NSString*)getControllerName {
    return [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"TabBarService"] stringByAppendingString:kAYFactoryManagerControllersuffix];
}

- (NSString*)getControllerType {
    return kAYFactoryManagerCatigoryController;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryController;
}

- (void)postPerform {
    
    id<AYCommand> cmd_order_init = [self.commands objectForKey:@"OrderServantInit"];
    AYViewController* order = nil;
    [cmd_order_init performWithResult:&order];
    order.tabBarItem.title = @"订单";
    
    id<AYCommand> cmd_message_init = [self.commands objectForKey:@"MessageInit"];
    AYViewController* message = nil;
    [cmd_message_init performWithResult:&message];
    message.tabBarItem.title = @"消息";
    
    id<AYCommand> cmd_service_init = [self.commands objectForKey:@"MyServiceInit"];
    AYViewController* service = nil;
    [cmd_service_init performWithResult:&service];
    service.tabBarItem.title = @"日程";
    
    id<AYCommand> cmd_profile_init = [self.commands objectForKey:@"ProfileInit"];
    AYViewController* profile = nil;
    [cmd_profile_init performWithResult:&profile];
    profile.tabBarItem.title = @"我的";
    
    self.viewControllers = [NSArray arrayWithObjects:order, message, service, profile, nil];
    self.delegate = self;
    
    img_home_with_no_message = IMGRESOURCE(@"tab_home");
    img_home_with_unread_message = IMGRESOURCE(@"tab_home_unread");
    
    _dongda_tabbar = [[DongDaTabBar alloc]initWithBar:self];
    _dongda_tabbar.backgroundColor = [Tools blackColor];
    [_dongda_tabbar addItemWithImg:IMGRESOURCE(@"tab_order_white") andSelectedImg:IMGRESOURCE(@"tab_order_selected") andTitle:@"日程"];
    [_dongda_tabbar addItemWithImg:IMGRESOURCE(@"tab_message_white") andSelectedImg:IMGRESOURCE(@"tab_message_selected") andTitle:@"消息"];
    [_dongda_tabbar addItemWithImg:IMGRESOURCE(@"tab_service") andSelectedImg:IMGRESOURCE(@"tab_service_selected") andTitle:@"服务"];
    [_dongda_tabbar addItemWithImg:IMGRESOURCE(@"tab_profile_white") andSelectedImg:IMGRESOURCE(@"tab_profile_selected") andTitle:@"我的"];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6) {
        [[UITabBar appearance] setShadowImage:[UIImage new]];
        [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    }
    
//    dongda_tabbar.selectIndex = 3;
}

- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary *dic_exchange = [dic objectForKey:kAYControllerChangeArgsKey];
        NSNumber *type = [dic_exchange objectForKey:@"type"];
        isExchangeModel = type.intValue;
        
        NSNumber *index = [dic_exchange objectForKey:@"index"];
        expectIndex = index.intValue;
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (id)performForView:(id<AYViewBase>)from andFacade:(NSString*)facade_name andMessage:(NSString*)command_name andArgs:(NSDictionary*)args {
    @throw [[NSException alloc]initWithName:@"error" reason:@"不要在苹果自建Controller中调用Command函数" userInfo:nil];
}

- (id)startRemoteCall:(id)obj {
    return nil;
}

- (id)endRemoteCall:(id)obj {
    return nil;
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mode = DongDaAppModeNapPersonal;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (isExchangeModel != ModeExchangeTypeDissVC) {
        UIView *cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:cover];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:[NSNumber numberWithInt:DongDaAppModeNapPersonal] forKey:@"dongda_app_mode"];
        [defaults synchronize];
        
        self.selectedIndex = expectIndex;
        DongDaTabBarItem* btn = (DongDaTabBarItem*)[_dongda_tabbar viewWithTag:expectIndex];
        [_dongda_tabbar itemSelected:btn];
        
        if (isExchangeModel == ModeExchangeTypeCommonToNapPersonal || isExchangeModel == ModeExchangeTypeCommonToNapFamily) {
            
            NSString *tipString ;
            if (isExchangeModel == ModeExchangeTypeCommonToNapPersonal) {
                tipString = @"切换为服务者";
            } else if (isExchangeModel == ModeExchangeTypeCommonToNapFamily) {
                tipString = @"切换为看护家庭";
            }
            
            cover.backgroundColor = [Tools darkBackgroundColor];
            UILabel *tipsLabel = [Tools creatUILabelWithText:tipString andTextColor:[UIColor whiteColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:1];
            [cover addSubview:tipsLabel];
            [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cover).offset(-60);
                make.centerX.equalTo(cover);
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    cover.alpha = 0;
                } completion:^(BOOL finished) {
                    [cover removeFromSuperview];
                }];
            });
        } else if(isExchangeModel == ModeExchangeTypeUnloginToAllModel){
            cover.backgroundColor = [UIColor whiteColor];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.25 animations:^{
                    cover.alpha = 0;
                } completion:^(BOOL finished) {
                    [cover removeFromSuperview];
                }];
            });
        } else {
            [cover removeFromSuperview];
        }
        
        isExchangeModel = ModeExchangeTypeDissVC;
    }
}

#pragma mark -- tabbar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"select tab %@", item.title);
    
}

#pragma marks - tabbar controller delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([tabBarController.tabBar.selectedItem.title isEqualToString:@"Post"]) {
        return NO;
    }
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers {
    for (UIViewController * iter in viewControllers) {
        NSLog(@"%@", iter.title);
    }
}

#pragma mark -- actions
- (void)setCurrentIndex:(NSNumber*)index {
    self.selectedIndex = index.integerValue;
    DongDaTabBarItem* btn = (DongDaTabBarItem*)[_dongda_tabbar viewWithTag:3];
    [_dongda_tabbar itemSelected:btn];
}
@end
