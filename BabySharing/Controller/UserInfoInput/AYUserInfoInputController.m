//
//  AYUserInfoInput.m
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYUserInfoInputController.h"
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
#define SCREEN_PHOTO_WIDTH                      76
#define SCREEN_PHOTO_HEIGHT                     76

#define SCREEN_PHOTO_2_GENDER_BTN_MARGIN        30

#define GENDER_BTN_WIDTH                        38
#define GENDER_BTN_HEIGHT                       GENDER_BTN_WIDTH

#define FATHER_ICON_WIDTH                       11.5
#define FATHER_ICON_HEIGHT                      FATHER_ICON_WIDTH

#define GENDER_BTN_BETWEEN_MARGIN               SCREEN_WIDTH / 4

#define INPUT_VIEW_2_SCREEN_PHOTO_MARGIN        (SCREEN_HEIGHT / 20 - 5)

#define TICK_BTN_WIDTH                          17
#define TICK_BTN_HEIGHT                         TICK_BTN_WIDTH

#define TICK_BTN_2_PRIVACY_MARGIN               10

@interface AYUserInfoInputController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSMutableDictionary* login_attr;
@end

@implementation AYUserInfoInputController {
    BOOL isChangeImg;
    CGRect keyBoardFrame;
}

@synthesize login_attr = _login_attr;

#pragma mark -- commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
   
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        _login_attr = [[dic objectForKey:kAYControllerChangeArgsKey] mutableCopy];
        NSLog(@"init args are : %@", _login_attr);
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        AYViewController* des = DEFAULTCONTROLLER(@"RoleTagSearch");
        
        NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
        [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
        [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
//        [dic_push setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        NSString* role_tag = [dic objectForKey:kAYControllerChangeArgsKey];
        if (role_tag && ![role_tag isEqualToString:@""]) {
            id<AYViewBase> view = [self.views objectForKey:@"UserInfoInput"];
            id<AYCommand> cmd = [view.commands objectForKey:@"changeRoleTag:"];
            NSString* arg = [role_tag copy];
            [cmd performWithResult:&arg];
        }
    }
}

#pragma mark -- life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    
//    id<AYViewBase> view = [self.views objectForKey:@"UserInfoInput"];
//    id<AYCommand> cmd = [view.commands objectForKey:@"changeScreenName:"];
//    NSString* screen_name = @"test";
//    [cmd performWithResult:&screen_name];
    
    NSLog(@"login attrs : %@", _login_attr);
   
    NSString* screen_photo = [_login_attr objectForKey:@"screen_photo"];
    if (screen_photo && ![screen_photo isEqualToString:@""]) {

        id<AYViewBase> view = [self.views objectForKey:@"UserScreenPhoteSelect"];
        id<AYCommand> cmd = [view.commands objectForKey:@"changeScreenPhoto:"];
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:screen_photo forKey:@"image"];
       
        id<AYFacadeBase> facade_download = [self.facades objectForKey:@"FileRemote"];
        AYRemoteCallCommand* cmd_query_image = [facade_download.commands objectForKey:@"DownloadUserFiles"];
        [cmd_query_image performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            UIImage* image = (UIImage*)result;
            [cmd performWithResult:&image];
        }];
    }
    
    NSString* screen_name = [_login_attr objectForKey:@"screen_name"];
    if (screen_name && ![screen_name isEqualToString:@""]) {
        id<AYViewBase> view = [self.views objectForKey:@"UserInfoInput"];
        id<AYCommand> cmd = [view.commands objectForKey:@"changeScreenName:"];
        NSString* arg = [screen_name copy];
        [cmd performWithResult:&arg];
    }
    
    NSString* role_tag = [_login_attr objectForKey:@"role_tag"];
    if (role_tag && ![role_tag isEqualToString:@""]) {
        id<AYViewBase> view = [self.views objectForKey:@"UserInfoInput"];
        id<AYCommand> cmd = [view.commands objectForKey:@"changeRoleTag:"];
        NSString* arg = [role_tag copy];
        [cmd performWithResult:&arg];
    }
    
    UIButton* pri_btn = [[OBShapedButton alloc]init];
    [self.view addSubview:pri_btn];
    pri_btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [pri_btn setTitle:@"进入即同意用户协议及隐私条款" forState:UIControlStateNormal];
    [pri_btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    pri_btn.clipsToBounds = YES;
    [pri_btn addTarget:self action:@selector(pri_btnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [pri_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width - 20);
        make.height.mas_equalTo(20);
    }];
}

