//
//  AYPushServiceMainController.m
//  BabySharing
//
//  Created by Alfred Yang on 15/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYPushServiceMainController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"

#import "AYMainServInfoView.h"

#define STATUS_BAR_HEIGHT           20
#define FAKE_BAR_HEIGHT             44
#define kTOPHEIGHT					166
#define kBOTTOMHEIGHT				85
#define kBETWEENMARGIN				16

@implementation AYPushServiceMainController {
	NSMutableDictionary *push_service_info;
	
	AYMainServInfoView *basicSubView;
	AYMainServInfoView *locationSubView;
	AYMainServInfoView *capacitySubView;
	AYMainServInfoView *TMsSubView;
	AYMainServInfoView *noticeSubView;
	
	AYMainServInfoView *priceSubView;
	UIButton *pushBtn;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		push_service_info = [dic objectForKey:kAYControllerChangeArgsKey];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		id back_args = [dic objectForKey:kAYControllerChangeArgsKey];
		if ([back_args isKindOfClass:[NSDictionary class]]) {
			NSString *note_key = [back_args objectForKey:@"key"];
			if ([note_key isEqualToString:@"part_basic"]) {
				basicSubView.isReady = [[back_args objectForKey:kAYServiceArgsImages] count] != 0 && [[back_args objectForKey:kAYServiceArgsDescription] length] != 0 && [[back_args objectForKey:kAYServiceArgsCharact] count] != 0;
			} else if ([note_key isEqualToString:@"part_capacity"]) {
				capacitySubView.isReady = [back_args objectForKey:kAYServiceArgsAgeBoundary] && [back_args objectForKey:kAYServiceArgsCapacity] && [back_args objectForKey:kAYServiceArgsServantNumb];
			}
			for (NSString *key in [back_args allKeys]) {
				if ([key isEqualToString:kAYServiceArgsImages] || [key isEqualToString:kAYServiceArgsDescription] || [key isEqualToString:kAYServiceArgsCharact]) {
					[push_service_info setValue:[back_args objectForKey:key] forKey:key];
				}
			}
			[self isAllArgsReady];
		}
	}
}

- (void)isAllArgsReady {
	pushBtn.enabled = basicSubView.isReady && locationSubView.isReady && capacitySubView.isReady && TMsSubView.isReady && noticeSubView.isReady;
}


