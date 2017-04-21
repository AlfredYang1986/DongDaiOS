//
//  AYPhoneCheckInputView.m
//  BabySharing
//
//  Created by BM on 29/09/2016.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPhoneCheckInputView.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "PhotoTagEnumDefines.h"
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
#define TimeZore                            60
#define kPhoneNoLimit                       13

@interface AYPhoneCheckInputView () <UITextFieldDelegate>

@end

@implementation AYPhoneCheckInputView {
    NSString* reg_token;
    
    NSTimer* timer;
    NSInteger seconds;
    
    UITextField *coder_area;
    UITextField *inputPhoneNo;
	UIImageView *checkIcon;
	
    UIButton *getCodeBtn;
	UILabel *count_timer;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
	
	self.bounds = CGRectMake(0, 0, 0, 140);
    self.backgroundColor = [UIColor clearColor];
    
	/* 电话号码 */
	UIView *inputPhoneNoView = [[UIView alloc]init];
	[self addSubview:inputPhoneNoView];
	CGFloat phoneBgHeight = 60;
	[inputPhoneNoView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self);
		make.left.equalTo(self);
		make.right.equalTo(self);
		make.height.mas_equalTo(phoneBgHeight);
	}];
	[Tools creatCALayerWithFrame:CGRectMake(0, phoneBgHeight - 0.5, SCREEN_WIDTH - 40, 0.5) andColor:[Tools themeColor] inSuperView:inputPhoneNoView];
	
	UILabel *phoneNo = [Tools creatUILabelWithText:@"+ 86" andTextColor:[Tools whiteColor] andFontSize:615.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	[Tools setViewBorder:phoneNo withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools themeColor]];
	[inputPhoneNoView addSubview:phoneNo];
	[phoneNo mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(inputPhoneNoView);
		make.left.equalTo(inputPhoneNoView);
		make.size.mas_equalTo(CGSizeMake(60, 35));
	}];
	
	checkIcon = [[UIImageView alloc]init];
	checkIcon.image = IMGRESOURCE(@"checked_icon_iphone");
	[inputPhoneNoView addSubview:checkIcon];
	[checkIcon mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(inputPhoneNoView);
		make.centerY.equalTo(inputPhoneNoView);
		make.size.mas_equalTo(CGSizeMake(18, 14));
	}];
	checkIcon.hidden = YES;
	
	inputPhoneNo = [[UITextField alloc]init];
	inputPhoneNo.delegate = self;
	inputPhoneNo.backgroundColor = [UIColor clearColor];
	inputPhoneNo.font = [UIFont boldSystemFontOfSize:18.f];
	inputPhoneNo.textColor = [Tools themeColor];
	inputPhoneNo.keyboardType = UIKeyboardTypeNumberPad;
	//    inputPhoneNo.clearButtonMode = UITextFieldViewModeWhileEditing;
	inputPhoneNo.placeholder = @"手机号码";
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:inputPhoneNo];
	[inputPhoneNoView addSubview:inputPhoneNo];
	[inputPhoneNo mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(phoneNo.mas_right).offset(15);
		make.right.equalTo(checkIcon.mas_left).offset(-10);
		make.centerY.equalTo(inputPhoneNoView);
		make.height.equalTo(@34);
	}];
	
	/* 验证码 */
	UIView *inputCodeView = [[UIView alloc]init];
	[self addSubview:inputCodeView];
	[inputCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(inputPhoneNoView.mas_bottom).offset(15);
		make.left.equalTo(self);
		make.width.equalTo(self);
		make.height.mas_equalTo(phoneBgHeight);
	}];
	[Tools creatCALayerWithFrame:CGRectMake(0, phoneBgHeight - 0.5, SCREEN_WIDTH - 40, 0.5) andColor:[Tools themeColor] inSuperView:inputCodeView];
	
	coder_area = [[UITextField alloc]init];
	coder_area.backgroundColor = [UIColor clearColor];
	coder_area.font = [UIFont boldSystemFontOfSize:18.f];
	coder_area.textColor = [Tools themeColor];
	coder_area.keyboardType = UIKeyboardTypeNumberPad;
	coder_area.delegate = self;
	coder_area.placeholder = @"动态密码";
	[inputCodeView addSubview:coder_area];
	[coder_area mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(inputCodeView).offset(10);
		make.right.equalTo(inputCodeView).offset(-150);
		make.centerY.equalTo(inputCodeView);
		make.height.equalTo(inputCodeView);
	}];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:coder_area];
	
	/* 重新获取coder */
	getCodeBtn = [[UIButton alloc]init];
	[getCodeBtn setTitle:@"获取动态密码" forState:UIControlStateNormal];
	[getCodeBtn setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
	[getCodeBtn setTitleColor:[Tools garyColor] forState:UIControlStateDisabled];
	getCodeBtn.enabled = NO;
	getCodeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
	[getCodeBtn addTarget:self action:@selector(getcodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
	[inputCodeView addSubview:getCodeBtn];
	[getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self);
		make.centerY.equalTo(inputCodeView);
		make.size.mas_equalTo(CGSizeMake(110, 42));
	}];
	
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                             target: self
                                           selector: @selector(timerRun:)
                                           userInfo: nil
                                            repeats: YES];
    [timer setFireDate:[NSDate distantFuture]];
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

