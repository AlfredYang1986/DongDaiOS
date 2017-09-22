//
//  AYSetServiceNoticeController.m
//  BabySharing
//
//  Created by Alfred Yang on 5/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetServiceNoticeController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYInsetLabel.h"
#import "AYServiceArgsDefines.h"

#define LIMITNUMB                   228
#define kTableFrameY                218

@implementation AYSetServiceNoticeController{
    
    NSString *setedNoticeStr;
    BOOL isAllowLeave;
    
    UISwitch *isALeaveSwitch;
	UISwitch *isHealth;
	
	UILabel *placeHold;
	UITextView *noticeTextView;
	BOOL isAlreadyEnable;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary *notice_args = [dic objectForKey:kAYControllerChangeArgsKey];
        setedNoticeStr = [notice_args objectForKey:kAYServiceArgsNotice];
        isAllowLeave = ((NSNumber*)[notice_args objectForKey:kAYServiceArgsAllowLeave]).boolValue;
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UILabel *titleLabel = [Tools creatUILabelWithText:@"服务守则" andTextColor:[Tools themeColor] andFontSize:630.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(80);
		make.left.equalTo(self.view).offset(20);
	}];
	
	UILabel *h1 = [Tools creatUILabelWithText:@"需要家长陪同" andTextColor:[Tools blackColor] andFontSize:616.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self.view addSubview:h1];
	[h1 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(titleLabel.mas_bottom).offset(30);
		make.left.equalTo(titleLabel);
	}];
	
	isALeaveSwitch = [[UISwitch alloc]init];
	isALeaveSwitch.onTintColor = [Tools themeColor];
	//    isALeaveSwitch.transform= CGAffineTransformMakeScale(0.69, 0.69);
	[self.view addSubview:isALeaveSwitch];
	[isALeaveSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(h1);
		make.right.equalTo(self.view).offset(-20);
		make.size.mas_equalTo(CGSizeMake(49, 31));
	}];
	isALeaveSwitch.on = isAllowLeave;
	
	UILabel *h2 = [Tools creatUILabelWithText:@"需要孩子健康证明" andTextColor:[Tools blackColor] andFontSize:616.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self.view addSubview:h2];
	[h2 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(h1.mas_bottom).offset(30);
		make.left.equalTo(titleLabel);
	}];
	
	isHealth = [[UISwitch alloc]init];
	isHealth.onTintColor = [Tools themeColor];
	//    isHealth.transform= CGAffineTransformMakeScale(0.69, 0.69);
	[self.view addSubview:isHealth];
	[isHealth mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(h2);
		make.right.equalTo(self.view).offset(-20);
		make.size.mas_equalTo(CGSizeMake(49, 31));
	}];
	isHealth.on = isAllowLeave;
	
	UIView *lineView = [[UIView alloc] init];
	lineView.backgroundColor = [Tools garyLineColor];
	[self.view addSubview:lineView];
	[lineView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(h2.mas_bottom).offset(25);
		make.centerX.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 0.5));
	}];
	
	UILabel *otherLabel = [Tools creatUILabelWithText:@"更多守则" andTextColor:[Tools blackColor] andFontSize:616.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:otherLabel];
    [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(lineView.mas_bottom).offset(20);
		make.left.equalTo(titleLabel);
    }];
	
	noticeTextView = [[UITextView alloc] init];
	noticeTextView.font = [UIFont systemFontOfSize:15];
	noticeTextView.textColor = [Tools blackColor];
	noticeTextView.scrollEnabled = NO;
	[noticeTextView setContentInset:UIEdgeInsetsMake(-5, -3, -5, -3)];
	noticeTextView.delegate = self;
	[self.view addSubview:noticeTextView];
	[noticeTextView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(otherLabel.mas_bottom).offset(20);
		make.left.equalTo(titleLabel);
		make.right.equalTo(self.view).offset(-20);
	}];
	
	placeHold = [Tools creatUILabelWithText:@"请输入" andTextColor:[Tools garyColor] andFontSize:315 andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self.view addSubview:placeHold];
	[placeHold mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(noticeTextView).offset(2);
		make.top.equalTo(noticeTextView).offset(2);
	}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	
	UIImage* left = IMGRESOURCE(@"bar_left_theme");
	kAYViewsSendMessage(@"FakeNavBar", @"setLeftBtnImg:", &left)
	
	UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools garyColor] andFontSize:616.f andBackgroundColor:nil];
	bar_right_btn.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, kTableFrameY, SCREEN_WIDTH, SCREEN_HEIGHT - kTableFrameY);
    return nil;
}

- (void)textViewDidChange:(UITextView *)textView {
	placeHold.hidden = textView.text.length != 0;
	[self setNavRightBtnEnableStatus];
}

#pragma mark -- actions
- (void)setNavRightBtnEnableStatus {
	if (!isAlreadyEnable) {
		UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:616.f andBackgroundColor:nil];
		kAYViewsSendMessage(@"FakeNavBar", kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
		isAlreadyEnable = YES;
	}
}
- (void)didOtherNoticeTap {
    
    id<AYCommand> dest = DEFAULTCONTROLLER(@"OtherNoticeText");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:setedNoticeStr forKey:kAYControllerChangeArgsKey];
//    [dic_push setValue:[napBabyArgsInfo copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
    [dic_info setValue:[NSNumber numberWithBool:isALeaveSwitch.on] forKey:kAYServiceArgsAllowLeave];
    [dic_info setValue:setedNoticeStr forKey:kAYServiceArgsNotice];
    [dic_info setValue:kAYServiceArgsNotice forKey:@"key"];
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    //整合数据
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
	[dic setValue:@1 forKey:@"part_notice"];
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    return nil;
}

@end
