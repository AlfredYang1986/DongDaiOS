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
#import "TmpFileStorageModel.h"

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height


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
    [bar_right_btn setTitle:@"下一步" forState:UIControlStateNormal];
    [bar_right_btn sizeToFit];
    bar_right_btn.center = CGPointMake(width - 10.5 - bar_right_btn.frame.size.width / 2, 64 / 2);
    
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
    [cmd_right performWithResult:&bar_right_btn];
    
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UILabel* titleView = (UILabel*)view;
    titleView.text = @" ";
    titleView.font = [UIFont systemFontOfSize:18.f];
    titleView.textColor = [UIColor whiteColor];
    [titleView sizeToFit];
    titleView.center = CGPointMake(width / 2, 64 / 2);
    return nil;
}

- (id)LandingInputNameLayout:(UIView*)view {
    CGFloat margin = 20.f;
    view.frame = CGRectMake(margin, 83, SCREEN_WIDTH - margin*2, 320);
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
    
    if ([Tools bityWithStr:input_name] < 4 || [Tools bityWithStr:input_name] > 32) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"姓名长度应在4-32个字符之间(汉字／大写字母长度为2)" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        return nil;
    }
    
    [_dic_userinfo setValue:@"未设置角色名" forKey:@"role_tag"];
    [_dic_userinfo setValue:input_name forKey:@"screen_name"];
    
//    id<AYCommand> destin = DEFAULTCONTROLLER(@"InputRole");
//    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:4];
//    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
//    [dic setValue:destin forKey:kAYControllerActionDestinationControllerKey];
//    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [dic setValue:_dic_userinfo forKey:kAYControllerChangeArgsKey];
//    
//    id<AYCommand> cmd_push = PUSH;
//    [cmd_push performWithResult:&dic];
    
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

-(id)queryCurUserName:(NSString*)args{
    return _userName;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end