#pragma mark -- messages
- (void)selfClicked {
    @throw [[NSException alloc]initWithName:@"error" reason:@"cannot call base view" userInfo:nil];
}

#pragma mark -- ################
- (void)textFieldTextDidChange:(NSNotification*)tf {
    if (tf.object == coder_area ) {
        if ( coder_area.text.length == 4) {
			[self resignFocus];
        } else {
            
        }
    }
    else if (tf.object == inputPhoneNo) {
        if (inputPhoneNo.text.length >= kPhoneNoLimit) {
            if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1[3,4,5,7,8]\\d{1} \\d{4} \\d{4}$"] evaluateWithObject:inputPhoneNo.text]) {
                
                [inputPhoneNo resignFirstResponder];
                NSString *title = @"您输入了错误的电话号码";
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithAction)
                return;
            } else
				checkIcon.hidden = NO;
			
            if (seconds == TimeZore || seconds == 0) {
                getCodeBtn.enabled = YES;
            }
		} else {
			getCodeBtn.enabled = NO;
			checkIcon.hidden = YES;
		}
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == inputPhoneNo) {
        if ( inputPhoneNo.text.length >= kPhoneNoLimit && ![string isEqualToString:@""]){
            return NO;
        } else {
            NSString *tmp = inputPhoneNo.text;
            if ((tmp.length == 3 || tmp.length == 8) && ![string isEqualToString:@""]) {
                tmp = [tmp stringByAppendingString:@" "];
                inputPhoneNo.text = tmp;
            }
            return YES;
        }
    } else {
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    AYHideBtmAlertView
}

- (void)getcodeBtnClick {
    
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1[3,4,5,7,8]\\d{1} \\d{4} \\d{4}$"] evaluateWithObject:inputPhoneNo.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入了错误的电话号码" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self resignFocus];
    id<AYCommand> cmd = [self.notifies objectForKey:@"requeryForCode"];
    [cmd performWithResult:nil];
}

#pragma mark -- timer handle
- (void)timerRun:(NSTimer*)sender {
    seconds--;
    if (seconds > 0) {
        [getCodeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)seconds] forState:UIControlStateNormal];
        
    } else {
        [timer setFireDate:[NSDate distantFuture]];
        [getCodeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [getCodeBtn setTitle:@"重获动态密码" forState:UIControlStateNormal];
        if (inputPhoneNo.text.length >= kPhoneNoLimit) {
            getCodeBtn.enabled = YES;
			checkIcon.hidden = NO;
        }
    }
}

#pragma mark -- actions
- (id)invalidateTimer {
    [timer invalidate];
    return nil;
}

- (id)resignFocus {
    
    if ([inputPhoneNo isFirstResponder]) {
        [inputPhoneNo resignFirstResponder];
    }
    if ([coder_area isFirstResponder]) {
        [coder_area resignFirstResponder];
    }
    
    return nil;
}

- (id)queryPhoneInput:(id)args {
    return inputPhoneNo.text;
}

- (id)queryCodeInput:(id)args {
    return coder_area.text;
}

- (id)setCodeBtnTitle {
    [getCodeBtn setTitle:[NSString stringWithFormat:@"%lds",(long)seconds] forState:UIControlStateNormal];
    [getCodeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 65, 0, 0)];
    return nil;
}

- (id)startTimer {
    getCodeBtn.enabled = NO;
    seconds = TimeZore;
    [timer setFireDate:[NSDate distantPast]];
    return nil;
}

- (id)endTimer {
    [timer setFireDate:[NSDate distantFuture]];
    return nil;
}

- (id)resetCodeInput {
    coder_area.text = @"";
    return nil;
}
@end
