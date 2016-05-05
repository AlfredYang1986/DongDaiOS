//
//  AYOthersLoginController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/7/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYOthersLoginController.h"
#import "Tools.h"
#import "OBShapedButton.h"
#import "AYResourceManager.h"
#import "AYCommandDefines.h"
#import "AYViewBase.h"
#import "AYFactoryManager.h"
#import "AYModel.h"
#import "AYRemoteCallCommand.h"

#define SCREEN_PHOTO_TOP_MARGIN                 [UIScreen mainScreen].bounds.size.height * 0.1844
#define SCREEN_PHOTO_CENTER_MARGIN              -[UIScreen mainScreen].bounds.size.height * 0.1828 +12 + 10
#define SCREEN_PHOTO_WIDTH                      76
#define SCREEN_PHOTO_HEIGHT                     SCREEN_PHOTO_WIDTH

#define SCREEN_NAME_2_PHOTO_MARGIN              6 //22

#define SCREEN_NAME_2_ROLE_TAG_MARGIN           10

#define IS_TAHT_YOU_LABEL_TO_CENTER_MARGIN      20
#define IS_TAHT_YOU_LABEL_TO_IMG_MARGIN         -108
#define IS_TAHT_YOU_LABEL_TO_TOP_MARGIN         20
#define YES_BTN_TOP_MARGIN                      61 //81
#define YES_BTN_2_NO_BTN_MARGIN                 34

#define YES_NO_BTN_TO_EDGE_MARGIN               32.5
#define YES_NO_BTN_HEIGHT                       37
//#define YES_NO_BTN_WIDTH                        ([UIScreen mainScreen].bounds.size.width - 2 * YES_NO_BTN_TO_EDGE_MARGIN)
#define YES_NO_BTN_WIDTH                        ([UIScreen mainScreen].bounds.size.width * 0.584)

@interface AYOthersLoginController ()
@property (nonatomic, strong) NSMutableDictionary* login_attr;

@property (strong, nonatomic) UILabel *nickNameLabel;
@property (strong, nonatomic) UILabel *currentTagLabel;
@property (strong, nonatomic) UIButton *yesBtn;
@property (strong, nonatomic) UIButton *noBtn;
@property (strong, nonatomic) UIView* fakeBar;
@end

@implementation AYOthersLoginController

@synthesize login_attr = _login_attr;

@synthesize nickNameLabel = _nickNameLabel;
@synthesize currentTagLabel = _currentTagLabel;
@synthesize yesBtn = _yesBtn;
@synthesize noBtn = _noBtn;
@synthesize fakeBar = _fakeBar;

