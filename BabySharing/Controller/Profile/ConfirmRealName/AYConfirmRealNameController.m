//
//  AYConfirmRealNameController.m
//  BabySharing
//
//  Created by Alfred Yang on 14/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYConfirmRealNameController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"


@interface AYConfirmRealNameController ()

@end

@implementation AYConfirmRealNameController{
    UITextField *nameTextField;
    UITextField *coderTextField;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    UILabel *title = [Tools creatUILabelWithText:@"还差一步，实名认证" andTextColor:[Tools blackColor] andFontSize:-20.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(92);
        make.left.equalTo(self.view).offset(20);
    }];
    
    UILabel *descLabel = [Tools creatUILabelWithText:@"实名信息认证,为您的服务提高可信度" andTextColor:[Tools blackColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    descLabel.numberOfLines = 0;
    [self.view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(8);
        make.left.equalTo(title);
    }];
	
	CGFloat inputTextFieldHeight = 60;
	
    nameTextField = [[UITextField alloc]init];
    nameTextField.placeholder = @"真实姓名";
    nameTextField.font = [UIFont boldSystemFontOfSize:18.f];
    nameTextField.textColor = [Tools themeColor];
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    nameTextField.backgroundColor = [Tools whiteColor];
//    UIView *paddingView = [[UIView alloc]init];
//    paddingView.bounds = CGRectMake(0, 0, 10, 1);
//    nameTextField.leftView = paddingView;
//    nameTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:nameTextField];
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLabel.mas_bottom).offset(25);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, inputTextFieldHeight));
    }];
    [Tools creatCALayerWithFrame:CGRectMake(0, inputTextFieldHeight - 0.5, SCREEN_WIDTH - 50, 0.5) andColor:[Tools themeColor] inSuperView:nameTextField];
	
    coderTextField = [[UITextField alloc]init];
    coderTextField.placeholder = @"身份证号";
    coderTextField.font = [UIFont boldSystemFontOfSize:18.f];
    coderTextField.textColor = [Tools themeColor];
    coderTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    coderTextField.backgroundColor = [Tools whiteColor];
//    UIView *paddingView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 1)];
//    coderTextField.leftView = paddingView2;
//    coderTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:coderTextField];
    [coderTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTextField.mas_bottom).offset(10);
        make.centerX.equalTo(nameTextField);
        make.size.equalTo(nameTextField);
    }];
	[Tools creatCALayerWithFrame:CGRectMake(0, inputTextFieldHeight - 0.5, SCREEN_WIDTH - 50, 0.5) andColor:[Tools themeColor] inSuperView:coderTextField];
	
	UIButton *enterBtn = [Tools creatUIButtonWithTitle:@"提交" andTitleColor:[Tools whiteColor] andFontSize:-18.f andBackgroundColor:[Tools themeColor]];
	[Tools setViewBorder:enterBtn withRadius:22.5f andBorderWidth:0 andBorderColor:nil andBackground:[Tools themeColor]];
	[enterBtn addTarget:self action:@selector(rightBtnSelected) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:enterBtn];
	[enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(coderTextField.mas_bottom).offset(30);
		make.centerX.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(130, 45));
	}];
	
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    view.backgroundColor = [UIColor clearColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	view.backgroundColor = [UIColor clearColor];
	
	UIImage* left = IMGRESOURCE(@"bar_left_theme");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber* right_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
    return nil;
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    
    if ([nameTextField.text isEqualToString:@""] || [coderTextField.text isEqualToString:@""]) {
        NSString *title = @"请完善个人信息！";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        return nil;
    }
    
    NSDictionary* user = nil;
    CURRENUSER(user);
    id<AYFacadeBase> f = [self.facades objectForKey:@"AuthRemote"];
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"PushRealName"];
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:[user objectForKey:@"user_id"] forKey:@"user_id"];
    [dic_push setValue:nameTextField.text forKey:@"real_name"];
    [dic_push setValue:coderTextField.text forKey:@"social_id"];
    
    [cmd performWithResult:dic_push andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            
            /**
             *  save to coredata
             */
            id<AYFacadeBase> facade = LOGINMODEL;
            id<AYCommand> cmd_profile = [facade.commands objectForKey:@"UpdateLocalCurrentUserProfile"];
            
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//            [dic setValue:tmp forKey:@"contact_no"];
            [dic setValue:[NSNumber numberWithInt:1] forKey:@"is_real_name_cert"];
            
            [cmd_profile performWithResult:&dic];
            
            /**
             *  go on
             */
            AYViewController* des = DEFAULTCONTROLLER(@"ConfirmFinish");
            NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
            [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
            [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
            [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
            
            NSString *tip = @"您的信息已成功提交";
            [dic_push setValue:tip forKey:kAYControllerChangeArgsKey];
            
            id<AYCommand> cmd = PUSH;
            [cmd performWithResult:&dic_push];
        }
        
    }];
    
    return nil;
}

- (void)tapGesture:(UITapGestureRecognizer*)gesture {
    
    if ([nameTextField isFirstResponder]) {
        [nameTextField resignFirstResponder];
    }
    if ([coderTextField isFirstResponder]) {
        [coderTextField resignFirstResponder];
    }
}

#pragma mark -- Keyboard facade
- (id)KeyboardShowKeyboard:(id)args {
	
	NSNumber* step = [(NSDictionary*)args objectForKey:kAYNotifyKeyboardArgsHeightKey];
	
	CGFloat maxY = CGRectGetMaxY(coderTextField.frame);
	CGFloat keyBoardMinY  = SCREEN_HEIGHT - step.floatValue;
	
	if (maxY > keyBoardMinY) {
		[UIView animateWithDuration:0.25f animations:^{
			self.view.frame = CGRectMake(0, -(maxY - keyBoardMinY), SCREEN_WIDTH, SCREEN_HEIGHT);
		}];
	}
	return nil;
}

- (id)KeyboardHideKeyboard:(id)args {
	
	[UIView animateWithDuration:0.25f animations:^{
		self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
	}];
	return nil;
}

@end
