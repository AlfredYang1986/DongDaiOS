//
//  AYUserInfoInput.m
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYInputNameController.h"
#import "AYViewBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYCommandDefines.h"
#import "AYModel.h"
#import "AYFactoryManager.h"
#import "AYRemoteCallCommand.h"
#import "OBShapedButton.h"
#import "TmpFileStorageModel.h"


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
    self.view.backgroundColor = [Tools whiteColor];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
        NSString *title = @"4-32个字符(汉字／大写字母长度为2)\n*仅限中英文";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        return nil;
    }
    
    [_dic_userinfo setValue:@"未设置角色名" forKey:@"role_tag"];
    [_dic_userinfo setValue:input_name forKey:@"screen_name"];
    
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
