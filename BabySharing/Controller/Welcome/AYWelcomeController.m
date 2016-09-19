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
    UIView *screenPhotoView;
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
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:screen_photo forKey:@"image"];
        [dic setValue:@"img_thum" forKey:@"expect_size"];
        
        id<AYViewBase> view = [self.views objectForKey:@"UserScreenPhote"];
        id<AYCommand> cmd = [view.commands objectForKey:@"changeScreenPhoto:"];
        id<AYFacadeBase> facade_download = [self.facades objectForKey:@"FileRemote"];
        AYRemoteCallCommand* cmd_query_image = [facade_download.commands objectForKey:@"DownloadUserFiles"];
        [cmd_query_image performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            UIImage* image = (UIImage*)result;
            if (image != nil) {
                [cmd performWithResult:&image];
            }
        }];
    }
    
    UILabel *welcome = [[UILabel alloc]init];
    welcome = [Tools setLabelWith:welcome andText:@"最后一步，您的照片？" andTextColor:[UIColor whiteColor] andFontSize:22.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:welcome];
    [welcome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(WELCOMEY);
        make.centerX.equalTo(self.view);
    }];
    
    id<AYViewBase> photo_view = [self.views objectForKey:@"UserScreenPhote"];
    UIView *photoView = (UIView*)photo_view;
    
    NSString *user_name = [_login_attr objectForKey:@"screen_name"];
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel = [Tools setLabelWith:nameLabel andText:user_name andTextColor:[UIColor whiteColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoView.mas_bottom).offset(16);
        make.centerX.equalTo(self.view);
    }];
    
//    _invateCode = [[UITextField alloc]init];
//    [self.view addSubview:_invateCode];
//    _invateCode.layer.cornerRadius = 2.f;
//    _invateCode.clipsToBounds = YES;
//    _invateCode.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.5f];
//    _invateCode.font = [UIFont systemFontOfSize:14.f];
//    _invateCode.placeholder = @"输入邀请码";
//    _invateCode.textAlignment = NSTextAlignmentCenter;
//    [_invateCode setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];//占位符颜色设置
//    _invateCode.textColor = [Tools colorWithRED:74 GREEN:74 BLUE:74 ALPHA:1.f];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(invateCoderTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
//    _invateCode.clearButtonMode = UITextFieldViewModeWhileEditing;
//    
//    CGRect frame = _invateCode.frame;
//    frame.size.width = 10;
//    UIView *leftview = [[UIView alloc] initWithFrame:frame];
//    _invateCode.leftViewMode = UITextFieldViewModeAlways;
//    _invateCode.leftView = leftview;
//    
//    [_invateCode mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(photoView.mas_bottom).offset(27);
//        make.size.mas_equalTo(CGSizeMake(230, 40));
//    }];
//    
//    UILabel *getInvate = [[UILabel alloc]init];
//    [self.view addSubview:getInvate];
////    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"如何获取邀请码"];
////    NSDictionary * dict = @{
////                            NSFontAttributeName:[UIFont systemFontOfSize:12],
////                            NSUnderlineStyleAttributeName:@9};
////    [str setAttributes:dict range:NSMakeRange(0, str.length)];
//    getInvate.text = @"如何获取邀请码";
//    getInvate.font = [UIFont systemFontOfSize:12.f];
//    getInvate.textColor = [UIColor colorWithWhite:1.f alpha:1.f];
//    getInvate.textAlignment = NSTextAlignmentCenter;
//    getInvate.userInteractionEnabled = YES;
//    [getInvate addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getInvateBtnClick)]];
//    
//    [getInvate mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_invateCode.mas_bottom).offset(10);
//        make.centerX.equalTo(self.view);
//        make.height.mas_equalTo(16);
//    }];
//    CALayer *line_separator = [CALayer layer];
////    line_separator.borderColor = [UIColor colorWithWhite:1.f alpha:1.f].CGColor;
////    line_separator.borderWidth = 1.f;
//    line_separator.frame = CGRectMake(0, 15, 12 * 7, 1);
//    line_separator.backgroundColor = [UIColor whiteColor].CGColor;
//    [getInvate.layer addSublayer:line_separator];
    
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
    
    [self screenPhotoViewLayout];
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
    UIImage* left = PNGRESOURCE(@"bar_left_white");
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

