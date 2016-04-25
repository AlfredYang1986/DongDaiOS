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
#import "AYNotifyDefines.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYSelfSettingCellDefines.h"

@interface AYPersonalSettingController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation AYPersonalSettingController {
    NSDictionary* profile_dic;
    
    NSDictionary* change_profile_dic;
//    UIButton* btn_save;
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        profile_dic = [dic objectForKey:kAYControllerChangeArgsKey];
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        NSString* role_tag = [dic objectForKey:kAYControllerChangeArgsKey];
        if (change_profile_dic == nil) {
            change_profile_dic = [[NSMutableDictionary alloc]init];
        }
        [change_profile_dic setValue:role_tag forKey:@"role_tag"];
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
   
    change_profile_dic = [[NSMutableDictionary alloc]init];
    
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
    
    id<AYCommand> cmd_reg_table = [view_table.commands objectForKey:@"registerCellWithClass:"];
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
    NSString* str = @"保存";
    id<AYCommand> cmd = [((id<AYViewBase>)view).commands objectForKey:@"changeTextBtn:"];
    [cmd performWithResult:&str];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
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

- (id)rightItemBtnClick {
    NSLog(@"save btn clicked");
   
    id<AYFacadeBase> f = [self.facades objectForKey:@"ProfileRemote"];
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"UpdateUserDetail"];
    
    NSDictionary* user = nil;
    CURRENUSER(user);
    
    [change_profile_dic setValue:[user objectForKey:@"user_id"] forKeyPath:@"user_id"];
    [change_profile_dic setValue:[user objectForKey:@"auth_token"] forKeyPath:@"auth_token"];
  
    [cmd performWithResult:[change_profile_dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            [[[UIAlertView alloc]initWithTitle:@"success" message:@"保存用户信息成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
            [self popToPreviousWithoutSave];
        } else {
            [[[UIAlertView alloc]initWithTitle:@"error" message:@"保存用户信息失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
        }
    }];
    
    return nil;
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // get image name
    id<AYCommand> uuid_cmd = [self.commands objectForKey:@"GernarateImgUUID"];
    NSString* img_name = nil;
    [uuid_cmd performWithResult:&img_name];
    NSLog(@"new image name is %@", img_name);
//    [_login_attr setValue:img_name forKey:@"screen_photo"];

    // sava image to local
    id<AYCommand> save_cmd = [self.commands objectForKey:@"SaveImgLocal"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:img_name forKey:@"img_name"];
    [dic setValue:image forKey:@"image"];
    [save_cmd performWithResult:&dic];

    id<AYDelegateBase> del = [self.delegates objectForKey:@"SelfSetting"];
    id<AYCommand> cmd = [del.commands objectForKey:@"changeScreenPhoto:"];
    id args = img_name;
    [cmd performWithResult:&args];
    
    id<AYViewBase> table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_refresh = [table.commands objectForKey:@"refresh"];
    [cmd_refresh performWithResult:nil];
    
    [change_profile_dic setValue:img_name forKey:@"screen_photo"];
}

- (id)screenNameChanged:(id)args {
    NSString* screen_name = (NSString*)args;
    [change_profile_dic setValue:screen_name forKey:@"screen_name"];
    return nil;
}

//用户取消拍照
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
