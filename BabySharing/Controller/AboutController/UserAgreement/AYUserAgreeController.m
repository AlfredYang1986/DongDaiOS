//
//  AYUserAgreeController.m
//  BabySharing
//
//  Created by Alfred Yang on 13/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYUserAgreeController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "OBShapedButton.h"
#import "AYResourceManager.h"
#import "AYNotifyDefines.h"
#import "AYFacadeBase.h"

#define SCREEN_WIDTH                [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT               [UIScreen mainScreen].bounds.size.height

@interface AYUserAgreeController ()

@end

@implementation AYUserAgreeController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
        id<AYCommand> cmd_title = [view_title.commands objectForKey:@"changeNevigationBarTitle:"];
        NSString* title = @"咚哒用户协议";
        [cmd_title performWithResult:&title];
        
    }
    
    {
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
        
        id<AYDelegateBase> cmd_user_agreement = [self.delegates objectForKey:@"UserAgree"];
        
        id obj = (id)cmd_user_agreement;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_user_agreement;
        [cmd_delegate performWithResult:&obj];
        
    }
    
    
    OBShapedButton* state = [[OBShapedButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - 49 - 44, SCREEN_WIDTH, 44)];
    [state setBackgroundImage:PNGRESOURCE(@"profile_logout_btn_bg") forState:UIControlStateNormal];
    state.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [state setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [state setTitle:@"登陆即表示同意用户协议" forState:UIControlStateNormal];
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    [(UIView*)view_table addSubview:state];
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

- (void)signOutSelected{
    NSLog(@"AboutButton onClick");
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


@end
