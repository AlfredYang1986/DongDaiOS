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

#define SCREEN_WIDTH                [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT               [UIScreen mainScreen].bounds.size.height
#define SHOW_OFFSET_Y               SCREEN_HEIGHT - (196+64)

@interface AYPersonalSettingController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@end

@implementation AYPersonalSettingController {
    
    NSMutableDictionary* profile_dic;
    
    NSMutableDictionary* change_profile_dic;
    UIImage *changeOwnerImage;
    NSString *changeImageName;
    BOOL isUserPhotoChanged;
    
    UIImageView *user_photo;

    UIView *pickerView;
}


#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        profile_dic = [[dic objectForKey:kAYControllerChangeArgsKey] mutableCopy];
        
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
    self.view.backgroundColor = [Tools garyBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    change_profile_dic = [[NSMutableDictionary alloc]init];
    
    user_photo = [[UIImageView alloc]init];
    [self.view addSubview:user_photo];
    user_photo.image = IMGRESOURCE(@"default_user");
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
    
    
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[profile_dic objectForKey:@"screen_photo"] forKey:@"image"];
    [dic setValue:@"img_thum" forKey:@"expect_size"];
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        UIImage* img = (UIImage*)result;
        if (img != nil) {
            [user_photo setImage:img];
        }
    }];
    
    id<AYViewBase> setting = [self.views objectForKey:@"SelfSetting"];
    id<AYCommand> set_cmd = [setting.commands objectForKey:@"setPersonalInfo:"];
    NSDictionary *info = profile_dic;
    [set_cmd performWithResult:&info];
    
    {
        id<AYViewBase> view_picker = [self.views objectForKey:@"Picker"];
        pickerView = (UIView*)view_picker;
        [self.view bringSubviewToFront:pickerView];
        id<AYCommand> cmd_datasource = [view_picker.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_picker.commands objectForKey:@"registerDelegate:"];
        
        id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"NapArea"];
        
        id obj = (id)cmd_recommend;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_recommend;
        [cmd_delegate performWithResult:&obj];
    }
    
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

- (id)PickerLayout:(UIView*)view{
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
    view.backgroundColor = [Tools garyColor];
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

- (void)popToPreviousWithSave {
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_pop setValue:profile_dic forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
}

- (id)rightItemBtnClick {
    NSLog(@"save btn clicked");
   
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 30.f * NSEC_PER_SEC));
    
    __block BOOL isUploadUserImageSuccess;
    
    if (isUserPhotoChanged) {
        AYRemoteCallCommand* up_cmd = COMMAND(@"Remote", @"UploadUserImage");
        NSMutableDictionary *up_dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [up_dic setValue:changeImageName forKey:@"image"];
        [up_dic setValue:changeOwnerImage forKey:@"upload_image"];
        [up_cmd performWithResult:[up_dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            NSLog(@"upload result are %d", success);
            if (success) {
                isUserPhotoChanged = NO;
                dispatch_semaphore_signal(semaphore);
                isUploadUserImageSuccess = YES;
            } else {
                [[[UIAlertView alloc]initWithTitle:@"错误" message:@"头像上传失败，请重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
                dispatch_semaphore_signal(semaphore);
                isUploadUserImageSuccess = NO;
            }
        }];
    }
    
    if (isUploadUserImageSuccess) {
        
        NSDictionary* user = nil;
        CURRENUSER(user);
        
        id<AYFacadeBase> f = [self.facades objectForKey:@"ProfileRemote"];
        AYRemoteCallCommand* cmd = [f.commands objectForKey:@"UpdateUserDetail"];
        [change_profile_dic setValue:[user objectForKey:@"user_id"] forKeyPath:@"user_id"];
        [change_profile_dic setValue:[user objectForKey:@"auth_token"] forKeyPath:@"auth_token"];
        
        [cmd performWithResult:[change_profile_dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            if (success) {
                [[[UIAlertView alloc]initWithTitle:@"个人设置" message:@"保存用户信息成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
                [self popToPreviousWithSave];
            } else {
                [[[UIAlertView alloc]initWithTitle:@"错误" message:@"保存用户信息失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
            }
        }];
    }
    
    return nil;
}

#pragma mark -- pickerviewDelegate
- (id)showPickerView {
    
    if (pickerView.frame.origin.y == SCREEN_HEIGHT) {
        [UIView animateWithDuration:0.25 animations:^{
            pickerView.frame = CGRectMake(0, SHOW_OFFSET_Y, SCREEN_WIDTH, 196);
            NSLog(@"%f",pickerView.frame.origin.y);
        }];
    }
    return nil;
}

-(id)didSaveClick {
    
    id<AYDelegateBase> cmd_commend = [self.delegates objectForKey:@"NapArea"];
    id<AYCommand> cmd_index = [cmd_commend.commands objectForKey:@"queryCurrentSelected:"];
    NSString *address = nil;
    [cmd_index performWithResult:&address];
    
    if (address) {
        [change_profile_dic setValue:address forKey:@"address"];
        [profile_dic setValue:address forKey:@"address"];
        id<AYViewBase> view_picker = [self.views objectForKey:@"SelfSetting"];
        id<AYCommand> change = [view_picker.commands objectForKey:@"changeAdrss:"];
        [change performWithResult:&address];
    }
    
    if (pickerView.frame.origin.y == SHOW_OFFSET_Y) {
        
        [UIView animateWithDuration:0.25 animations:^{
            pickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
        }];
    }
    return nil;
}
-(id)didCancelClick {
    
    [UIView animateWithDuration:0.25 animations:^{
        pickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
    }];
    return nil;
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    changeOwnerImage = image;
    user_photo.image = image;
    isUserPhotoChanged = YES;
    // get image name
    id<AYCommand> uuid_cmd = [self.commands objectForKey:@"GernarateImgUUID"];
    NSString* img_name = nil;
    [uuid_cmd performWithResult:&img_name];
    changeImageName = img_name;
    NSLog(@"new image name is %@", img_name);
//    [_login_attr setValue:img_name forKey:@"screen_photo"];

    // sava image to local
    id<AYCommand> save_cmd = [self.commands objectForKey:@"SaveImgLocal"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:img_name forKey:@"img_name"];
    [dic setValue:image forKey:@"image"];
    [save_cmd performWithResult:&dic];
    
    [change_profile_dic setValue:img_name forKey:@"screen_photo"];
    [profile_dic setValue:img_name forKey:@"screen_photo"];
}

- (id)screenNameChanged:(NSString*)args {
    [change_profile_dic setValue:args forKey:@"screen_name"];
    [profile_dic setValue:args forKey:@"screen_name"];
    return nil;
}

- (id)addressChanged:(NSString*)args {
    [change_profile_dic setValue:args forKey:@"role_tag"];
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