-(void)screenPhotoViewLayout{
    
    screenPhotoView = [[UIView alloc]init];
    screenPhotoView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:screenPhotoView];
    [screenPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-30);
        make.width.mas_equalTo(SCREEN_WIDTH - 2*22);
        make.height.mas_equalTo(130);
    }];
    
    UIView *options_12 = [[UIView alloc]init];
    options_12.backgroundColor = [UIColor whiteColor];
    options_12.layer.cornerRadius = 2.f;
    options_12.clipsToBounds = YES;
    
    [screenPhotoView addSubview:options_12];
    [options_12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screenPhotoView);
        make.right.equalTo(screenPhotoView);
        make.top.equalTo(screenPhotoView);
        make.height.mas_equalTo(80);
    }];
    
    CALayer *line_up = [CALayer layer];
    line_up.borderWidth = 1.f;
    line_up.borderColor = [Tools themeColor].CGColor;
    line_up.frame = CGRectMake(10, 40, SCREEN_WIDTH - 2*32, 1);
    [options_12.layer addSublayer:line_up];
    
    UIButton *album = [[UIButton alloc]init];
    [album setBackgroundColor:[UIColor clearColor]];
    [album setTitle:@"相册" forState:UIControlStateNormal];
    [album setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.f] forState:UIControlStateNormal];
    album.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [album addTarget:self action:@selector(albumBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [options_12 addSubview:album];
    [album mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(options_12);
        make.left.equalTo(options_12);
        make.width.equalTo(options_12);
        make.height.equalTo(@(39));
    }];
    
    UIButton *takePhoto = [[UIButton alloc]init];
    [takePhoto setBackgroundColor:[UIColor clearColor]];
    [takePhoto setTitle:@"拍照" forState:UIControlStateNormal];
    [takePhoto setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.f] forState:UIControlStateNormal];
    takePhoto.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [takePhoto addTarget:self action:@selector(takePhotoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [options_12 addSubview:takePhoto];
    [takePhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(options_12);
        make.left.equalTo(options_12);
        make.width.equalTo(options_12);
        make.height.equalTo(@(39));
    }];
    
    UIView *options_3 = [[UIView alloc]init];
    options_3.backgroundColor = [UIColor whiteColor];
    options_3.layer.cornerRadius = 2.f;
    options_3.clipsToBounds = YES;
    
    [screenPhotoView addSubview:options_3];
    [options_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(screenPhotoView);
        make.right.equalTo(screenPhotoView);
        make.bottom.equalTo(screenPhotoView);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *cancel = [[UIButton alloc]init];
    [cancel setBackgroundColor:[UIColor clearColor]];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor colorWithWhite:0.2 alpha:1.f] forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [cancel addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [options_3 addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(options_3).mas_offset(UIEdgeInsetsMake(0,0,0,0));
        make.edges.equalTo(options_3);
    }];
    
    screenPhotoView.alpha = 0;
    screenPhotoView.hidden = YES;
}

-(void)albumBtnClick {
    id<AYViewBase> view = [self.views objectForKey:@"UserScreenPhote"];
    id<AYCommand> cmd = [view.commands objectForKey:@"albumBtnClicked"];
    [cmd performWithResult:nil];
}

-(void)takePhotoBtnClick {
    id<AYViewBase> view = [self.views objectForKey:@"UserScreenPhote"];
    id<AYCommand> cmd = [view.commands objectForKey:@"takePhotoBtnClicked"];
    [cmd performWithResult:nil];
}

-(void)cancelBtnClick {
    [UIView animateWithDuration:0.3 animations:^{
        screenPhotoView.alpha = 0;
    } completion:^(BOOL finished) {
        screenPhotoView.hidden = YES;
    }];
    
}
#pragma mark -- actions
- (void)tapGesture:(UITapGestureRecognizer*)gesture {
    NSLog(@"tap esle where");
//    if (isFirst) {
//        if ([_invateCode isFirstResponder]) {
//            [_invateCode resignFirstResponder];
//        }
//    }
    if (screenPhotoView.hidden == NO) {
        [UIView animateWithDuration:0.3 animations:^{
            screenPhotoView.alpha = 0;
        } completion:^(BOOL finished) {
            screenPhotoView.hidden = YES;
        }];
    }
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
    screenPhotoView.alpha = 0;
    screenPhotoView.hidden = YES;
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
    if (isFirst) {
//        if ([_invateCode isFirstResponder]) {
//            [_invateCode resignFirstResponder];
//        }
    }
    screenPhotoView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        screenPhotoView.alpha = 1;
    }];
    return nil;
}

-(void)invateCoderTextFieldChanged:(NSNotification*)tf{
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