#pragma mark -- commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        _login_attr = [[dic objectForKey:kAYControllerChangeArgsKey] mutableCopy];
        NSLog(@"init args are : %@", _login_attr);
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        AYViewController* des = DEFAULTCONTROLLER(@"UserInfoInput");
        
        NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
        [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
        [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
        [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
        [dic_push setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define FAKE_BAR_HEIGHT         44
#define STATUS_BAR_HEIGHT       20
    
#define BACK_BTN_LEFT_MARGIN    10 //16 + 10
    _fakeBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, FAKE_BAR_HEIGHT)];
    _fakeBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_fakeBar];
    [self.view bringSubviewToFront:_fakeBar];
    
    UIButton* barBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    CALayer * layer_btn = [CALayer layer];
    layer_btn.contents = (id)PNGRESOURCE(@"dongda_back").CGImage;
    layer_btn.frame = CGRectMake(0, 0, 25, 25);
    [barBtn.layer addSublayer:layer_btn];
    barBtn.center = CGPointMake(BACK_BTN_LEFT_MARGIN + barBtn.frame.size.width / 2, STATUS_BAR_HEIGHT + FAKE_BAR_HEIGHT / 2);
    
    [barBtn addTarget:self action:@selector(didPopViewController) forControlEvents:UIControlEventTouchDown];
    [_fakeBar addSubview:barBtn];
    
    UILabel* qa = [[UILabel alloc]init];
    [self.view addSubview:qa];
    [self.view bringSubviewToFront:qa];
    qa.text = @"检测到该手机号码已绑定如下账号";
    qa.font = [UIFont systemFontOfSize:14.f];
    [qa sizeToFit];
    qa.textColor = [UIColor colorWithWhite:0.2902 alpha:1.f];
    [qa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(SCREEN_PHOTO_TOP_MARGIN);
        make.centerX.equalTo(self.view);
    }];
    
    UIView* ib = [self.views objectForKey:@"UserScreenPhoteSelect"];
    [ib mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qa.mas_bottom).offset(38);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(SCREEN_PHOTO_WIDTH);
        make.height.mas_equalTo(SCREEN_PHOTO_WIDTH);
    }];
    
    _nickNameLabel = [[UILabel alloc]init];
    _nickNameLabel.text = [_login_attr objectForKey:@"screen_name"];
    _nickNameLabel.font = [UIFont systemFontOfSize:14.f];
    [_nickNameLabel sizeToFit];
    _nickNameLabel.textColor = [UIColor colorWithWhite:0.5922 alpha:1.f];
    [self.view addSubview:_nickNameLabel];
    [self.view bringSubviewToFront:_nickNameLabel];
    
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(ib.mas_bottom).offset(18);
    }];
    
    _currentTagLabel = [[UILabel alloc] init];
    _currentTagLabel.font = [UIFont systemFontOfSize:12];
    _currentTagLabel.backgroundColor = [Tools colorWithRED:254.0 GREEN:192.0 BLUE:0.0 ALPHA:1.0];
    _currentTagLabel.textAlignment = NSTextAlignmentCenter;
    _currentTagLabel.layer.masksToBounds = YES;
    _currentTagLabel.layer.cornerRadius = 3;
    _currentTagLabel.text = [_login_attr objectForKey:@"role_tag"];
    _currentTagLabel.textColor = [UIColor whiteColor];
    [_currentTagLabel sizeToFit];
    [self.view addSubview:_currentTagLabel];
    [self.view bringSubviewToFront:_currentTagLabel];
    [_currentTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(_nickNameLabel);
    }];
    
    CGFloat allWidth = _nickNameLabel.frame.size.width + _currentTagLabel.frame.size.width +  14;
    CGFloat padding = (width - allWidth) / 2;
    [_nickNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(padding - 4);
        make.top.equalTo(ib.mas_bottom).offset(18);
    }];
    
    [_currentTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nickNameLabel.mas_right).offset(8);
        make.centerY.equalTo(_nickNameLabel);
        make.width.mas_equalTo(CGRectGetWidth(_currentTagLabel.frame) + 18);
        make.height.mas_equalTo(CGRectGetHeight(_currentTagLabel.frame) + 2);
    }];
    
    /**
     * border for yes btn and no btn
     */
    _yesBtn = [[OBShapedButton alloc]init];
    [_yesBtn setBackgroundImage:PNGRESOURCE(@"login_yes_btn_bg") forState:UIControlStateNormal];
    [_yesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_yesBtn setTitle:@"是我, 进入咚哒" forState:UIControlStateNormal];
    _yesBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [self.view addSubview:_yesBtn];
    [self.view bringSubviewToFront:_yesBtn];
    [_yesBtn addTarget:self action:@selector(didSelectMeButton) forControlEvents:UIControlEventTouchUpInside];
    [_yesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nickNameLabel.mas_bottom).offset(60);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(YES_NO_BTN_WIDTH);
        make.height.mas_equalTo(YES_NO_BTN_HEIGHT);
    }];
    
    _noBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, YES_NO_BTN_WIDTH, YES_NO_BTN_HEIGHT)];
    [_noBtn setTitleColor:[UIColor colorWithWhite:0.2902 alpha:1.f] forState:UIControlStateNormal];
    [_noBtn setTitle:@"不是我, 帐号重建" forState:UIControlStateNormal];
    _noBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [self.view addSubview:_noBtn];
    [self.view bringSubviewToFront:_noBtn];
    [_noBtn addTarget:self action:@selector(didSelectCreateNewAccount) forControlEvents:UIControlEventTouchUpInside];
    [_noBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_yesBtn.mas_bottom).offset(40);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(YES_NO_BTN_WIDTH);
        make.height.mas_equalTo(YES_NO_BTN_HEIGHT);
    }];
    
    
    id<AYViewBase> view = [self.views objectForKey:@"UserScreenPhoteSelect"];
    id<AYCommand> cmd = [view.commands objectForKey:@"canPhotoBtnClicked:"];
    NSNumber* b = [NSNumber numberWithBool:NO];
    [cmd performWithResult:&b];
   
    AYFacade* f = [self.facades objectForKey:@"FileRemote"];
    AYRemoteCallCommand* cmd_download = [f.commands objectForKey:@"DownloadUserFiles"];
    NSMutableDictionary* dic_download = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic_download setValue:[_login_attr objectForKey:@"screen_photo"] forKey:@"image"];
    [cmd_download performWithResult:[dic_download copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        UIImage* img = (UIImage*)result;
        id<AYCommand> cmd = [view.commands objectForKey:@"changeScreenPhoto:"];
        if (img != nil) {
            [cmd performWithResult:&img];
        }
    }];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
}

#pragma mark -- views layouts
- (id)UserScreenPhoteSelectLayout:(UIView*)view {
    return nil;
}

#pragma mark -- action btn
- (void)didSelectMeButton {
    NSLog(@"it is me btn");
    AYModel* m = MODEL;
    AYFacade* f = [m.facades objectForKey:@"LoginModel"];
    id<AYCommand> cmd = [f.commands objectForKey:@"ChangeCurrentLoginUser"];
    NSDictionary* args = [_login_attr copy];
    [cmd performWithResult:&args];
}

- (void)didSelectCreateNewAccount {
    NSLog(@"create new account btn");
   
    AYFacade* f = [self.facades objectForKey:@"LandingRemote"];
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"CreateTmpUserWithPhone"];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:[_login_attr objectForKey:@"phoneNo"] forKey:@"phoneNo"];
    [dic setValue:[Tools getDeviceUUID] forKey:@"uuid"];
    
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        NSLog(@"Create tmp new users %@", result);
        [self performForView:nil andFacade:@"LoginModel" andMessage:@"ChangeRegUser" andArgs:result];
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:1];
        [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
//        [dic setValue:[NSNumber numberWithInt:RegisterResultSuccess] forKey:kAYLandingControllerRegisterResultKey];
        [dic setValue:result forKey:kAYControllerChangeArgsKey];
        [self performWithResult:&dic];
    }];
}

- (void)didPopViewController {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
}

#pragma mark -- notification
- (id)CurrentLoginUserChanged:(id)args {
//    UINavigationController* active = (UINavigationController*)[Tools activityViewController];
    UIViewController* active = [Tools activityViewController];
//    if (active.viewControllers.lastObject == self) {
    if (active == self) {
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
    }
    
    return nil;
}
@end
