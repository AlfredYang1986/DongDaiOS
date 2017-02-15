//
//  AYUserInfoInput.m
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYWelcomeController.h"
#import "AYViewBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYCommandDefines.h"
#import "AYModel.h"
#import "AYFactoryManager.h"
#import "AYRemoteCallCommand.h"
#import "OBShapedButton.h"


#define SCREEN_PHOTO_WIDTH                      100
#define WELCOMEY        83
#define PHOTOY          145
#define ENTERBTNY       PHOTOY + 151

@interface AYWelcomeController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSMutableDictionary* login_attr;
@property (nonatomic, strong) UIImage *changeImage;
//@property (nonatomic, strong) UITextField *invateCode;
@end

@implementation AYWelcomeController {
    BOOL isChangeImg;
    CGRect keyBoardFrame;
    UIButton *enterBtn;
    UILabel *tips;
    
    BOOL isFirst;
    BOOL isFirstPhone;
}

@synthesize login_attr = _login_attr;
@synthesize changeImage = _changeImage;
//@synthesize invateCode = _invateCode;

#pragma mark -- commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
   
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        _login_attr = [[dic objectForKey:kAYControllerChangeArgsKey] mutableCopy];
        isFirst = YES;
    }
}

#pragma mark -- life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools whiteColor];
   
    NSString* screen_photo = [_login_attr objectForKey:@"screen_photo"];
    
    if (screen_photo && ![screen_photo isEqualToString:@""]) {
        
        id<AYViewBase> view = [self.views objectForKey:@"UserScreenPhote"];
        id<AYCommand> cmd = [view.commands objectForKey:@"changeScreenPhoto:"];
        [cmd performWithResult:&screen_photo];
        
    }
    
    UILabel *welcome = [Tools creatUILabelWithText:@"最后一步，您的照片" andTextColor:[Tools themeColor] andFontSize:22.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:welcome];
    [welcome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(WELCOMEY);
        make.centerX.equalTo(self.view);
    }];
    
    id<AYViewBase> photo_view = [self.views objectForKey:@"UserScreenPhote"];
    UIView *photoView = (UIView*)photo_view;
    
    NSString *user_name = [_login_attr objectForKey:@"screen_name"];
    UILabel *nameLabel = [Tools creatUILabelWithText:user_name andTextColor:[Tools themeColor] andFontSize:120.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoView.mas_bottom).offset(16);
        make.centerX.equalTo(self.view);
    }];
	
	enterBtn = [Tools creatUIButtonWithTitle:@"进入咚哒" andTitleColor:[Tools whiteColor] andFontSize:-18.f andBackgroundColor:[Tools themeColor]];
	[Tools setViewBorder:enterBtn withRadius:22.5f andBorderWidth:0 andBorderColor:nil andBackground:[Tools themeColor]];
    [enterBtn addTarget:self action:@selector(updateUserProfile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];
    [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(55);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(130, 45));
    }];
	
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tap];
    
//    [self screenPhotoViewLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- views layouts
- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
	
	UIImage* left = IMGRESOURCE(@"bar_left_theme");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber* right_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
    return nil;
}

- (id)UserScreenPhoteLayout:(UIView*)view {
    view.frame = CGRectMake((SCREEN_WIDTH - SCREEN_PHOTO_WIDTH) * 0.5, PHOTOY, SCREEN_PHOTO_WIDTH, SCREEN_PHOTO_WIDTH);
    return nil;
}

#pragma mark -- actions
- (void)tapGesture:(UITapGestureRecognizer*)gesture {
    NSLog(@"tap esle where");
}

-(void)getInvateBtnClick{
    id<AYCommand> setting = DEFAULTCONTROLLER(@"GetInvateCode");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd_push = PUSH;
    [cmd_push performWithResult:&dic];
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    isChangeImg = YES;
    _changeImage = image;
    
    // get image name
    id<AYCommand> uuid_cmd = [self.commands objectForKey:@"GernarateImgUUID"];
    NSString* img_name = nil;
    [uuid_cmd performWithResult:&img_name];
    [_login_attr setValue:img_name forKey:@"screen_photo"];
    
    // sava image to local
    id<AYCommand> save_cmd = [self.commands objectForKey:@"SaveImgLocal"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:img_name forKey:@"img_name"];
    [dic setValue:image forKey:@"image"];
    [save_cmd performWithResult:&dic];
    
    id<AYViewBase> view = [self.views objectForKey:@"UserScreenPhote"];
    id<AYCommand> cmd = [view.commands objectForKey:@"changeScreenPhoto:"];
    [cmd performWithResult:&image];
}

