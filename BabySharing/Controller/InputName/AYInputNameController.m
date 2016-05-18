//
//  AYUserInfoInput.m
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYInputNameController.h"
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

@interface AYInputNameController () <UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableDictionary* dic_userinfo;
@property (nonatomic, strong) NSString* userName;
@end

@implementation AYInputNameController {
    BOOL isChangeImg;
    CGRect keyBoardFrame;
}

@synthesize dic_userinfo = _dic_userinfo;
@synthesize userName = _userName;

#pragma mark -- commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
//    [super performWithResult:obj];
    NSDictionary* dic = (NSDictionary*)*obj;

    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        _dic_userinfo = [(NSDictionary*)[dic objectForKey:kAYControllerChangeArgsKey] mutableCopy];
        NSString* nameString = [_dic_userinfo objectForKey:@"screen_name"];
        if (nameString) {
            _userName = nameString;
        }
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools themeColor];
    self.navigationController.navigationBar.tintColor = [Tools themeColor];
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:(UIView*)view_title];
    
    id<AYViewBase> view = [self.views objectForKey:@"LandingInputCoder"];
    id<AYCommand> cmd_view = [view.commands objectForKey:@"startConfirmCodeTimer"];
    [cmd_view performWithResult:nil];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
    [bar_right_btn setTitle:@"完成" forState:UIControlStateNormal];
    [bar_right_btn sizeToFit];
    bar_right_btn.center = CGPointMake(width - 10.5 - bar_right_btn.frame.size.width / 2, 64 / 2);
    
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
    [cmd_right performWithResult:&bar_right_btn];
    
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UILabel* titleView = (UILabel*)view;
    titleView.text = @"3/3";
    titleView.font = [UIFont systemFontOfSize:18.f];
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    titleView.center = CGPointMake(width / 2, 64 / 2);
    return nil;
}

- (id)LandingInputNameLayout:(UIView*)view {
    NSLog(@"Landing Input View view layout");
    view.frame = CGRectMake(43, 102, SCREEN_WIDTH - 43*2, 130);
    return nil;
}

#pragma mark -- actions
- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {
    NSLog(@"tap esle where");
    id<AYViewBase> view = [self.views objectForKey:@"LandingInputName"];
    id<AYCommand> cmd = [view.commands objectForKey:@"hideKeyboard"];
    [cmd performWithResult:nil];
}

- (id)beginEditTextFiled {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [self performWithResult:&dic];
    return nil;
}

- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)rightBtnSelected {
    NSLog(@"setting view controller");
    id<AYViewBase> view = [self.views objectForKey:@"LandingInputName"];
    id<AYCommand> cmd_hiden = [view.commands objectForKey:@"hideKeyboard"];
    [cmd_hiden performWithResult:nil];
    
    id<AYViewBase> coder_view = [self.views objectForKey:@"LandingInputName"];
    id<AYCommand> cmd_coder = [coder_view.commands objectForKey:@"queryInputName:"];
    NSString* input_name = nil;
    [cmd_coder performWithResult:&input_name];
    
    if ([Tools bityWithStr:input_name] < 4 || [Tools bityWithStr:input_name] > 16) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"角色名长度应在4-16之间(汉字／大写字母长度为2)" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        return nil;
    }
    
    //通用参数
    NSMutableDictionary* dic_update = [[NSMutableDictionary alloc]init];
    [dic_update setValue:[_dic_userinfo objectForKey:@"auth_token"] forKey:@"auth_token"];
    [dic_update setValue:[_dic_userinfo objectForKey:@"user_id"] forKey:@"user_id"];
    [dic_update setValue:0 forKey:@"gender"];
    [dic_update setValue:[Tools getDeviceUUID] forKey:@"uuid"];
    [dic_update setValue:[NSNumber numberWithInt:1] forKey:@"refresh_token"];
    [dic_update setValue:(NSString*)input_name forKey:@"screen_name"];
    if ([[_dic_userinfo allKeys] containsObject:@"phoneNo"]) {
        [dic_update setValue:[_dic_userinfo objectForKey:@"phoneNo"] forKey:@"phoneNo"];
        [dic_update setValue:[NSNumber numberWithInt:1] forKey:@"create"];
    }
    
    //新用户
    if ([[_dic_userinfo objectForKey:@"user_state"] isEqualToString:@"new_user"]) {
        [dic_update setValue:@"无角色名" forKey:@"role_tag"];
        [dic_update setValue:@"" forKey:@"screen_photo"];
    }
    
    //已注册用户
    if ([[_dic_userinfo objectForKey:@"user_state"] isEqualToString:@"logined_user"]) {
        [dic_update setValue:[_dic_userinfo objectForKey:@"role_tag"] forKey:@"role_tag"];
        [dic_update setValue:[_dic_userinfo objectForKey:@"screen_photo"] forKey:@"screen_photo"];
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
    
    AYModel* m = MODEL;
    AYFacade* f = [m.facades objectForKey:@"LoginModel"];
    id<AYCommand> cmd = [f.commands objectForKey:@"ChangeCurrentLoginUser"];
    NSDictionary* args = [_dic_userinfo copy];
    [cmd performWithResult:&args];
    
    
    return nil;
}

- (id)CurrentLoginUserChanged:(id)args {
    
    UIViewController* active = [Tools activityViewController];
    //    if (active.viewControllers.lastObject == self) {
    if (active == self) {
        NSLog(@"Notify args: %@", args);
        //    NSLog(@"TODO: 进入咚哒");
        
        NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
        [dic_pop setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
        [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
        
        NSString* message_name = @"LoginSuccess";
        [dic_pop setValue:message_name forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = POPTOROOT;
        [cmd performWithResult:&dic_pop];
    }
    
    return nil;
}

-(id)queryCurUserName:(NSString*)args{
    return _userName;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end