#pragma mark -- life cycle
- (void)viewDidLoad {
	[super viewDidLoad];
	
	CGFloat margin = 20.f;
	
	UIView *sloganShadow = [[UIView alloc] initWithFrame:CGRectMake(margin, 80, SCREEN_WIDTH - margin*2, 86)];
	sloganShadow.layer.cornerRadius = 4.f;
	sloganShadow.layer.shadowColor = [Tools garyColor].CGColor;
	sloganShadow.layer.shadowRadius = 4.f;
	sloganShadow.layer.shadowOpacity = 0.5f;
	sloganShadow.layer.shadowOffset = CGSizeMake(0, 0);
	[self.view addSubview:sloganShadow];
	sloganShadow.backgroundColor = [Tools whiteColor];
	
	UIView *sloganView = [[UIView alloc] initWithFrame:sloganShadow.frame];
	[self.view addSubview:sloganView];
	[Tools setViewBorder:sloganView withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools whiteColor]];
	
	UILabel *titleLabel = [Tools creatUILabelWithText:@"Servant' Servcie" andTextColor:[Tools blackColor] andFontSize:617 andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[sloganView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(sloganView).offset(kBETWEENMARGIN);
		make.left.equalTo(sloganView).offset(kBETWEENMARGIN);
	}];
	
	UILabel *sloganLabel = [Tools creatUILabelWithText:@"Servant' Servcie" andTextColor:[Tools blackColor] andFontSize:313 andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[sloganView addSubview:sloganLabel];
	[sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(sloganView).offset(-kBETWEENMARGIN);
		make.left.equalTo(sloganView).offset(kBETWEENMARGIN);
	}];
	
	NSDictionary *profile;
	CURRENPROFILE(profile);
	NSString *name = [profile objectForKey:kAYProfileArgsScreenName];
	
	NSDictionary *info_categ = [push_service_info objectForKey:kAYServiceArgsCategoryInfo];
	NSString *cat = [info_categ objectForKey:kAYServiceArgsCat];
	NSString *titleStr;
	if ([cat isEqualToString:kAYStringNursery]) {
		NSString *cat_secondary = [info_categ objectForKey:kAYServiceArgsCatSecondary];
		titleStr = [NSString stringWithFormat:@"%@的%@",name, cat_secondary];
	} else if([cat isEqualToString:kAYStringCourse]){
		NSString *cat_thirdly = [info_categ objectForKey:kAYServiceArgsCourseCoustom];
		if (cat_thirdly.length == 0) {
			cat_thirdly = [info_categ objectForKey:kAYServiceArgsCatThirdly];
		}
		titleStr = [NSString stringWithFormat:@"%@的%@%@",name, cat_thirdly, cat];
	}
	titleLabel.text = titleStr;
	NSString *sloganStr = [push_service_info objectForKey:kAYServiceArgsTitle];
	sloganLabel.text = sloganStr;
	
	/****************************************************************/
	CGFloat subOrigX = kTOPHEIGHT + kBETWEENMARGIN;
	CGFloat remainHeight = SCREEN_HEIGHT - kTOPHEIGHT - kBOTTOMHEIGHT;
	CGFloat leftHeight = (remainHeight - kBETWEENMARGIN * 3) *0.5;
	CGFloat rightHeight = (remainHeight - kBETWEENMARGIN * 4) / 3;
	CGFloat sameWidth = (SCREEN_WIDTH - margin*2 - kBETWEENMARGIN) * 0.5;
	CGFloat rightX = margin + sameWidth + kBETWEENMARGIN;
	
	basicSubView = [[AYMainServInfoView alloc] initWithFrame:CGRectMake(margin, subOrigX, sameWidth, leftHeight) andTitle:@"服务基本信息" andTapBlock:^{
		
		[self pushDestControllerWithName:@"SetBasicInfo"];
	}];
	[self.view addSubview:basicSubView];
	
	locationSubView = [[AYMainServInfoView alloc] initWithFrame:CGRectMake(margin, subOrigX+kBETWEENMARGIN+leftHeight, sameWidth, leftHeight) andTitle:@"场地" andTapBlock:^{
		[self pushDestControllerWithName:@"SetLocationInfo"];
	}];
	[self.view addSubview:locationSubView];
	
	capacitySubView = [[AYMainServInfoView alloc] initWithFrame:CGRectMake(rightX, subOrigX, sameWidth, rightHeight) andTitle:@"师生设定" andTapBlock:^{
		
		[self pushDestControllerWithName:@"SetServiceCapacity"];
	}];
	[self.view addSubview:capacitySubView];
	
	TMsSubView = [[AYMainServInfoView alloc] initWithFrame:CGRectMake(rightX, subOrigX+rightHeight+kBETWEENMARGIN, sameWidth, rightHeight) andTitle:@"服务时间" andTapBlock:^{
	}];
	[self.view addSubview:TMsSubView];
	
	noticeSubView = [[AYMainServInfoView alloc] initWithFrame:CGRectMake(rightX, subOrigX+(rightHeight+kBETWEENMARGIN)*2, sameWidth, rightHeight) andTitle:@"服务守则" andTapBlock:^{
	}];
	[self.view addSubview:noticeSubView];
	
	
	/****************************************************************/
	
	
	UIView *partBtmView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kBOTTOMHEIGHT, SCREEN_WIDTH, kBOTTOMHEIGHT)];
	[self.view addSubview:partBtmView];
	[Tools creatCALayerWithFrame:CGRectMake(margin, 0, SCREEN_WIDTH - margin*2, 0.5) andColor:[Tools garyLineColor] inSuperView:partBtmView];
	
	CGFloat priceViewWidth = (SCREEN_WIDTH - 40 - kBETWEENMARGIN) * 0.5;
	priceSubView = [[AYMainServInfoView alloc] initWithFrame:CGRectMake(margin, kBETWEENMARGIN, priceViewWidth, 49) andTitle:@"Price" andTapBlock:^{
	}];
	[partBtmView addSubview:priceSubView];
	[priceSubView hideCheckSign];
	
	pushBtn = [[UIButton alloc] init]; //362  142
//	UIButton *pushBtn = [Tools creatUIButtonWithTitle:@"PUSH" andTitleColor:[Tools whiteColor] andFontSize:617 andBackgroundColor:nil]; //362  142
	[pushBtn setImage:IMGRESOURCE(@"icon_btn_pushservice") forState:UIControlStateNormal];
	[pushBtn setImage:IMGRESOURCE(@"icon_btn_pushservice_disable") forState:UIControlStateDisabled];
	[self.view addSubview:pushBtn];
	[pushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(priceSubView).offset(-5);
		make.right.equalTo(self.view).offset(-10);
		make.size.mas_equalTo(CGSizeMake(181, 71));
	}];
	pushBtn.enabled = NO;
	
}

- (void)pushDestControllerWithName:(NSString*)dest {
	
	id<AYCommand> des = DEFAULTCONTROLLER(dest);
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic_push setValue:push_service_info forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
	view.frame = CGRectMake(0, 20, SCREEN_WIDTH, FAKE_BAR_HEIGHT);
	
	UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"预览" andTitleColor:[Tools garyColor] andFontSize:16.f andBackgroundColor:nil];
	bar_right_btn.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

#pragma mark -- UITextDelegate


#pragma mark -- actions
- (void)didCourseSignLabelTap {
	
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
	
//	[push_service_info setValue:inputTitleTextView.text forKey:kAYServiceArgsTitle];
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	[dic_push setValue:push_service_info forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
	
	return nil;
}

@end
