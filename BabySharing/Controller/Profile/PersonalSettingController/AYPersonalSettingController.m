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

#define SHOW_OFFSET_Y							SCREEN_HEIGHT - 196
static NSString* const descInitStr =			@"描述一下自己的经历";

@implementation AYPersonalSettingController {
    
    NSMutableDictionary* profile_dic;
    
    UIImage *changeOwnerImage;
    NSString *changeImageName;
    BOOL isUserPhotoChanged;
	
	BOOL isChangedAlready;
    
    UIImageView *user_photo;
    UITextField *nameTextField;
    UILabel *descLabel;
//    UIView *pickerView;
}


#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        profile_dic = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        NSString* personal_desc = [dic objectForKey:kAYControllerChangeArgsKey];
        
        if (!personal_desc || [personal_desc isEqualToString:@""]) {
            descLabel.text = descInitStr;
        } else {
            descLabel.text = personal_desc;
        }
		[self setRightBtnEnable];
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *mainView = [[UIScrollView alloc]init];
    mainView.contentSize = CGSizeMake(SCREEN_WIDTH, 555.f);
    mainView.showsVerticalScrollIndicator = NO;
    mainView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.bottom.equalTo(self.view);
    }];
    
    user_photo = [[UIImageView alloc]init];
    [mainView addSubview:user_photo];
    user_photo.image = IMGRESOURCE(@"default_image");
    user_photo.contentMode = UIViewContentModeScaleAspectFill;
    user_photo.clipsToBounds = YES;
    [user_photo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView);
        make.top.equalTo(mainView).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 250));
    }];
    
    UIButton *cameraBtn = [UIButton new];
    [cameraBtn setImage:IMGRESOURCE(@"camera") forState:UIControlStateNormal];
    [mainView addSubview:cameraBtn];
    [cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(user_photo).offset(-15);
        make.bottom.equalTo(user_photo).offset(-15);
        make.size.mas_equalTo(CGSizeMake(69, 69));
    }];
    [cameraBtn addTarget:self action:@selector(didSelfPhotoClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSString *pre = cmd.route;
    [user_photo sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:[profile_dic objectForKey:@"screen_photo"]]] placeholderImage:IMGRESOURCE(@"default_image")];
    UILabel *nameLabel = [Tools creatUILabelWithText:@"姓名" andTextColor:[Tools blackColor] andFontSize:17.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    [mainView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(user_photo.mas_bottom).offset(20);
        make.left.equalTo(mainView).offset(20);
    }];
    
    nameTextField = [[UITextField alloc]init];
    nameTextField.font = kAYFontLight(14.f);
    nameTextField.textColor = [Tools garyColor];
    nameTextField.placeholder = @"请输入姓名";
    nameTextField.delegate = self;
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [mainView addSubview:nameTextField];
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainView).offset(20);
//        make.right.equalTo(mainView).offset(-20);
        make.width.mas_equalTo(SCREEN_WIDTH - 40);
        make.top.equalTo(nameLabel.mas_bottom).offset(15);
    }];
    NSString *nameStr = [profile_dic objectForKey:@"screen_name"];
    nameTextField.text = nameStr;
    
    UIView *separtor = [UIView new];
    separtor.backgroundColor = [Tools garyLineColor];
    [mainView addSubview:separtor];
    [separtor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTextField.mas_bottom).offset(20);
//        make.centerX.equalTo(mainView);
        make.left.equalTo(mainView).offset(15);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 1));
    }];
    
    UILabel *descTitleLabel = [Tools creatUILabelWithText:@"关于我" andTextColor:[Tools blackColor] andFontSize:17.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    [mainView addSubview:descTitleLabel];
    [descTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(separtor.mas_bottom).offset(20);
        make.left.equalTo(nameLabel);
    }];
    
    descLabel = [Tools creatUILabelWithText:nil andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    descLabel.numberOfLines = 0;
    [mainView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descTitleLabel.mas_bottom).offset(15);
        make.left.equalTo(nameLabel);
//        make.right.equalTo(mainView).offset(-20);
        make.width.mas_equalTo(SCREEN_WIDTH - 40);
        make.height.mas_greaterThanOrEqualTo(30);
    }];
    
    NSString *descStr = [profile_dic objectForKey:kAYProfileArgsDescription];
    if (descStr && ![descStr isEqualToString:@""]) {
        descLabel.text = descStr;
    } else
        descLabel.text = descInitStr;
    descLabel.userInteractionEnabled = YES;
    [descLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didDescLabelTap:)]];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
    
    NSString *title = @"编辑个人资料";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools garyColor] andFontSize:16.f andBackgroundColor:nil];
	bar_right_btn.userInteractionEnabled = NO;
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)SelfSettingLayout:(UIView*)view {
    CGFloat margin = 20;
    view.frame = CGRectMake(margin, 214, SCREEN_WIDTH - margin * 2, 200);
    return nil;
}