- (void)pri_btnDidClick{
    NSLog(@"push to suer privacy");
    id<AYCommand> UserAgree = DEFAULTCONTROLLER(@"UserAgree");
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:UserAgree forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /**
     * input method
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardDidHideNotification object:nil];
//    inputView.isMoved = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark -- views layouts
- (id)UserScreenPhoteSelectLayout:(UIView*)view {
    return nil;
}

- (id)UserInfoInputLayout:(UIView*)view {
//    [view setUpWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_PHOTO_TOP_MARGIN + SCREEN_PHOTO_HEIGHT + SCREEN_PHOTO_TOP_MARGIN*0.5 + view.frame.size.height / 2);
    return nil;
}

- (id)SetNevigationBarLeftBtnLayout:(UIView*)view {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    self.navigationItem.titleView = view;
    return nil;
}

#pragma mark -- keyboard
- (void)keyboardDidShow:(NSNotification*)notification {
    UIView *result = nil;
    NSArray *windowsArray = [UIApplication sharedApplication].windows;
    for (UIView *tmpWindow in windowsArray) {
        NSArray *viewArray = [tmpWindow subviews];
        for (UIView *tmpView  in viewArray) {
            NSLog(@"%@", [NSString stringWithUTF8String:object_getClassName(tmpView)]);
            // if ([[NSString stringWithUTF8String:object_getClassName(tmpView)] isEqualToString:@"UIPeripheralHostView"]) {
            if ([[NSString stringWithUTF8String:object_getClassName(tmpView)] isEqualToString:@"UIInputSetContainerView"]) {
                result = tmpView;
                break;
            }
        }
        
        if (result != nil) {
            break;
        }
    }
    
    //    keyboardView = result;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyBoardFrame = value.CGRectValue;
    
//    CGFloat height = [UIScreen mainScreen].bounds.size.height - (inputView.frame.size.height + inputView.frame.origin.y);
//    if (!inputView.isMoved) {
//        [self moveView:-height];
//    }
}

- (void)keyboardWasChange:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyBoardFrame = value.CGRectValue;
}

- (void)keyboardDidHidden:(NSNotification*)notification {
//    CGFloat height = [UIScreen mainScreen].bounds.size.height - (inputView.frame.size.height + inputView.frame.origin.y);
//    if (inputView.isMoved) {
//        [self moveView:height];
//    }
}

#pragma mark -- actions
- (void)tapGesture:(UITapGestureRecognizer*)gesture {
    NSLog(@"tap esle where");
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {

    isChangeImg = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];

    // get image name
    id<AYCommand> uuid_cmd = [self.commands objectForKey:@"GernarateImgUUID"];
    NSString* img_name = nil;
    [uuid_cmd performWithResult:&img_name];
    NSLog(@"new image name is %@", img_name);
    [_login_attr setValue:img_name forKey:@"screen_photo"];
    
    // sava image to local
    id<AYCommand> save_cmd = [self.commands objectForKey:@"SaveImgLocal"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:img_name forKey:@"img_name"];
    [dic setValue:image forKey:@"image"];
    [save_cmd performWithResult:&dic];
    
    id<AYViewBase> view = [self.views objectForKey:@"UserScreenPhoteSelect"];
    id<AYCommand> cmd = [view.commands objectForKey:@"changeScreenPhoto:"];
    [cmd performWithResult:&image];
}

#pragma mark -- view notification
- (id)updateUserProfile:(id)obj {
    NSLog(@"next button is clicked, with args %@", obj);
   
    NSDictionary* dic_args = (NSDictionary*)obj;
    NSString* screen_name = [dic_args objectForKey:@"screen_name"];
    NSString* role_tag = [dic_args objectForKey:@"role_tag"];
    NSString* screen_photo = [_login_attr objectForKey:@"screen_photo"];
    
    if (!screen_photo || [screen_photo isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"通知" message:@"您没有选择用户头像" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        return nil;
    }
   
//    role_tag = @"Alfred Test";
    if ([Tools bityWithStr:screen_name] < 4 || [Tools bityWithStr:role_tag] < 4) {
        [[[UIAlertView alloc] initWithTitle:@"通知" message:@"您的名称或者角色过短" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        return nil;
    }
    
    NSString* auth_token = [_login_attr objectForKey:@"auth_token"];
    NSString* user_id = [_login_attr objectForKey:@"user_id"];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:screen_name forKey:@"screen_name"];
    [dic setValue:role_tag forKey:@"role_tag"];
    
    [dic setValue:auth_token forKey:@"auth_token"];
    [dic setValue:user_id forKey:@"user_id"];
    
    [dic setValue:0 forKey:@"gender"];
    
    [dic setValue:[Tools getDeviceUUID] forKey:@"uuid"];
    [dic setValue:[NSNumber numberWithInt:1] forKey:@"refresh_token"];
    
    if ([[_login_attr allKeys] containsObject:@"phoneNo"]) {
        [dic setValue:[_login_attr objectForKey:@"phoneNo"] forKey:@"phoneNo"];
        [dic setValue:[NSNumber numberWithInt:1] forKey:@"create"];
    }
    
    if (isChangeImg) {
        [dic setValue:screen_photo forKey:@"screen_photo"];
       
        NSMutableDictionary* photo_dic = [[NSMutableDictionary alloc]initWithCapacity:1];
        [photo_dic setValue:screen_photo forKey:@"image"];
        
        id<AYFacadeBase> up_facade = [self.facades objectForKey:@"FileRemote"];
        AYRemoteCallCommand* up_cmd = [up_facade.commands objectForKey:@"UploadUserImage"];
        [up_cmd performWithResult:[photo_dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            NSLog(@"upload result are %d", success);
        }];
    }
    
    id<AYFacadeBase> profileRemote = [self.facades objectForKey:@"ProfileRemote"];
    AYRemoteCallCommand* cmd = [profileRemote.commands objectForKey:@"UpdateUserDetail"];
    [cmd performWithResult:dic andFinishBlack:^(BOOL success, NSDictionary * result) {
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
    
    return nil;
}

- (id)CurrentLoginUserChanged:(id)args {
    NSLog(@"Notify args: %@", args);
//    NSLog(@"TODO: 进入咚哒");
   
//    AYViewController* des = DEFAULTCONTROLLER(@"TabBar");
//    
//    NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc]init];
//    [dic_show_module setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
//    [dic_show_module setValue:des forKey:kAYControllerActionDestinationControllerKey];
//    [dic_show_module setValue:self forKey:kAYControllerActionSourceControllerKey];
//    
//    id<AYCommand> cmd = SHOWMODULE;
//    [cmd performWithResult:&dic_show_module];
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
  
    NSString* message_name = @"LoginSuccess";
    [dic_pop setValue:message_name forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POPTOROOT;
    [cmd performWithResult:&dic_pop];
    
    return nil;
}

- (id)popToPreviousWithoutSave {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)beginEditTextFiled {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [self performWithResult:&dic];
    return nil;
}
@end
