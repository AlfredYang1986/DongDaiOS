//
//  AYLandingInputView.m
//  BabySharing
//
//  Created by Alfred Yang on 3/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLandingInputNameView.h"
#import "AYCommandDefines.h"
#import "AYControllerBase.h"
#import "AYResourceManager.h"
#import "AYControllerBase.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"

#define BASICMARGIN                         8

#define SNS_TOP_MARGIN                      130

#define AREA_CODE_WIDTH                     66
#define INPUT_TEXT_FIELD_HEIGHT             45.5
#define INPUT_MARGIN                        10.5 //32.5

#define TEXT_FIELD_LEFT_PADDING             10
#define LINE_MARGIN                         5
#define CODE_BTN_WIDTH                      80

#define LOGIN_BTN_TOP_MARGIN                60
#define LOGIN_BTN_HEIGHT                    37
#define LOGIN_BTN_BOTTOM_MARGIN             40

@implementation AYLandingInputNameView {
    UIButton * area_code_btn;
    UIButton * next_btn;
    UIButton * confirm_btn;
    
    NSTimer* timer;
    NSInteger seconds;
    
    /**/
    UIView  *inputView;
    UITextField *name_area;
	UIImageView *checkIcon;
	
	BOOL isLegalName;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	
	UILabel *tips = [Tools creatUILabelWithText:@"还有，您的姓名" andTextColor:[Tools themeColor] andFontSize:20.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self addSubview:tips];
	[tips mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self);
		make.left.equalTo(self);
	}];
	
    /* 姓名 */
    inputView = [[UIView alloc]init];
    [self addSubview:inputView];
	CGFloat inputBgHeight = 60;
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tips.mas_bottom).offset(15);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(inputBgHeight);
    }];
	[Tools creatCALayerWithFrame:CGRectMake(0, inputBgHeight - 0.5, SCREEN_WIDTH - 50, 0.5) andColor:[Tools themeColor] inSuperView:inputView];
	
    name_area = [[UITextField alloc]init];
    name_area.delegate = self;
    name_area.font = [UIFont boldSystemFontOfSize:20.f];
    name_area.textColor = [Tools themeColor];
    name_area.clearButtonMode = UITextFieldViewModeWhileEditing;
    name_area.placeholder = @"您的真实姓名或昵称";
    [inputView addSubview:name_area];
    [name_area mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(inputView);
        make.right.equalTo(inputView);
        make.centerY.equalTo(inputView);
        make.height.equalTo(@40);
    }];
	
	checkIcon = [[UIImageView alloc]init];
	checkIcon.image = IMGRESOURCE(@"checked_icon_iphone");
	checkIcon.contentMode = UIViewContentModeCenter;
	checkIcon.backgroundColor = [Tools whiteColor];
	[self addSubview:checkIcon];
	[checkIcon mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(inputView);
		make.top.equalTo(inputView);
		make.size.mas_equalTo(CGSizeMake(27, inputBgHeight - 1));
	}];
	checkIcon.hidden = YES;
	
	UIButton *nextBtn = [[UIButton alloc]init];
	[nextBtn setImage:IMGRESOURCE(@"loginstep_next_icon") forState:UIControlStateNormal];
	[self addSubview:nextBtn];
	[nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(inputView.mas_bottom).offset(70);
		make.right.equalTo(self);
		make.size.mas_equalTo(CGSizeMake(50, 50));
	}];
//	nextBtn.alpha = 0;
	[nextBtn addTarget:self action:@selector(didNextBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

- (void)didNextBtnClick {
	
	if (!isLegalName) {
		NSString *title = @"姓名昵称仅限中英文";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return;
	}
	
	id<AYCommand> cmd = [self.notifies objectForKey:@"rightBtnSelected"];
	[cmd performWithResult:nil];
}

#pragma mark -- handle
- (void)nameTextFieldChanged:(UITextField*)tf {
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if (![string isEqualToString:@""]) {
		
		NSString *tmp = [textField.text stringByAppendingString:string];
		
		NSString *regex = @"[a-zA-Z\u4e00-\u9fa5]+";
		NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
		isLegalName = [pred evaluateWithObject:tmp];
		checkIcon.hidden  = !isLegalName;
		
		if ([Tools bityWithStr:tmp] >= 32) {
			
			[name_area resignFirstResponder];
			NSString *title = @"4-32个字符(汉字／大写字母长度为2)\n*仅限中英文";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithAction)
			return NO;
		} else {
			return YES;
		}
	} else {
		return YES;
	}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    id<AYControllerBase> controller = DEFAULTCONTROLLER(@"InputName");
//    id<AYFacadeBase> f_alert = [controller.facades objectForKey:@"Alert"];
    id<AYFacadeBase> f_alert = DEFAULTFACADE(@"Alert");
    id<AYCommand> cmd_alert = [f_alert.commands objectForKey:@"HideAlert"];
    [cmd_alert performWithResult:nil];
}

#pragma mark -- view commands
- (id)hideKeyboard {
    if ([name_area isFirstResponder]) {
        [name_area resignFirstResponder];
    }
    return nil;
}

-(id)queryInputName:(NSString*)args{
    return name_area.text;
}

@end
