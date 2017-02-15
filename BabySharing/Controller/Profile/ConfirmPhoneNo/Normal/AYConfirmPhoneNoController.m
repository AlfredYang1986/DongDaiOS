//
//  AYConfirmPhoneNoController.m
//  BabySharing
//
//  Created by Alfred Yang on 14/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYConfirmPhoneNoController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"
#import "AYModel.h"

#define TEXT_FIELD_LEFT_PADDING             10
#define TimeZore                            5
#define kPhoneNoLimit                       13

@interface AYConfirmPhoneNoController () //<UITextFieldDelegate>

@end

@implementation AYConfirmPhoneNoController {
    NSString* reg_token;
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
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tap];
    
    UILabel *title = [Tools creatUILabelWithText:@"首先,我们需要通过手机验证" andTextColor:[Tools blackColor] andFontSize:-20.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(20);
    }];
    
    UILabel *descLabel = [Tools creatUILabelWithText:@"手机验证可以让您及时和家长沟通" andTextColor:[Tools blackColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    descLabel.numberOfLines = 0;
    [self.view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(8);
        make.left.equalTo(title);
    }];
   
    UIView* input_view = [self.views objectForKey:@"PhoneCheckInput"];
    input_view.backgroundColor = [UIColor clearColor];
    [input_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLabel.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(input_view.frame.size.height);
    }];
	
	UIButton *nextBtn = [[UIButton alloc]init];
	[nextBtn setImage:IMGRESOURCE(@"loginstep_next_icon") forState:UIControlStateNormal];
	[self.view addSubview:nextBtn];
	[nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(input_view.mas_bottom).offset(30);
		make.right.equalTo(input_view);
		make.size.mas_equalTo(CGSizeMake(50, 50));
	}];
	[nextBtn addTarget:self action:@selector(rightBtnSelected) forControlEvents:UIControlEventTouchUpInside];
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

- (id)PhoneCheckInputLayout:(UIView*)view {
    return nil;
}

#pragma mark -- actions
- (void)tapGesture:(UITapGestureRecognizer*)gesture {
    kAYViewsSendMessage(@"PhoneCheckInput", @"resignFocus", nil)
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
    
    //注销响应者防止键盘挡住底部提示
    kAYViewsSendMessage(@"PhoneCheckInput", @"resignFocus", nil)
    
    NSString* tmp = @"";
    {
        id<AYViewBase> view = [self.views objectForKey:@"PhoneCheckInput"];
        id<AYCommand> cmd = [view.commands objectForKey:@"queryPhoneInput:"];
        [cmd performWithResult:&tmp];
    }
    
    NSString* code = @"";
    {
        id<AYViewBase> view = [self.views objectForKey:@"PhoneCheckInput"];
        id<AYCommand> cmd = [view.commands objectForKey:@"queryCodeInput:"];
        [cmd performWithResult:&code];
    }
    
    NSDictionary* user = nil;
    CURRENUSER(user);
    id<AYFacadeBase> f = [self.facades objectForKey:@"AuthRemote"];
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"CheckCode"];
    
    NSMutableDictionary *dic_check = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic_check setValue:[user objectForKey:@"user_id"] forKey:@"user_id"];
    [dic_check setValue:reg_token forKey:@"reg_token"];
    [dic_check setValue:code forKey:@"code"];
    [dic_check setValue:[Tools getDeviceUUID] forKey:@"uuid"];
    tmp = [tmp stringByReplacingOccurrencesOfString:@" " withString:@""];
    [dic_check setValue:tmp forKey:@"phoneNo"];
    
    [cmd performWithResult:[dic_check copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            
            {
                id<AYFacadeBase> facade = LOGINMODEL;
                id<AYCommand> cmd = [facade.commands objectForKey:@"UpdateLocalCurrentUserProfile"];
                
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                [dic setValue:tmp forKey:@"contact_no"];
                [dic setValue:[NSNumber numberWithInt:1] forKey:@"has_phone"];
                
                [cmd performWithResult:&dic];
            }
            
            AYViewController* des = DEFAULTCONTROLLER(@"ConfirmRealName");
            NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
            [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
            [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
            [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
            [dic_push setValue:[NSNumber numberWithInt:0] forKey:kAYControllerChangeArgsKey];
            
            id<AYCommand> cmd = PUSH;
            [cmd performWithResult:&dic_push];
            
        } else {
            NSString *title = @"验证码输入错误\n请检查验证码并重试";
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        }
    }];
    return nil;
}

#pragma mark -- actions
- (id)requeryForCode {
    
    NSString* tmp = @"";
    {
        id<AYViewBase> view = [self.views objectForKey:@"PhoneCheckInput"];
        id<AYCommand> cmd = [view.commands objectForKey:@"queryPhoneInput:"];
        [cmd performWithResult:&tmp];
    }
    
    id<AYFacadeBase> f = [self.facades objectForKey:@"AuthRemote"];
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"RequireCode"];
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]initWithCapacity:1];
    
    tmp = [tmp stringByReplacingOccurrencesOfString:@" " withString:@""];
    [dic_push setValue:tmp forKey:@"phoneNo"];
    
    [cmd performWithResult:[dic_push copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            reg_token = [result objectForKey:@"reg_token"];

            id<AYViewBase> view = [self.views objectForKey:@"PhoneCheckInput"];
            
            {
                id<AYCommand> cmd = [view.commands objectForKey:@"startTimer"];
                [cmd performWithResult:nil];
            }
            
            {
                id<AYCommand> cmd = [view.commands objectForKey:@"setCodeBtnTitle"];
                [cmd performWithResult:nil];
            }
            
			NSString *title = @"正在为您发送动态密码，请稍等...";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			
        } else {
            NSString *title = @"请改善网络环境并重新获取";
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        }
    }];
    
    {
        id<AYViewBase> view = [self.views objectForKey:@"PhoneCheckInput"];
        id<AYCommand> cmd = [view.commands objectForKey:@"resetCodeInput"];
        [cmd performWithResult:nil];
    }

    return nil;
}

#pragma mark -- Keyboard facade
- (id)KeyboardShowKeyboard:(id)args {
	
	NSNumber* step = [(NSDictionary*)args objectForKey:kAYNotifyKeyboardArgsHeightKey];
	UIView *inputView = [self.views objectForKey:@"PhoneCheckInput"];
	CGFloat maxY = CGRectGetMaxY(inputView.frame);
	CGFloat keyBoardMinY  = SCREEN_HEIGHT - step.floatValue;
	
	if (maxY > keyBoardMinY) {
		[UIView animateWithDuration:0.25f animations:^{
			self.view.frame = CGRectMake(0, -(maxY - keyBoardMinY) - 5, SCREEN_WIDTH, SCREEN_HEIGHT);
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
