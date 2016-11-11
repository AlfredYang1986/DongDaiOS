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
//=======
//        NSLog(@"init args are : %@", _login_attr);
//        if (![_login_attr objectForKey:@"role_tag"] || [[_login_attr objectForKey:@"role_tag"]isEqualToString:@""]) {
//            isFirstSNS = YES;
//            [_login_attr setValue:@"未设置名" forKey:@"role_tag"];
//        }
//    } 
//>>>>>>> Service_version_initial
}

#pragma mark -- life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools themeColor];
   
    NSString* screen_photo = [_login_attr objectForKey:@"screen_photo"];
    
    if (screen_photo && ![screen_photo isEqualToString:@""]) {
        
        id<AYViewBase> view = [self.views objectForKey:@"UserScreenPhote"];
        id<AYCommand> cmd = [view.commands objectForKey:@"changeScreenPhoto:"];
        [cmd performWithResult:&screen_photo];
        
    }
    
    UILabel *welcome = [[UILabel alloc]init];
    welcome = [Tools setLabelWith:welcome andText:@"最后一步，您的照片" andTextColor:[UIColor whiteColor] andFontSize:22.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:welcome];
    [welcome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(WELCOMEY);
        make.centerX.equalTo(self.view);
    }];
    
    id<AYViewBase> photo_view = [self.views objectForKey:@"UserScreenPhote"];
    UIView *photoView = (UIView*)photo_view;
    
    NSString *user_name = [_login_attr objectForKey:@"screen_name"];
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel = [Tools setLabelWith:nameLabel andText:user_name andTextColor:[UIColor whiteColor] andFontSize:20.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoView.mas_bottom).offset(16);
        make.centerX.equalTo(self.view);
    }];
    
    enterBtn = [[UIButton alloc]init];
    [enterBtn setBackgroundColor:[UIColor clearColor]];
    [enterBtn setImage:[UIImage imageNamed:@"enter_selected"] forState:UIControlStateNormal];
    [enterBtn setImage:[UIImage imageNamed:@"enter"] forState:UIControlStateDisabled];
//    enterBtn.enabled = NO;
    [enterBtn addTarget:self action:@selector(updateUserProfile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];
    [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(68);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(115, 40));
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
    view.backgroundColor = [Tools themeColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_white");
    [cmd_left performWithResult:&left];
    
    id<AYCommand> cmd_right_vis = [bar.commands objectForKey:@"setRightBtnVisibility:"];
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    [cmd_right_vis performWithResult:&right_hidden];
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
    
    isChangeImg = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
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
- (void)updateUserProfile {
    NSString* screen_photo = [_login_attr objectForKey:@"screen_photo"];
    
//    if (!screen_photo || [screen_photo isEqualToString:@""]) {
//        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有选择用户头像" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
//        return ;
//    }
//    if (![_invateCode.text isEqualToString:@"1111"]) {
//        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效的邀请码" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
//        return ;
//    }
    //通用参数
    NSMutableDictionary* dic_update = [[NSMutableDictionary alloc]init];
    [dic_update setValue:[_login_attr objectForKey:@"screen_name"] forKey:@"screen_name"];
    [dic_update setValue:[_login_attr objectForKey:@"role_tag"] forKey:@"role_tag"];
    [dic_update setValue:[_login_attr objectForKey:@"screen_photo"] forKey:@"screen_photo"];
    [dic_update setValue:[_login_attr objectForKey:@"auth_token"] forKey:@"auth_token"];
    [dic_update setValue:[_login_attr objectForKey:@"user_id"] forKey:@"user_id"];
    [dic_update setValue:0 forKey:@"gender"];
    [dic_update setValue:[Tools getDeviceUUID] forKey:@"uuid"];
    [dic_update setValue:[NSNumber numberWithInt:1] forKey:@"refresh_token"];
    
    if ([[_login_attr allKeys] containsObject:@"phoneNo"]) {
        [dic_update setValue:[_login_attr objectForKey:@"phoneNo"] forKey:@"phoneNo"];
        [dic_update setValue:[NSNumber numberWithInt:1] forKey:@"create"];
    }
    
    if (isChangeImg) {
        NSMutableDictionary* photo_dic = [[NSMutableDictionary alloc]initWithCapacity:2];
        [photo_dic setValue:screen_photo forKey:@"image"];
        [photo_dic setValue:_changeImage forKey:@"upload_image"];
        
        id<AYFacadeBase> up_facade = [self.facades objectForKey:@"FileRemote"];
        AYRemoteCallCommand* up_cmd = [up_facade.commands objectForKey:@"UploadUserImage"];
        [up_cmd performWithResult:[photo_dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            NSLog(@"upload result are %d", success);
        }];
    }

    id<AYFacadeBase> profileRemote = DEFAULTFACADE(@"ProfileRemote");
    AYRemoteCallCommand* cmd_profile = [profileRemote.commands objectForKey:@"UpdateUserDetail"];
    [cmd_profile performWithResult:[dic_update copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        NSLog(@"Update user detail remote result: %@", result);
        if (success) {
            AYModel* m = MODEL;
            AYFacade* f = [m.facades objectForKey:@"LoginModel"];
            id<AYCommand> cmd = [f.commands objectForKey:@"ChangeCurrentLoginUser"];
            [cmd performWithResult:&result];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"set nick name error" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
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

- (id)leftBtnSelected {
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
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
//    [self updateUserProfile];
    return nil;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
