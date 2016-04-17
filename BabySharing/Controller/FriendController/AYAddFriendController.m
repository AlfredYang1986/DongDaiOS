//
//  AYAddFriendController.m
//  BabySharing
//
//  Created by Alfred Yang on 14/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYAddFriendController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "OBShapedButton.h"
#import "AYResourceManager.h"
#import "AYNotifyDefines.h"
#import "AYDongDaSegDefines.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYUserDisplayDefines.h"
#import "AYResourceManager.h"
#import "SearchSegImgTextItem.h"

#import "AppDelegate.h"
#import "AYFacade.h"
#import "AYViewBase.h"
#import "AYModel.h"

@class AYDongDaSegView;
#define kSCREENW [UIScreen mainScreen].bounds.size.width
#define kSCREENH [UIScreen mainScreen].bounds.size.height

#define SEARCH_BAR_HEIGHT           0 //44
#define SEGAMENT_HEGHT              46

#define SEARCH_BAR_MARGIN_TOP       0
#define SEARCH_BAR_MARGIN_BOT       -2

#define SEGAMENT_MARGIN_BOTTOM      10.5
#define BOTTOM_BAR_HEIGHT           49

@interface AYAddFriendController ()

@end

@implementation AYAddFriendController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    {
        id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
        id<AYCommand> cmd_view_title = [view_title.commands objectForKey:@"changeNevigationBarTitle:"];
        NSString* title = @"添加好友";
        [cmd_view_title performWithResult:&title];
    }
    
    {
        id<AYViewBase> view_friend = [self.views objectForKey:@"Table"];
        id<AYDelegateBase> cmd_relations = [self.delegates objectForKey:@"ContacterList"];
        
        id<AYCommand> cmd_datasource = [view_friend.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_friend.commands objectForKey:@"registerDelegate:"];
        
        id obj = (id)cmd_relations;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_relations;
        [cmd_delegate performWithResult:&obj];
    }
    
    id<AYViewBase> view_contacter_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_hot_cell = [view_contacter_table.commands objectForKey:@"registerCellWithNib:"];
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYUserDisplayTableCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_hot_cell performWithResult:&class_name];
    
}

#pragma mark -- layout commands

- (id)SearchFriendLayout:(UIView*)view {
    
    view.frame = CGRectMake( 20, 6,  kSCREENW - 40, 36);
    [((UIButton*)view) setTitle:@"搜索好友" forState:UIControlStateNormal];
    [((UIButton*)view) setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    ((UIButton*)view).titleLabel.font = [UIFont systemFontOfSize:14.f];
    [((UIButton*)view) setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [((UIButton*)view).layer setMasksToBounds:YES];
    [((UIButton*)view).layer setCornerRadius:3.0];
//    [((UIButton*)view) addSubview:iv];
    
    view.backgroundColor = [UIColor darkGrayColor];
    return nil;
}


- (id)TableLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, 128, kSCREENW, kSCREENH - 124);
//    view.backgroundColor = [UIColor grayColor];
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    return nil;
}

