//
//  AYPersonalSettingController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPersonalSettingController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
//#import "AYResourceManager.h"
#import "AYNotifyDefines.h"
#import "AYFacadeBase.h"
#import "AYSelfSettingCellDefines.h"

@implementation AYPersonalSettingController {
    NSDictionary* profile_dic;
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        profile_dic = [dic objectForKey:kAYControllerChangeArgsKey];
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYDelegateBase> delegate = [self.delegates objectForKey:@"SelfSetting"];

    id<AYCommand> cmd_ds = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_del = [view_table.commands objectForKey:@"registerDelegate:"];
   
    id obj = delegate;
    [cmd_del performWithResult:&obj];
    obj = delegate;
    [cmd_ds performWithResult:&obj];
    
    id<AYCommand> cmd = [delegate.commands objectForKey:@"changeQueryData:"];

    id args = profile_dic;
    [cmd performWithResult:&args];
    
    id<AYCommand> cmd_reg_table = [view_table.commands objectForKey:@"registerCellWithNib:"];
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYSelfSettingCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_reg_table performWithResult:&class_name];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark -- layouts
- (id)SetNevigationBarTitleLayout:(UIView*)view {
    ((UILabel*)view).text = @"设置";
    self.navigationItem.titleView = view;
    return nil;
}

- (id)SetNevigationBarLeftBtnLayout:(UIView*)view {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    return nil;
}

- (id)SetNevigationBarRightBtnLayout:(UIView*)view {
//    UIButton* btn 
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    view.hidden = YES;
    return nil;
}

- (id)TableLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    view.frame = CGRectMake(0, 0, width, height);
    
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    return nil;
}

#pragma mark -- actions
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