#pragma mark -- view notification
- (void)updateProfileImpl:(NSDictionary*) dic {
    id<AYFacadeBase> profileRemote = DEFAULTFACADE(@"ProfileRemote");
    AYRemoteCallCommand* cmd_profile = [profileRemote.commands objectForKey:@"UpdateUserDetail"];
    [cmd_profile performWithResult:dic andFinishBlack:^(BOOL success, NSDictionary * result) {
        NSLog(@"Update user detail remote result: %@", result);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                id args = _login_attr;
                AYModel* m = MODEL;
                AYFacade* f = [m.facades objectForKey:@"LoginModel"];
                id<AYCommand> cmd = [f.commands objectForKey:@"ChangeCurrentLoginUser"];
                [cmd performWithResult:&args];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络错误,请退出重试" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                [alert show];
            }
        });
    }];
}

- (void)updateUserProfile {
    NSString* screen_photo = [_login_attr objectForKey:@"screen_photo"];
	if ([screen_photo isEqualToString:@""] && !_changeImage) {
		NSString *title = @"请求真相!";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return;
	}
	
    //通用参数
    NSMutableDictionary* dic_update = [[NSMutableDictionary alloc]init];
    [dic_update setValue:[_login_attr objectForKey:@"screen_name"] forKey:@"screen_name"];
    [dic_update setValue:[_login_attr objectForKey:@"auth_token"] forKey:@"auth_token"];
    [dic_update setValue:[_login_attr objectForKey:@"user_id"] forKey:@"user_id"];
    
    if (isChangeImg) {
        NSMutableDictionary* photo_dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [photo_dic setValue:screen_photo forKey:@"image"];
        [photo_dic setValue:_changeImage forKey:@"upload_image"];
        
        id<AYFacadeBase> up_facade = [self.facades objectForKey:@"FileRemote"];
        AYRemoteCallCommand* up_cmd = [up_facade.commands objectForKey:@"UploadUserImage"];
        [up_cmd performWithResult:[photo_dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            NSLog(@"upload result are %d", success);
            if (success) {
                
                [dic_update setValue:screen_photo forKey:@"screen_photo"];
                [self updateProfileImpl:[dic_update copy]];
            } else {
                
                NSString *title = @"真相上传失败!请改善网络环境重试";
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            }
        }];
    } else {
        [self updateProfileImpl:[dic_update copy]];
    }
}

- (id)CurrentLoginUserChanged:(id)args {
    NSLog(@"Notify args: %@", args);
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSString* message_name = @"LoginSuccess";
    [dic_pop setValue:message_name forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POPTOROOT;
    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)CurrentRegUserProfileChanged:(id)args {
    NSLog(@"args: %@", args);
    NSString* screen_photo = [args objectForKey:@"screen_photo"];
    [_login_attr setValue:screen_photo forKey:@"screen_photo"];
    id<AYViewBase> view = [self.views objectForKey:@"UserScreenPhote"];
    id<AYCommand> cmd = [view.commands objectForKey:@"changeScreenPhoto:"];
    [cmd performWithResult:&screen_photo];
    return nil;
}

- (id)leftBtnSelected {
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    NSString* message_name = @"ResetStatusReady";
    [dic_pop setValue:message_name forKey:kAYControllerChangeArgsKey];
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)tapGestureScreenPhoto {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
    [sheet showInView:self.view];
    return nil;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    id<AYViewBase> view = [self.views objectForKey:@"UserScreenPhote"];
    id<AYCommand> cmd;
    if (buttonIndex == 0) { // take photo / 去拍照
        cmd = OpenCamera;
    } else if (buttonIndex == 1) {
        cmd = OpenImagePickerVC;
    } else {
        
    }
    
    [cmd performWithResult:nil];
}

- (void)invateCoderTextFieldChanged:(NSNotification*)tf {
//    if (tf.object == _invateCode && _invateCode.text.length >= 4) {
//        enterBtn.enabled = YES;
//        _invateCode.text = [_invateCode.text substringToIndex:4];
//    }
//    if (tf.object == _invateCode && _invateCode.text.length < 4) {
//        enterBtn.enabled = NO;
//    }
}

- (id)rightBtnSelected {
    return nil;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
