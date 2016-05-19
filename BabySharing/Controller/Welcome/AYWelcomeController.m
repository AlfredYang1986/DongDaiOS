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


#define NEXT_BTN_MARGIN_BOTTOM  80

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height

#define SCREEN_PHOTO_TOP_MARGIN                 SCREEN_HEIGHT / 10
#define SCREEN_PHOTO_WIDTH                      114

#define WELCOMEY        SCREEN_HEIGHT * 98/667
#define TIPSY           WELCOMEY + 54
#define PHOTOY          TIPSY + 35
#define ENTERBTNY       PHOTOY + 141

@interface AYWelcomeController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSMutableDictionary* login_attr;
@property (nonatomic, strong) UIImage *changeImage;
@end

@implementation AYWelcomeController {
    BOOL isChangeImg;
    CGRect keyBoardFrame;
//    UIButton *enterBtn;
    UILabel *tips;
}

@synthesize login_attr = _login_attr;
@synthesize changeImage = _changeImage;

#pragma mark -- commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
   
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        _login_attr = [[dic objectForKey:kAYControllerChangeArgsKey] mutableCopy];
        NSLog(@"init args are : %@", _login_attr);
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
        [dic setValue:@"img_icon" forKey:@"expect_size"];
        
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
    
    tips = [[UILabel alloc]init];
    tips.font = [UIFont systemFontOfSize:14.f];
    tips.textColor = [UIColor whiteColor];
    tips.textAlignment = NSTextAlignmentLeft;
    tips.text = @"添加自己美美的照片，看起来更靠谱哦！";
    [self.view addSubview:tips];
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(welcome).offset(54);
        make.centerX.equalTo(welcome);
    }];
    
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
        make.top.equalTo(photoView.mas_bottom).offset(27);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(98, 24));
    }];
    
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
- (id)UserScreenPhoteLayout:(UIView*)view {
    view.frame = CGRectMake((SCREEN_WIDTH - SCREEN_PHOTO_WIDTH) * 0.5, PHOTOY, SCREEN_PHOTO_WIDTH, SCREEN_PHOTO_WIDTH);
//    view.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_PHOTO_TOP_MARGIN + SCREEN_PHOTO_HEIGHT / 2);
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(tips).offset(40);
//        make.centerX.equalTo(tips);
//        make.size.mas_equalTo(CGSizeMake(114, 114));
//    }];
    
    return nil;
}

#pragma mark -- actions
- (void)tapGesture:(UITapGestureRecognizer*)gesture {
    NSLog(@"tap esle where");
    
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
        [[[UIAlertView alloc] initWithTitle:@"通知" message:@"您没有选择用户头像" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        return ;
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
    
//    NSString* msg = [_login_attr objectForKey:@"message"];
//    //新用户
//    if ([msg isEqualToString:@"new_user"] || !msg) {
//        [dic_update setValue:@"" forKey:@"screen_photo"];
//    }
//
//    //已注册用户
//    if ([msg isEqualToString:@"logined_user"]) {
//        [dic_update setValue:[_login_attr objectForKey:@"role_tag"] forKey:@"role_tag"];
//    }
    
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

- (BOOL)prefersStatusBarHidden{
    return NO;
}

@end
