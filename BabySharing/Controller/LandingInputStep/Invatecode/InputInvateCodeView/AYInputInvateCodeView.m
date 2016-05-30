//
//  AYInputInvateCodeView.m
//  BabySharing
//
//  Created by Alfred Yang on 30/5/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYInputInvateCodeView.h"

#import "AYLandingInputNoView.h"
#import "AYCommandDefines.h"
#import "OBShapedButton.h"
#import "AYResourceManager.h"
#import "AYControllerBase.h"
#import "AYFacadeBase.h"
#import "Tools.h"

@implementation AYInputInvateCodeView {
    UIButton* clear_btn;
    
    /**/
    UILabel *input_tips;
    UIView* areaView;
    UIView* inputView;
    UITextField * code_area;
    UILabel* area_country_input;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
    /* 邀请码输入 */
    inputView = [[UIView alloc]init];
    [self addSubview:inputView];
    [inputView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.9]];
    inputView.layer.cornerRadius = 6.f;
    inputView.clipsToBounds = YES;
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *invateCode = [[UILabel alloc]init];
    invateCode.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.f];
    invateCode.text = @"输入邀请码";
    invateCode.font = [UIFont systemFontOfSize:14.f];
    invateCode.textColor = [UIColor colorWithWhite:0.15f alpha:1.f];
    invateCode.textAlignment = NSTextAlignmentCenter;
    [inputView addSubview:invateCode];
    [invateCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView);
        make.left.equalTo(inputView);
        make.size.mas_equalTo(CGSizeMake(90, 40));
    }];
    
    code_area = [[UITextField alloc]init];
    code_area.backgroundColor = [UIColor clearColor];
    code_area.font = [UIFont systemFontOfSize:14.f];
    code_area.textColor = [Tools colorWithRED:74 GREEN:74 BLUE:74 ALPHA:1.f];
    code_area.clearButtonMode = UITextFieldViewModeWhileEditing;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [inputView addSubview:code_area];
    [code_area mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inputView);
        make.top.equalTo(inputView);
        make.left.equalTo(invateCode.mas_right).offset(10);
        make.height.equalTo(inputView);
    }];
    
    clear_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, code_area.frame.size.height)];
    clear_btn.center = CGPointMake(code_area.frame.size.width - 25 / 2, code_area.frame.size.height / 2);
    [code_area addSubview:clear_btn];
    
    input_tips = [[UILabel alloc]init];
    input_tips.text = @"如何获取邀请码";
    input_tips.font = [UIFont systemFontOfSize:14.f];
    input_tips.textColor = [Tools colorWithRED:242 GREEN:242 BLUE:242 ALPHA:1.f];
    input_tips.textAlignment = NSTextAlignmentLeft;
    [self addSubview:input_tips];
    [input_tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView.mas_bottom).offset(18);
        make.left.equalTo(self);
    }];
    input_tips.userInteractionEnabled = YES;
    [input_tips addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getCoder)]];
    
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

#pragma mark -- handle
- (void)phoneTextFieldChanged:(UITextField*)tf {
    if (![code_area.text isEqualToString:@""]) {
//        next_btn.enabled = YES;
    } else {
//        next_btn.enabled = NO;
    }
    
    if (![code_area.text isEqualToString:@""]) {
        clear_btn.hidden = NO;
    } else {
        clear_btn.hidden = YES;
    }
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (textField == confirm_area && confirm_area.text.length >= 4 && ![string isEqualToString:@""]) return NO;
//    else
        return YES;
}

- (void)confirmBtnSelected:(UIButton*)sender {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:code_area.text forKey:@"phoneNo"];
    [_controller performForView:self andFacade:@"LandingRemote" andMessage:@"LandingReqConfirmCode" andArgs:[dic copy]];
}

-(void)getCoder{
    id<AYCommand> cmd = [self.notifies objectForKey:@"invateCode"];
    [cmd performWithResult:nil];
}


#pragma mark -- view commands
- (id)hideKeyboard {
    if ([code_area isFirstResponder]) {
        [code_area resignFirstResponder];
    }
    return nil;
}

-(id)queryInvateCode:(NSString*)args{
    return code_area.text;;
}
@end
