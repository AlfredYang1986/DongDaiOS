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
#import "AYSelfSettingCellView.h"

#define SHOW_OFFSET_Y               SCREEN_HEIGHT - 196

@interface AYPersonalSettingController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@end

@implementation AYPersonalSettingController {
    
    NSMutableDictionary* profile_dic;
    NSMutableDictionary* change_profile_dic;
    
    UIImage *changeOwnerImage;
    NSString *changeImageName;
    BOOL isUserPhotoChanged;
    
    UIImageView *user_photo;
    UITextField *nameTextField;
    UILabel *descLabel;
//    UIView *pickerView;
}


#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        profile_dic = [[dic objectForKey:kAYControllerChangeArgsKey] mutableCopy];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        NSString* personal_desc = [dic objectForKey:kAYControllerChangeArgsKey];
        descLabel.text = personal_desc;
        [change_profile_dic setValue:personal_desc forKey:@"personal_description"];
        [profile_dic setValue:personal_desc forKey:@"personal_description"];
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
    user_photo.image = IMGRESOURCE(@"default_image");
//    user_photo.layer.cornerRadius = 50.f;
//    user_photo.clipsToBounds = YES;
//    user_photo.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25f].CGColor;
//    user_photo.layer.borderWidth = 2.f;
    user_photo.contentMode = UIViewContentModeScaleAspectFill;
    user_photo.clipsToBounds = YES;
    [user_photo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 250));
    }];
    
    UIButton *cameraBtn = [UIButton new];
    [cameraBtn setImage:IMGRESOURCE(@"camera") forState:UIControlStateNormal];
    [self.view addSubview:cameraBtn];
    [cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(user_photo).offset(-15);
        make.bottom.equalTo(user_photo).offset(-15);
        make.size.mas_equalTo(CGSizeMake(69, 69));
    }];
    [cameraBtn addTarget:self action:@selector(didSelfPhotoClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[profile_dic objectForKey:@"screen_photo"] forKey:@"image"];
    [dic setValue:@"img_local" forKey:@"expect_size"];
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        UIImage* img = (UIImage*)result;
        if (img != nil) {
            [user_photo setImage:img];
        }
    }];
    
    UILabel *nameLabel = [Tools creatUILabelWithText:@"姓名" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(user_photo.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
    }];
    
    nameTextField = [[UITextField alloc]init];
    nameTextField.font = kAYFontLight(14.f);
    nameTextField.textColor = [Tools garyColor];
    nameTextField.placeholder = @"请输入姓名";
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:nameTextField];
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(nameLabel.mas_bottom).offset(15);
    }];
    NSString *nameStr = [profile_dic objectForKey:@"screen_name"];
    nameTextField.text = nameStr;
    
    UIView *separtor = [UIView new];
    separtor.backgroundColor = [Tools garyLineColor];
    [self.view addSubview:separtor];
    [separtor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTextField.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 1));
    }];
    
    UILabel *descTitleLabel = [Tools creatUILabelWithText:@"关于我" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:descTitleLabel];
    [descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separtor.mas_bottom).offset(20);
        make.left.equalTo(nameLabel);
    }];
    
    descLabel = [Tools creatUILabelWithText:nil andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    descLabel.numberOfLines = 0;
    [self.view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descTitleLabel.mas_bottom).offset(15);
        make.left.equalTo(nameLabel);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    NSString *descStr = [profile_dic objectForKey:@"personal_description"];
    if (descStr && ![descStr isEqualToString:@""]) {
        descLabel.text = descStr;
    } else
        descLabel.text = @"描述一下自己的经历";
    
    descLabel.userInteractionEnabled = YES;
    [descLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didDescLabelTap:)]];
    
//    id<AYViewBase> setting = [self.views objectForKey:@"SelfSetting"];
//    id<AYCommand> set_cmd = [setting.commands objectForKey:@"setPersonalInfo:"];
//    NSDictionary *info = profile_dic;
//    [set_cmd performWithResult:&info];
    