- (id)PickerLayout:(UIView*)view {
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, view.bounds.size.height);
    view.backgroundColor = [Tools garyColor];
    return nil;
}

#pragma mark -- actions
- (void)setRightBtnEnable {
	UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
}
- (void)setRightBtnUnable {
	UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools garyColor] andFontSize:16.f andBackgroundColor:nil];
	bar_right_btn.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
}

-(void)didSelfPhotoClick {
    [self tapElseWhere:nil];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
    [sheet showInView:self.view];
}

- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {
    
    if ([nameTextField isFirstResponder]) {
        [nameTextField resignFirstResponder];
    }
}

- (void)didDescLabelTap:(UITapGestureRecognizer*)gusture {
    
    AYViewController* des = DEFAULTCONTROLLER(@"PersonalDesc");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    if (![descLabel.text isEqualToString:descInitStr]) {
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
	
	[nameTextField resignFirstResponder];
    
    if (isUserPhotoChanged) {
        AYRemoteCallCommand* up_cmd = COMMAND(@"Remote", @"UploadUserImage");
        NSMutableDictionary *up_dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [up_dic setValue:changeImageName forKey:@"image"];
        [up_dic setValue:changeOwnerImage forKey:@"upload_image"];
        [up_cmd performWithResult:[up_dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
                isUserPhotoChanged = NO;
                [self updatePersonalInfo];
            } else {
                NSString *title = @"头像上传失败,请重试";
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            }
        }];
    } else {
        [self updatePersonalInfo];
    }
    return nil;
}

- (void)updatePersonalInfo {
	
	NSString *screenName = [profile_dic objectForKey:kAYProfileArgsScreenName];
	NSString *description = [profile_dic objectForKey:kAYProfileArgsDescription];
	
    NSDictionary* user = nil;
    CURRENUSER(user);
	
	NSMutableDictionary* dic_update = [[NSMutableDictionary alloc] init];
	[dic_update setValue:[user objectForKey:kAYCommArgsToken] forKey:kAYCommArgsToken];
	
	NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
	[condition setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[dic_update setValue:condition forKey:kAYCommArgsCondition];
	
	NSMutableDictionary *profile = [[NSMutableDictionary alloc] init];
	if (![screenName isEqualToString:nameTextField.text]) {
		[profile setValue:nameTextField.text forKey:kAYProfileArgsScreenName];
	}
	if (![description isEqualToString:descLabel.text]) {
		[profile setValue:descLabel.text forKey:kAYProfileArgsDescription];
	}
	
	[profile setValue:changeImageName forKey:kAYProfileArgsScreenPhoto];
	
	[dic_update setValue:profile forKey:@"profile"];
	
    id<AYFacadeBase> f = [self.facades objectForKey:@"ProfileRemote"];
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"UpdateUserDetail"];
    [cmd performWithResult:[dic_update copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
			
			id tmp = [result objectForKey:kAYProfileArgsSelf];
			
            id<AYFacadeBase> facade = LOGINMODEL;
            id<AYCommand> cmd_profle = [facade.commands objectForKey:@"UpdateLocalCurrentUserProfile"];
            [cmd_profle performWithResult:&tmp];
			
//			[self setRightBtnUnable];
			
            NSString *title = @"个人信息修改成功";
            [self popToRootVCWithTip:title];
        } else {
            
            NSString *title = @"保存用户信息失败";
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        }
    }];
}

- (void)popToPreviousWithSave {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:[NSNumber numberWithBool:YES] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POPTOROOT;
    [cmd performWithResult:&dic];
}

- (void)popToRootVCWithTip:(NSString*)tip {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:tip forKey:kAYControllerChangeArgsKey];
    
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
		
    }
    
    return nil;
}
- (id)didCancelClick {
    
    return nil;
}

#pragma mark -- notifies
- (id)screenNameChanged:(NSString*)args {
    return nil;
}


- (id)scrollToHideKeyBoard {
    return nil;
}

#pragma mark -- UIImagePickerControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    changeOwnerImage = image;
    user_photo.image = image;
    isUserPhotoChanged = YES;
	
    NSString* img_name = [Tools getUUIDString];
    changeImageName = img_name;
	
	[self setRightBtnEnable];
}

//用户取消拍照
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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

//nameTextFiled
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *tmp = textField.text;
    NSInteger len = [Tools bityWithStr:tmp];
    if (len > 32 && ![string isEqualToString:@""]) {
        [textField resignFirstResponder];
        NSString *title = @"姓名长度应在4-32个字符之间\n*汉字／大写字母长度为2";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        return NO;
    } else
		[self setRightBtnEnable];
        return YES;
}

@end
