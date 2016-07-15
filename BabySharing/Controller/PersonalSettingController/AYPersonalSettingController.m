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
#import "Tools.h"
#import "AYSelfSettingCellView.h"

#define SCREEN_WIDTH                    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                   [UIScreen mainScreen].bounds.size.height

@interface AYPersonalSettingController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@end

@implementation AYPersonalSettingController {
    NSDictionary* profile_dic;
    
    NSDictionary* change_profile_dic;
    UIImage *changeOwnerImage;
    NSString *changeImageName;
    
    UIImageView *user_photo;
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
        
        NSMutableDictionary* dic = [profile_dic mutableCopy];
        
        for (NSString* key in change_profile_dic.allKeys) {
            [dic setValue:[change_profile_dic objectForKey:key] forKey:key];
        }
        
        id<AYDelegateBase> delegate = [self.delegates objectForKey:@"SelfSetting"];
        id<AYCommand> cmd = [delegate.commands objectForKey:@"changeQueryData:"];
        [cmd performWithResult:&dic];
        id<AYViewBase> table = [self.views objectForKey:@"Table"];
        id<AYCommand> cmd_refresh = [table.commands objectForKey:@"refresh"];
        [cmd_refresh performWithResult:nil];
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    change_profile_dic = [[NSMutableDictionary alloc]init];
    
    user_photo = [[UIImageView alloc]init];
    [self.view addSubview:user_photo];
    user_photo.image = IMGRESOURCE(@"lol");
    user_photo.layer.cornerRadius = 50.f;
    user_photo.clipsToBounds = YES;
    user_photo.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25f].CGColor;
    user_photo.layer.borderWidth = 2.f;
    [user_photo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    user_photo.userInteractionEnabled = YES;
    [user_photo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelfPhotoClick:)]];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark -- layouts
- (id)SetNevigationBarTitleLayout:(UIView*)view {
    ((UILabel*)view).text = @"个人资料";
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

- (id)SelfSettingLayout:(UIView*)view {
    CGFloat margin = 20;
    view.frame = CGRectMake(margin, 150, SCREEN_WIDTH - margin * 2, 200);
    
//    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
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
   
//    AYRemoteCallCommand* up_cmd = COMMAND(@"Remote", @"UploadUserImage");
//    NSMutableDictionary *up_dic = [[NSMutableDictionary alloc]initWithCapacity:2];
//    [up_dic setValue:changeImageName forKey:@"image"];
//    [up_dic setValue:changeOwnerImage forKey:@"upload_image"];
//    [up_cmd performWithResult:[up_dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
//        NSLog(@"upload result are %d", success);
//    }];
//    
//    id<AYFacadeBase> f = [self.facades objectForKey:@"ProfileRemote"];
//    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"UpdateUserDetail"];
//    
//    NSDictionary* user = nil;
//    CURRENUSER(user);
//    
//    [change_profile_dic setValue:[user objectForKey:@"user_id"] forKeyPath:@"user_id"];
//    [change_profile_dic setValue:[user objectForKey:@"auth_token"] forKeyPath:@"auth_token"];
//  
//    [cmd performWithResult:[change_profile_dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
//        if (success) {
//            [[[UIAlertView alloc]initWithTitle:@"个人设置" message:@"保存用户信息成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
//            [self popToPreviousWithoutSave];
//        } else {
//            [[[UIAlertView alloc]initWithTitle:@"错误" message:@"保存用户信息失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
//        }
//    }];
    
    return nil;
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    changeOwnerImage = image;
    user_photo.image = image;
    
    // get image name
//    id<AYCommand> uuid_cmd = [self.commands objectForKey:@"GernarateImgUUID"];
//    NSString* img_name = nil;
//    [uuid_cmd performWithResult:&img_name];
//    changeImageName = img_name;
//    NSLog(@"new image name is %@", img_name);
////    [_login_attr setValue:img_name forKey:@"screen_photo"];
//
//    // sava image to local
//    id<AYCommand> save_cmd = [self.commands objectForKey:@"SaveImgLocal"];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:img_name forKey:@"img_name"];
//    [dic setValue:image forKey:@"image"];
//    [save_cmd performWithResult:&dic];
//
//    id<AYDelegateBase> del = [self.delegates objectForKey:@"SelfSetting"];
//    id<AYCommand> cmd = [del.commands objectForKey:@"changeScreenPhoto:"];
//    id args = img_name;
//    [cmd performWithResult:&args];
//    
//    id<AYViewBase> table = [self.views objectForKey:@"Table"];
//    id<AYCommand> cmd_refresh = [table.commands objectForKey:@"refresh"];
//    [cmd_refresh performWithResult:nil];
//    
//    [change_profile_dic setValue:img_name forKey:@"screen_photo"];
}

- (id)screenNameChanged:(id)args {
    NSString* screen_name = (NSString*)args;
    [change_profile_dic setValue:screen_name forKey:@"screen_name"];
    return nil;
}

- (id)scrollToHideKeyBoard {
    return nil;
}

//用户取消拍照
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {
    NSLog(@"tap esle where");
    id<AYViewBase> view = [self.views objectForKey:@"SelfSetting"];
    id<AYCommand> cmd = [view.commands objectForKey:@"hideKeyboard"];
    [cmd performWithResult:nil];
}

-(void)didSelfPhotoClick:(UIGestureRecognizer*)tap{
    [self tapElseWhere:nil];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
        [self performForView:nil andFacade:nil andMessage:@"OpenUIImagePickerCamera" andArgs:[dic copy]];
    } else if (buttonIndex == 1) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
        [self performForView:nil andFacade:nil andMessage:@"OpenUIImagePickerPicRoll" andArgs:[dic copy]];
    }
}
@end