//    {
//        id<AYViewBase> view_picker = [self.views objectForKey:@"Picker"];
//        pickerView = (UIView*)view_picker;
//        [self.view bringSubviewToFront:pickerView];
//        id<AYCommand> cmd_datasource = [view_picker.commands objectForKey:@"registerDatasource:"];
//        id<AYCommand> cmd_delegate = [view_picker.commands objectForKey:@"registerDelegate:"];
//        
//        id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"NapArea"];
//        
//        id obj = (id)cmd_recommend;
//        [cmd_datasource performWithResult:&obj];
//        obj = (id)cmd_recommend;
//        [cmd_delegate performWithResult:&obj];
//    }
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    view.backgroundColor = [UIColor whiteColor];
    
    NSString *title = @"个人资料";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil];
    [bar_right_btn sizeToFit];
    bar_right_btn.center = CGPointMake(SCREEN_WIDTH - 15.5 - bar_right_btn.frame.size.width / 2, 44 / 2);
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)SelfSettingLayout:(UIView*)view {
    CGFloat margin = 20;
    view.frame = CGRectMake(margin, 214, SCREEN_WIDTH - margin * 2, 200);
    return nil;
}

- (id)PickerLayout:(UIView*)view{
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
    view.backgroundColor = [Tools garyColor];
    return nil;
}

- (id)LoadingLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    view.hidden = YES;
    return nil;
}

#pragma mark -- actions
- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {
    
    if ([nameTextField isFirstResponder]) {
        [nameTextField resignFirstResponder];
    }
//    id<AYViewBase> view = [self.views objectForKey:@"SelfSetting"];
//    id<AYCommand> cmd = [view.commands objectForKey:@"hideKeyboard"];
//    [cmd performWithResult:nil];
}

- (void)didDescLabelTap:(UITapGestureRecognizer*)gusture {
    
    AYViewController* des = DEFAULTCONTROLLER(@"PersonalDesc");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    if (![descLabel.text isEqualToString:@"描述一下自己的经历"]) {
        [dic_push setValue:descLabel.text forKey:kAYControllerChangeArgsKey];
    }
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (id)leftBtnSelected {
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)rightBtnSelected {
    
//    dispatch_queue_t qp = dispatch_queue_create("post thread", nil);
//    dispatch_async(qp, ^{
//        
//    });
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 30.f * NSEC_PER_SEC));
    
    if (isUserPhotoChanged) {
        AYRemoteCallCommand* up_cmd = COMMAND(@"Remote", @"UploadUserImage");
        NSMutableDictionary *up_dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [up_dic setValue:changeImageName forKey:@"image"];
        [up_dic setValue:changeOwnerImage forKey:@"upload_image"];
        [up_cmd performWithResult:[up_dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            NSLog(@"upload result are %d", success);
            if (success) {
                isUserPhotoChanged = NO;
//                dispatch_semaphore_signal(semaphore);
                [self updatePersonalInfo];
            } else {
                [[[UIAlertView alloc]initWithTitle:@"错误" message:@"头像上传失败，请重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
//                dispatch_semaphore_signal(semaphore);
            }
        }];
        
    } else {
        [self updatePersonalInfo];
    }
    return nil;
}

- (void)updatePersonalInfo {
    NSDictionary* user = nil;
    CURRENUSER(user);
    id<AYFacadeBase> f = [self.facades objectForKey:@"ProfileRemote"];
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"UpdateUserDetail"];
    [change_profile_dic setValue:[user objectForKey:@"user_id"] forKeyPath:@"user_id"];
    [change_profile_dic setValue:[user objectForKey:@"auth_token"] forKeyPath:@"auth_token"];
    [change_profile_dic setValue:nameTextField.text forKey:@"screen_name"];
    [cmd performWithResult:[change_profile_dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            [[[UIAlertView alloc]initWithTitle:@"个人设置" message:@"保存用户信息成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            [self popToPreviousWithSave];
        } else {
            [[[UIAlertView alloc]initWithTitle:@"错误" message:@"保存用户信息失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }
    }];
}

- (void)popToPreviousWithSave {
    
//    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
//    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
//    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [profile_dic setValue:nameTextField.text forKey:@"screen_name"];
//    [dic_pop setValue:[profile_dic copy] forKey:kAYControllerChangeArgsKey];
//    
//    id<AYCommand> cmd = POP;
//    [cmd performWithResult:&dic_pop];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:[NSNumber numberWithBool:YES] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POPTOROOT;
    [cmd performWithResult:&dic];
}

#pragma mark -- pickerviewDelegate
- (id)showPickerView {
    
    kAYViewsSendMessage(@"Picker", @"showPickerView", nil)
    return nil;
}

- (id)didSaveClick {
    
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
    
//    if (pickerView.frame.origin.y == SHOW_OFFSET_Y) {
//        [UIView animateWithDuration:0.25 animations:^{
//            pickerView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
//        }];
//    }
    return nil;
}
- (id)didCancelClick {
    
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

-(void)didSelfPhotoClick {
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
