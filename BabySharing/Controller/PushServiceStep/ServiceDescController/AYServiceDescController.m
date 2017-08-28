//
//  AYInputNapDescController.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceDescController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"

#define STATUS_BAR_HEIGHT           20
#define FAKE_BAR_HEIGHT             44
#define LIMITNUMB                   200

@implementation AYServiceDescController {
    UITextView *descTextView;
	UILabel *placeHolder;
	
    UILabel *countlabel;
    NSString *setedStr;
	UIView *tapView;
	
	BOOL isAlreadyEnable;
	BOOL isAlyetRemake;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSString *str = [dic objectForKey:kAYControllerChangeArgsKey];
		setedStr = str;
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools whiteColor];
	
	UILabel *titleLabel = [Tools creatUILabelWithText:@"描述" andTextColor:[Tools themeColor] andFontSize:620.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(80);
		make.left.equalTo(self.view).offset(20);
	}];
	
	[Tools creatCALayerWithFrame:CGRectMake(20, 115, SCREEN_WIDTH - 20 * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:self.view];
	
    descTextView = [[UITextView alloc]init];
    [self.view addSubview:descTextView];
    descTextView.font = [UIFont systemFontOfSize:14.f];
    descTextView.textColor = [Tools blackColor];
	descTextView.scrollEnabled = NO;
    descTextView.delegate = self;
    [descTextView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(84);
		make.top.equalTo(titleLabel.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 200));
		make.width.mas_equalTo(SCREEN_WIDTH - 40);
		make.height.mas_greaterThanOrEqualTo(20);
    }];
	
	placeHolder = [Tools creatUILabelWithText:@"描述服务内容、特点以及理念和目的等" andTextColor:[Tools garyColor] andFontSize:314.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[descTextView addSubview:placeHolder];
	[placeHolder mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(descTextView).offset(5);
		make.top.equalTo(descTextView).offset(8);
	}];
	
	if (setedStr && ![setedStr isEqualToString:@""]) {
		descTextView.text = setedStr;
		placeHolder.hidden  = YES;
	}
	
    countlabel = [Tools creatUILabelWithText:[NSString stringWithFormat:@"还可以输入%d个字符",LIMITNUMB - (int)setedStr.length] andTextColor:[Tools themeColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:0];
    [self.view addSubview:countlabel];
    [countlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descTextView.mas_bottom).offset(25);
        make.right.equalTo(descTextView).offset(-10);
    }];
	
	
	tapView = [[UIView alloc]init];
	[self.view addSubview:tapView];
	[tapView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
	UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere:)];
	[tapView addGestureRecognizer:tap];
	tapView.alpha = 0;
	
	UIView *statusView = [self.views objectForKey:@"FakeStatusBar"];
	UIView *navView = [self.views objectForKey:kAYFakeNavBarView];
	[self.view bringSubviewToFront:statusView];
	[self.view bringSubviewToFront:navView];
	
	[descTextView becomeFirstResponder];
}

- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {
	
	if ([descTextView isFirstResponder]) {
		[descTextView resignFirstResponder];
	}
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
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, FAKE_BAR_HEIGHT);
    
//    NSString *title = @"服务描述";
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
    UIImage* left = IMGRESOURCE(@"bar_left_theme");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
	UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools garyColor] andFontSize:16.f andBackgroundColor:nil];
	bar_right_btn.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
	
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

#pragma mark -- UITextDelegate
- (void)textViewDidChange:(UITextView *)textView {
	NSInteger count = textView.text.length;
	placeHolder.hidden = count != 0;
	
	if (!isAlreadyEnable) {
		UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil];
		kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
		isAlreadyEnable = YES;
	}
	
    if (count > LIMITNUMB) {
        descTextView.text = [textView.text substringToIndex:LIMITNUMB];
    }
    countlabel.text = [NSString stringWithFormat:@"还可以输入%ld个字符",(LIMITNUMB - count)>=0?(LIMITNUMB - count):0];
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
    [dic_info setValue:descTextView.text forKey:kAYServiceArgsDescription];
    [dic_info setValue:kAYServiceArgsDescription forKey:@"key"];
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    [descTextView resignFirstResponder];
    return nil;
}
#pragma mark -- Keyboard facade
- (id)KeyboardShowKeyboard:(id)args {
	tapView.alpha = 0.5;
//	if (!isAlyetRemake) {
//		isAlyetRemake = YES;
//	}
	NSNumber* step = [(NSDictionary*)args objectForKey:kAYNotifyKeyboardArgsHeightKey];
	[countlabel mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view).offset(- step.floatValue - 10);
		make.right.equalTo(self.view).offset(-20);
	}];
	return nil;
}

- (id)KeyboardHideKeyboard:(id)args {
	tapView.alpha = 0;
//	descTextView.userInteractionEnabled = YES;
//	[UIView animateWithDuration:0.25 animations:^{
//		
//	}];
	return nil;
}
@end
