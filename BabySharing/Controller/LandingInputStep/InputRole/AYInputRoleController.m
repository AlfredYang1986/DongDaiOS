//
//  AYUserInfoInput.m
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYInputRoleController.h"
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


@interface AYInputRoleController () <UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableDictionary* dic_userinfo;
@property (nonatomic, strong) NSString* user_role;
@end

@implementation AYInputRoleController {
    BOOL isChangeImg;
    CGRect keyBoardFrame;
}

@synthesize dic_userinfo = _dic_userinfo;
@synthesize user_role = _user_role;

#pragma mark -- commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;

    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        _dic_userinfo = [(NSDictionary*)[dic objectForKey:kAYControllerChangeArgsKey] mutableCopy];
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools themeColor];
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:(UIView*)view_title];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere:)];
    [self.view addGestureRecognizer:tap];
    
    [self queryRecommandData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)queryRecommandData {
    NSMutableDictionary *user = [[NSMutableDictionary alloc]initWithCapacity:2];
    [user setValue:[_dic_userinfo objectForKey:@"auth_token"] forKey:@"auth_token"];
    [user setValue:[_dic_userinfo objectForKey:@"user_id"] forKey:@"user_id"];
    
    id<AYFacadeBase> f_search = [self.facades objectForKey:@"SearchRemote"];
    AYRemoteCallCommand* cmd_role_tags = [f_search.commands objectForKey:@"QueryRecommandRoleTags"];
    
    [cmd_role_tags performWithResult:[user copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            NSLog(@"query recommand role tags result %@", result);
            id<AYViewBase> view = [self.views objectForKey:@"LandingInputRole"];
            id<AYCommand> cmd = [view.commands objectForKey:@"changeQueryData:"];
            id obj = result;
            [cmd performWithResult:&obj];
        }
    }];
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
    titleView.text = @"4/4";
    titleView.font = [UIFont systemFontOfSize:18.f];
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    titleView.center = CGPointMake(width / 2, 64 / 2);
    return nil;
}

- (id)LandingInputRoleLayout:(UIView*)view {
    NSLog(@"Landing Input View view layout");
    view.frame = CGRectMake(43, 102, SCREEN_WIDTH - 43*2, 180);
    return nil;
}

#pragma mark -- actions
- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {
    NSLog(@"tap esle where");
    id<AYViewBase> view = [self.views objectForKey:@"LandingInputRole"];
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
    id<AYViewBase> view = [self.views objectForKey:@"LandingInputRole"];
    id<AYCommand> cmd = [view.commands objectForKey:@"hideKeyboard"];
    [cmd performWithResult:nil];
    
    
    id<AYViewBase> coder_view = [self.views objectForKey:@"LandingInputRole"];
    id<AYCommand> cmd_role = [coder_view.commands objectForKey:@"queryInputRole:"];
    NSString* input_role = nil;
    [cmd_role performWithResult:&input_role];
    
    [_dic_userinfo setValue:input_role forKey:@"role_tag"];
    if ([Tools bityWithStr:input_role] < 4 || [Tools bityWithStr:input_role] > 16) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"角色名长度应在4-16之间(汉字／大写字母长度为2)" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        return nil;
    }
    
    [_dic_userinfo setValue:input_role forKey:@"role_tag"];
    
    id<AYCommand> destin = DEFAULTCONTROLLER(@"Welcome");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:destin forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:_dic_userinfo forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_push = PUSH;
    [cmd_push performWithResult:&dic];
    return nil;
}

- (id)startRemoteCall:(id)obj {
    return nil;
}

- (id)endRemoteCall:(id)obj {
    return nil;
}

-(NSString*)user_role{
    return _user_role;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end