- (id)DongDaSegLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, 48, kSCREENW, 80);
    {
        id<AYViewBase> seg = (id<AYViewBase>)view;
        id<AYCommand> cmd_info = [seg.commands objectForKey:@"setSegInfo:"];
        
        id<AYCommand> cmd_add_item = [seg.commands objectForKey:@"addItem:"];
        NSMutableDictionary* dic_add_item_0 = [[NSMutableDictionary alloc]init];
        [dic_add_item_0 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitleWithImage] forKey:kAYSegViewItemTypeKey];
        [dic_add_item_0 setValue:@"通讯录" forKey:kAYSegViewTitleKey];
        [dic_add_item_0 setValue:PNGRESOURCE(@"friend_address_book") forKey:kAYSegViewNormalImageKey];
        [dic_add_item_0 setValue:PNGRESOURCE(@"friend_address_book_selected") forKey:kAYSegViewSelectedImageKey];
        [cmd_add_item performWithResult:&dic_add_item_0];
        
        NSMutableDictionary* dic_add_item_1 = [[NSMutableDictionary alloc]init];
        [dic_add_item_1 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitleWithImage] forKey:kAYSegViewItemTypeKey];
        [dic_add_item_1 setValue:@"微信" forKey:kAYSegViewTitleKey];
        [dic_add_item_1 setValue:PNGRESOURCE(@"friend_wechat") forKey:kAYSegViewNormalImageKey];
        [dic_add_item_1 setValue:PNGRESOURCE(@"friend_wechat") forKey:kAYSegViewSelectedImageKey];
        [cmd_add_item performWithResult:&dic_add_item_1];
        
        NSMutableDictionary* dic_add_item_2 = [[NSMutableDictionary alloc]init];
        [dic_add_item_2 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitleWithImage] forKey:kAYSegViewItemTypeKey];
        [dic_add_item_2 setValue:@"QQ好友" forKey:kAYSegViewTitleKey];
        [dic_add_item_2 setValue:PNGRESOURCE(@"friend_qq") forKey:kAYSegViewNormalImageKey];
        [dic_add_item_2 setValue:PNGRESOURCE(@"friend_qq") forKey:kAYSegViewSelectedImageKey];
        [cmd_add_item performWithResult:&dic_add_item_2];
        
        NSMutableDictionary* dic_user_info = [[NSMutableDictionary alloc]init];
        [dic_user_info setValue:[NSNumber numberWithInt:-1] forKey:kAYSegViewCurrentSelectKey];
        [dic_user_info setValue:[NSNumber numberWithFloat:0.0933f * [UIScreen mainScreen].bounds.size.width] forKey:kAYSegViewMarginBetweenKey];
        
        [cmd_info performWithResult:&dic_user_info];
    }
    
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
- (id)touchUpInside {
    NSLog(@"search friends btn selected");
    
//    id<AYCommand> SearchFriend = DEFAULTCONTROLLER(@"SearchFriend");
//    
//    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
//    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
//    [dic setValue:SearchFriend forKey:kAYControllerActionDestinationControllerKey];
//    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [self performWithResult:&dic];
//    
    return nil;
}

#pragma mark -- notification
- (id)segValueChanged:(id)obj {
    NSLog(@"addfriend controller seg cheanged");
    
    id<AYViewBase> seg = (id<AYViewBase>)obj;
    id<AYCommand> cmd = [seg.commands objectForKey:@"queryCurrentSelectedIndex"];
    
//    id<AYViewBase> seg = (id<AYViewBase>)view;
    id<AYCommand> cmd_info = [seg.commands objectForKey:@"setSegInfo:"];
    
    NSNumber* index = nil;
    [cmd performWithResult:&index];
    NSLog(@"controller output current index %@", index);
    
    if (index.integerValue == 1) {
        index = [NSNumber numberWithInt:index.integerValue > 0 ? 0 : -1];
        
        
        
    }else if (index.integerValue == 2){
        index = [NSNumber numberWithInt:index.integerValue > 0 ? 0 : -1];
        
        
        
    }else {
        
//        AYFacade* f = [self.facades objectForKey:@"LoginModel"];
//        AYRemoteCallCommand* cmd_contacter = [f.commands objectForKey:@"QueryCurrentLoginUser"];
//        
//        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//        [dic setValue:self.current_user_id forKey:@"user_id"];
//        [dic setValue:self.current_auth_token forKey:@"auth_token"];
//        [dic setValue:user_lst forKey:@"lst"];
//        [dic setValue:provider_name forKey:@"provider_name"];
//        
//        [cmd_contacter performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
//            if (success) {
//                
//            } else {
//                
//            }
//        }];
        
    }
    
    NSMutableDictionary *dic_user_info = [[NSMutableDictionary alloc]init];
    [dic_user_info setObject:index forKey:kAYSegViewCurrentSelectKey];
    [cmd_info performWithResult:&dic_user_info];
    
    return nil;
}

- (void)showData:(NSString*)ready_func_name changFunc:(NSString*)change_func_name queryFunc:(NSString*)query_func_name resultKey:(NSString*)result_key {
    
    
}

#pragma mark -- notification pop view controller
- (id)popToPreviousWithoutSave {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

@end
