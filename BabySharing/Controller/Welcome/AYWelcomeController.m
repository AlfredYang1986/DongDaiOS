//
//  AYUserInfoInput.m
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYWelcomeController.h"
#import "AYViewBase.h"
#import "Tools.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYCommandDefines.h"
#import "AYModel.h"
#import "AYFactoryManager.h"
#import "AYRemoteCallCommand.h"
#import "OBShapedButton.h"


#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height

#define SCREEN_PHOTO_WIDTH                      114

#define WELCOMEY        SCREEN_HEIGHT * 98/667
#define TIPSY           WELCOMEY + 54
#define PHOTOY          TIPSY + 10
#define ENTERBTNY       PHOTOY + 151

@interface AYWelcomeController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSMutableDictionary* login_attr;
@property (nonatomic, strong) UIImage *changeImage;
@property (nonatomic, strong) UITextField *invateCode;
@end

@implementation AYWelcomeController {
    BOOL isChangeImg;
    CGRect keyBoardFrame;
//    UIButton *enterBtn;
    UILabel *tips;
    
    BOOL isFirstSNS;
}

@synthesize login_attr = _login_attr;
@synthesize changeImage = _changeImage;
@synthesize invateCode = _invateCode;

#pragma mark -- commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
   
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        _login_attr = [[dic objectForKey:kAYControllerChangeArgsKey] mutableCopy];
        NSLog(@"init args are : %@", _login_attr);
        if (![_login_attr objectForKey:@"role_tag"] || [[_login_attr objectForKey:@"role_tag"]isEqualToString:@""]) {
            isFirstSNS = YES;
            [_login_attr setValue:@" " forKey:@"role_tag"];
        }
    } 
}

#pragma mark -- life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools themeColor];
   
    NSString* screen_photo = [_login_attr objectForKey:@"screen_photo"];
    if (screen_photo && ![screen_photo isEqualToString:@""]) {

        id<AYViewBase> view = [self.views objectForKey:@"UserScreenPhote"];
        id<AYCommand> cmd = [view.commands objectForKey:@"changeScreenPhoto:"];
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:screen_photo forKey:@"image"];
        [dic setValue:@"img_thum" forKey:@"expect_size"];
        
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
    welcome.font = [UIFont systemFontOfSize:24.f];
    welcome.textColor = [UIColor whiteColor];
    welcome.textAlignment = NSTextAlignmentLeft;
    welcome.text = @"欢迎";
    [self.view addSubview:welcome];
    [welcome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(WELCOMEY);
        make.centerX.equalTo(self.view);
    }];
    
//    tips = [[UILabel alloc]init];
//    tips.font = [UIFont systemFontOfSize:14.f];
//    tips.textColor = [UIColor whiteColor];
//    tips.textAlignment = NSTextAlignmentLeft;
//    tips.text = @"添加自己美美的照片，看起来更靠谱哦！";
//    [self.view addSubview:tips];
//    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(welcome).offset(54);
//        make.centerX.equalTo(welcome);
//    }];
    
    id<AYViewBase> photo_view = [self.views objectForKey:@"UserScreenPhote"];
    UIView *photoView = (UIView*)photo_view;
    
    UIButton *enterBtn = [[UIButton alloc]init];
    [enterBtn setTitle:@"进入咚哒" forState:UIControlStateNormal];
    [enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [enterBtn setBackgroundColor:[UIColor clearColor]];
    enterBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
    
    [enterBtn addTarget:self action:@selector(updateUserProfile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];
    [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoView.mas_bottom).offset(isFirstSNS?130:100);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(98, 24));
    }];
    
    if (isFirstSNS) {
        _invateCode = [[UITextField alloc]init];
        [self.view addSubview:_invateCode];
        _invateCode.layer.cornerRadius = 4.f;
        _invateCode.clipsToBounds = YES;
        _invateCode.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.5f];
        _invateCode.font = [UIFont systemFontOfSize:14.f];
        _invateCode.placeholder = @"输入邀请码";
        [_invateCode setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        _invateCode.textColor = [Tools colorWithRED:74 GREEN:74 BLUE:74 ALPHA:1.f];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
//        _invateCode.keyboardType = UIKeyboardTypeNumberPad;
        _invateCode.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        CGRect frame = _invateCode.frame;
        frame.size.width = 10;
        UIView *leftview = [[UIView alloc] initWithFrame:frame];
        _invateCode.leftViewMode = UITextFieldViewModeAlways;
        _invateCode.leftView = leftview;
        
        [_invateCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(photoView.mas_bottom).offset(35);
            make.size.mas_equalTo(CGSizeMake(160, 30));
        }];
        
        UILabel *getInvate = [[UILabel alloc]init];
        [self.view addSubview:getInvate];
        getInvate.text = @"如何获取邀请码";
        getInvate.font = [UIFont systemFontOfSize:13.f];
        getInvate.textColor = [UIColor colorWithWhite:1.f alpha:0.5f];
        
        getInvate.userInteractionEnabled = YES;
        [getInvate addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getInvateBtnClick)]];
        
        [getInvate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_invateCode.mas_bottom).offset(10);
            make.centerX.equalTo(self.view);
        }];
    }
    
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tap];
//    [self tapGesture:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- views layouts
- (id)FakeNavBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, width, 64);
    view.backgroundColor = [Tools themeColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = PNGRESOURCE(@"bar_left_white");
    [cmd_left performWithResult:&left];
    
    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [bar_right_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bar_right_btn setTitle:@"  " forState:UIControlStateNormal];
    [bar_right_btn sizeToFit];
    bar_right_btn.center = CGPointMake(width - 10.5 - bar_right_btn.frame.size.width / 2, 64 / 2);
    
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
    [cmd_right performWithResult:&bar_right_btn];
    
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
    
    if (!screen_photo || [screen_photo isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有选择用户头像" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        return ;
    }
    if (isFirstSNS) {
        if (![_invateCode.text isEqualToString:@"1111"]) {
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效的邀请码" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
            return ;
        }
    }
    
    //通用参数
    NSMutableDictionary* dic_update = [[NSMutableDictionary alloc]init];
    [dic_update setValue:[_login_attr objectForKey:@"screen_name"] forKey:@"screen_name"];
    [dic_update setValue:[_login_attr objectForKey:@"role_tag"] forKey:@"role_tag"];
    [dic_update setValue:screen_photo forKey:@"screen_photo"];
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
        
        NSMutableDictionary* photo_dic = [[NSMutableDictionary alloc]initWithCapacity:1];
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
//    NSLog(@"TODO: 进入咚哒");
    
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
    NSLog(@"pop view controller");
    if (isFirstSNS) {
        id<AYCommand> cmd = POPTOROOT;
        [cmd performWithResult:nil];
        return nil;
    }else{
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
    }
}
- (id)rightBtnSelected {
    return nil;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end
