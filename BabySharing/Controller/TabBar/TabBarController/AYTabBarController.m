//
//  AYTabBarController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYTabBarController.h"

#define SHOWALBUM       [self showPostController:@"CameraRollInit"]
#define SHOWCAMERA      [self showPostController:@"CameraInit"]
#define SHOWMOVIE       [self showPostController:@"MovieInit"]

@implementation AYTabBarController {

    UIImage* img_home_with_no_message;
    UIImage* img_home_with_unread_message;
    
    ModeExchangeType isExchangeModel;
    int expectIndex;
}

@synthesize para = _para;

@synthesize commands = _commands;
@synthesize facades = _facades;
@synthesize views = _views;
@synthesize delegates = _delegates;

#pragma mark -- commands
- (NSString*)getControllerName {
    return [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"TabBar"] stringByAppendingString:kAYFactoryManagerControllersuffix];
}

- (NSString*)getControllerType {
    return kAYFactoryManagerCatigoryController;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryController;
}

- (void)postPerform {
    
    id<AYCommand> cmd_home_init = [self.commands objectForKey:@"HomeInit"];
    AYViewController* home = nil;
    [cmd_home_init performWithResult:&home];
    home.tabBarItem.title = @"Home";

    id<AYCommand> cmd_friends_init = [self.commands objectForKey:@"MessageInit"];
    AYViewController* friends = nil;
    [cmd_friends_init performWithResult:&friends];
    friends.tabBarItem.title = @"Message";
    
    id<AYCommand> cmd_order_init = [self.commands objectForKey:@"OrderInit"];
    AYViewController* order = nil;
    [cmd_order_init performWithResult:&order];
    order.tabBarItem.title = @"order";
    
    id<AYCommand> cmd_profile_init = [self.commands objectForKey:@"ProfileInit"];
    AYViewController* profile = nil;
    [cmd_profile_init performWithResult:&profile];
    profile.tabBarItem.title = @"Profile";
    
    self.viewControllers = [NSArray arrayWithObjects:home, friends, order, profile, nil];
    self.delegate = self;
    
    img_home_with_no_message = IMGRESOURCE(@"tab_home");
    img_home_with_unread_message = IMGRESOURCE(@"tab_home_unread");
    
    _dongda_tabbar = [[DongDaTabBar alloc]initWithBar:self];
    [_dongda_tabbar addItemWithImg:img_home_with_no_message andSelectedImg:IMGRESOURCE(@"tab_home_selected") andTitle:@"主页"];
    [_dongda_tabbar addItemWithImg:IMGRESOURCE(@"tab_message") andSelectedImg:IMGRESOURCE(@"tab_message_selected") andTitle:@"消息"];
    [_dongda_tabbar addItemWithImg:IMGRESOURCE(@"tab_order") andSelectedImg:IMGRESOURCE(@"tab_order_selected") andTitle:@"日程"];
    [_dongda_tabbar addItemWithImg:IMGRESOURCE(@"tab_profile") andSelectedImg:IMGRESOURCE(@"tab_profile_selected") andTitle:@"我的"];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6) {
        [[UITabBar appearance] setShadowImage:[UIImage new]];
        [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    }
}

- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary *dic_exchange = [dic objectForKey:kAYControllerChangeArgsKey];
        NSNumber *type = [dic_exchange objectForKey:@"type"];
        isExchangeModel = type.intValue;
        
        NSNumber *index = [dic_exchange objectForKey:@"index"];
        expectIndex = index.intValue;
        
//        NSNumber* index = [dic objectForKey:kAYControllerChangeArgsKey];
//        switch (index.integerValue) {
//            case 0:
//                SHOWALBUM;
//                break;
//            case 1:
//                SHOWCAMERA;
//                break;
//            case 2:
//                SHOWMOVIE;
//                break;
//                
//            default:
//                @throw [[NSException alloc]initWithName:@"error" reason:@"wrong args" userInfo:nil];
//                break;
//        }
        
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
    self.mode = DongDaAppModeCommon;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (isExchangeModel != ModeExchangeTypeDissVC) {
        self.selectedIndex = expectIndex;
        DongDaTabBarItem* btn = (DongDaTabBarItem*)[_dongda_tabbar viewWithTag:expectIndex];
        [_dongda_tabbar itemSelected:btn];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:[NSNumber numberWithInt:DongDaAppModeCommon] forKey:@"dongda_app_mode"];
        [defaults synchronize];
        
        UIView *cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:cover];
        
        if (isExchangeModel == ModeExchangeTypeNapToCommon) {
            
            cover.backgroundColor = [Tools darkBackgroundColor];
            UILabel *tipsLabel = [[UILabel alloc]init];
            tipsLabel = [Tools setLabelWith:tipsLabel andText:@"切换为预订模式" andTextColor:[UIColor whiteColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:1];
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
        } else if(isExchangeModel == ModeExchangeTypeUnloginToAllModel) {
            cover.backgroundColor = [UIColor whiteColor];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.75 animations:^{
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
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//    NSLog(@"select tab %@", item.title);
//    
//    if ([item.title isEqualToString:@"Post"]) {
//        SHOWCAMERA;
//        
//    } else {
////        int count = [GotyeOCAPI getTotalUnreadMessageCount];
////        if (count > 0) {
////            [dongda_tabbar changeItemImage:img_home_with_unread_message andIndex:0];
////        } else {
////            [dongda_tabbar changeItemImage:img_home_with_no_message andIndex:0];
////        }
//    }
//}

#pragma marks - tabbar controller delegate
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
//{
//    if ([tabBarController.tabBar.selectedItem.title isEqualToString:@"Post"]) {
//        return NO;
//    }
//    
////    if (backView.hidden == NO) {
////        return NO;
////    }
//    
//    return YES;
//}

- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers {
    for (UIViewController * iter in viewControllers) {
        NSLog(@"%@", iter.title);
    }
}

#pragma mark -- actions
- (void)showPostController:(NSString*)name {
   
    AYViewController* des = nil;
    id<AYCommand> cmd = [self.commands objectForKey:name];
    [cmd performWithResult:&des];
    
    NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc]init];
    [dic_show_module setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
    [dic_show_module setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_show_module setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd_show_module = SHOWMODULEUP;
    [cmd_show_module performWithResult:&dic_show_module];
}

- (void)setCurrentIndex:(NSDictionary*)args {
    
    NSNumber *index = [args objectForKey:@"to_index"];
//    self.selectedIndex = index.integerValue;
//    DongDaTabBarItem* btn = (DongDaTabBarItem*)[_dongda_tabbar viewWithTag:index.integerValue];
//    [_dongda_tabbar itemSelected:btn];
    
    AYViewController *soure = [args objectForKey:@"from"];
    AYViewController *des = [args objectForKey:@"to"];
    
    [UIView transitionFromView:[soure view] toView:[des view] duration:0.5f options:UIViewAnimationOptionCurveEaseInOut completion:^(BOOL finished) {
        
        if (finished) {
            UIButton *btn = [_dongda_tabbar viewWithTag:index.integerValue];
            [_dongda_tabbar itemSelected:btn];
        }
    }];
    
}


@end
