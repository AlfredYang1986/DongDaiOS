//
//  AYSetServicePriceController.m
//  BabySharing
//
//  Created by Alfred Yang on 10/10/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSetServicePriceController.h"

#import "AYServicePriceCatBtn.h"
#import "AYShadowRadiusView.h"
#import "AYSetPriceInputView.h"

#define kInputGroupHeight			80

@implementation AYSetServicePriceController {
	
	NSMutableDictionary *push_service_info;
	
	AYServicePriceCatBtn *handleBtn;
	NSMutableArray *priceCatBtnArr;
	NSMutableArray *radiusViewArr;
	NSMutableArray *inputViewArr;
	
	AYSetPriceInputView *timesPriceInput;
	AYSetPriceInputView *stagePriceInput;
	AYSetPriceInputView *timesCountInput;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		push_service_info = [dic objectForKey:kAYControllerChangeArgsKey];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.clipsToBounds = YES;
	
	CGFloat marginScreen = 40.f;
	UILabel *titleLabel = [Tools creatUILabelWithText:@"价格设定" andTextColor:[Tools blackColor] andFontSize:630.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	titleLabel.numberOfLines = 0;
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view).offset(marginScreen);
		make.top.equalTo(self.view).offset(80);
	}];
	
	priceCatBtnArr = [NSMutableArray array];
	radiusViewArr = [NSMutableArray array];
	
	CGFloat segWidth = SCREEN_WIDTH - marginScreen*2;
	int itemCount = 0;
	NSArray *itemTitles;
	NSArray *itemTips;
	NSString *catStr = [[push_service_info objectForKey:kAYServiceArgsCategoryInfo] objectForKey:kAYServiceArgsCat];
	if ([catStr isEqualToString:kAYStringCourse]) {
		itemCount = 2;
		itemTitles = @[@"单次", @"学期"];
		itemTips = @[@"次", @"学期"];
		CGFloat itemBtnWith = segWidth / itemCount;
		
		for (int i = 0; i < itemCount; ++i) {
			
			AYServicePriceCatBtn *btn = [[AYServicePriceCatBtn alloc] initWithFrame:CGRectMake(marginScreen+itemBtnWith*i, SCREEN_HEIGHT*155/667, itemBtnWith, 40) andTitle:[itemTitles objectAtIndex:i]];
			btn.tag = i;
			[self.view addSubview:btn];
			btn.selected = i == 0;
			[btn addTarget:self action:@selector(didCatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
			[priceCatBtnArr addObject:btn];
			
			UIView *radiusBG= [[UIView alloc] init];
			[self.view addSubview:radiusBG];
			[radiusBG mas_makeConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self.view).offset(i==0?0:SCREEN_WIDTH);
				make.width.mas_equalTo(segWidth);
				make.top.equalTo(titleLabel.mas_bottom).offset(95);
				make.bottom.equalTo(self.view).offset(-45);
			}];
			[radiusViewArr addObject:radiusBG];
			
			AYShadowRadiusView *radiusView= [[AYShadowRadiusView alloc] initWithRadius:4.f];
			[radiusBG addSubview:radiusView];
			if (i==0) {
				[radiusView mas_makeConstraints:^(MASConstraintMaker *make) {
					make.edges.equalTo(radiusBG);
				}];
				timesPriceInput = [[AYSetPriceInputView alloc] initWithSign:[NSString stringWithFormat:@"／%@",[itemTips objectAtIndex:i]]];
				timesPriceInput.inputField.delegate = self;
				[radiusView addSubview:timesPriceInput];
				[timesPriceInput mas_makeConstraints:^(MASConstraintMaker *make) {
					make.top.equalTo(radiusView).offset(90);
					make.centerX.equalTo(radiusView);
					make.size.mas_equalTo(CGSizeMake(segWidth - marginScreen*2, kInputGroupHeight));
				}];
			} else {
				[radiusView mas_makeConstraints:^(MASConstraintMaker *make) {
					make.centerX.equalTo(radiusBG);
					make.width.mas_equalTo(segWidth);
					make.top.equalTo(radiusBG);
					make.bottom.equalTo(radiusBG.mas_centerY).offset(-5);
				}];
				stagePriceInput = [[AYSetPriceInputView alloc] initWithSign:[NSString stringWithFormat:@"／%@",[itemTips objectAtIndex:i]]];
				stagePriceInput.inputField.delegate = self;
				[radiusView addSubview:stagePriceInput];
				[stagePriceInput mas_makeConstraints:^(MASConstraintMaker *make) {
					make.centerY.equalTo(radiusView);
					make.centerX.equalTo(radiusView);
					make.size.mas_equalTo(CGSizeMake(segWidth - marginScreen*2, kInputGroupHeight));
				}];
				
				AYShadowRadiusView *countRadiusView= [[AYShadowRadiusView alloc] initWithRadius:4.f];
				[radiusBG addSubview:countRadiusView];
				[countRadiusView mas_makeConstraints:^(MASConstraintMaker *make) {
					make.top.equalTo(radiusBG.mas_centerY).offset(5);
					make.centerX.equalTo(radiusBG);
					make.bottom.equalTo(radiusBG);
					make.width.mas_equalTo(segWidth);
				}];
				timesCountInput = [[AYSetPriceInputView alloc] initWithSign:@"阶段授课次数"];
				timesCountInput.inputField.delegate = self;
				[countRadiusView addSubview:timesCountInput];
				[timesCountInput mas_makeConstraints:^(MASConstraintMaker *make) {
					make.centerY.equalTo(countRadiusView);
					make.centerX.equalTo(countRadiusView);
					make.size.equalTo(stagePriceInput);
				}];
			}
			
			UILabel *tipLabel = [Tools creatUILabelWithText:[NSString stringWithFormat:@"设置%@价格该服务可按%@预定", [itemTitles objectAtIndex:i], [itemTips objectAtIndex:i]] andTextColor:[Tools garyColor] andFontSize:311 andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
			[radiusView addSubview:tipLabel];
			[tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
				make.bottom.equalTo(radiusView.mas_bottom).offset(-10);
				make.centerX.equalTo(radiusView);
			}];
		}
		
	} else if([catStr isEqualToString:kAYStringNursery]) {
		itemCount = 3;
		itemTitles = @[@"时托", @"日托", @"月托"];
		itemTips = @[@"小时", @"天", @"月"];
//		itemTips = @[@"设置时托价格该服务可按小时预定", @"设置日托价格该服务可按日预定", @"设置月托价格该服务可按月预定"];
		CGFloat itemBtnWith = segWidth / itemCount;
		
		inputViewArr = [NSMutableArray array];
		
		for (int i = 0; i < itemCount; ++i) {
			
			AYServicePriceCatBtn *btn = [[AYServicePriceCatBtn alloc] initWithFrame:CGRectMake(marginScreen+itemBtnWith*i, SCREEN_HEIGHT*155/667, itemBtnWith, 40) andTitle:[itemTitles objectAtIndex:i]];
			btn.tag = i;
			[self.view addSubview:btn];
			btn.selected = i == 0;
			[btn addTarget:self action:@selector(didCatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
			[priceCatBtnArr addObject:btn];
			
			AYShadowRadiusView *radiusView= [[AYShadowRadiusView alloc] initWithRadius:4.f];
			[self.view addSubview:radiusView];
			[radiusView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self.view).offset(i==0?0:SCREEN_WIDTH);
				make.width.mas_equalTo(segWidth);
				make.top.equalTo(titleLabel.mas_bottom).offset(95);
				make.bottom.equalTo(self.view).offset(-45);
			}];
			[radiusViewArr addObject:radiusView];
			
			AYSetPriceInputView *inputView = [[AYSetPriceInputView alloc] initWithSign:[NSString stringWithFormat:@"／%@",[itemTips objectAtIndex:i]]];
			inputView.inputField.delegate = self;
			[radiusView addSubview:inputView];
			[inputView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(radiusView).offset(90);
				make.centerX.equalTo(radiusView);
				make.size.mas_equalTo(CGSizeMake(segWidth - marginScreen*2, 80));
			}];
			[inputViewArr addObject:inputView];
			
			UILabel *tipLabel = [Tools creatUILabelWithText:[NSString stringWithFormat:@"设置%@价格该服务可按%@预定", [itemTitles objectAtIndex:i], [itemTips objectAtIndex:i]] andTextColor:[Tools garyColor] andFontSize:311 andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
			[radiusView addSubview:tipLabel];
			[tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
				make.bottom.equalTo(radiusView.mas_bottom).offset(-10);
				make.centerX.equalTo(radiusView);
			}];
		}
		
	} else {
		
	}
	[[priceCatBtnArr objectAtIndex:0] setSelected:YES];
	handleBtn = [priceCatBtnArr objectAtIndex:0];
	
	self.view.userInteractionEnabled = YES;
	[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapElse)]];
}
- (void)didTapElse {
	[self.view endEditing:YES];
}
#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	
	UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	//	NSString *title = @"服务类型";
	//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	NSNumber* right_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
	//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

#pragma mark -- actions
- (void)didCatBtnClick:(AYServicePriceCatBtn*)btn {
	
	if (handleBtn == btn) {
		return;
	}
	
	NSInteger currentIndex = handleBtn.tag;
	[[[inputViewArr objectAtIndex:currentIndex] inputField] resignFirstResponder];
	handleBtn.selected = NO;
	btn.selected = !btn.selected;
	NSInteger changeIndex = btn.tag;
	handleBtn = btn;
	
	AYShadowRadiusView *currentView = [radiusViewArr objectAtIndex:currentIndex];
	AYShadowRadiusView *changeView = [radiusViewArr objectAtIndex:changeIndex];
	
	NSInteger comp = changeIndex - currentIndex;
	if (comp > 0) {
		[UIView animateWithDuration:0.25 animations:^{
//			currentView.center = CGPointMake(self.view.center.x - SCREEN_WIDTH, currentView.center.y);
//			changeView.center = CGPointMake(self.view.center.x, currentView.center.y);
			[currentView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self.view).offset(-SCREEN_WIDTH);
			}];
			[changeView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self.view).offset(0);
			}];
			[self.view layoutIfNeeded];
		}];
		
	} else if (comp < 0) {
		[UIView animateWithDuration:0.25 animations:^{
//			currentView.center = CGPointMake(self.view.center.x + SCREEN_WIDTH, currentView.center.y);
//			changeView.center = CGPointMake(self.view.center.x, currentView.center.y);
			[currentView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self.view).offset(SCREEN_WIDTH);
			}];
			[changeView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.centerX.equalTo(self.view).offset(0);
			}];
			[self.view layoutIfNeeded];
		}];
	}
}

#pragma mark -- textfiled delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if (textField == timesCountInput.inputField) {
		return YES;
	} else {
		
		if (string.length != 0) {
			if (textField.text.length == 0) {
				textField.text = @"¥";
			}
			textField.text = [textField.text stringByAppendingString:string];
		} else {
			textField.text = [textField.text substringToIndex:textField.text.length - 1];
			if (textField.text.length == 1) {
				textField.text = @"";
			}
		}
		
		for (AYSetPriceInputView *input in inputViewArr) {
			if (textField == input.inputField) {
				input.isHideSep = textField.text.length != 0;
			}
		}
		return NO;
	}
}


#pragma mark -- notifies
- (id)leftBtnSelected {
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

- (id)rightBtnSelected {
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableArray *priceArr = [[NSMutableArray alloc] init];
	NSString *catStr = [[push_service_info objectForKey:kAYServiceArgsCategoryInfo] objectForKey:kAYServiceArgsCat];
	if ([catStr isEqualToString:kAYStringCourse]) {
		for (int i = 0; i < inputViewArr.count; ++i) {
			NSMutableDictionary *dic_price = [[NSMutableDictionary alloc] init];
			int p = [[[[[inputViewArr objectAtIndex:i] inputField] text] stringByReplacingOccurrencesOfString:@"¥" withString:@""] intValue] * 100;
			[dic_price setValue:[NSNumber numberWithInt:p] forKey:kAYServiceArgsPrice];
			[dic_price setValue:[NSNumber numberWithInt:i+4] forKey:kAYServiceArgsPriceType];
			[priceArr addObject:dic_price];
		}
	} else if([catStr isEqualToString:kAYStringNursery]) {
		for (int i = 0; i < inputViewArr.count; ++i) {
			NSMutableDictionary *dic_price = [[NSMutableDictionary alloc] init];
			int p = [[[[[inputViewArr objectAtIndex:i] inputField] text] stringByReplacingOccurrencesOfString:@"¥" withString:@""] intValue] * 100;
			[dic_price setValue:[NSNumber numberWithInt:p] forKey:kAYServiceArgsPrice];
			[dic_price setValue:[NSNumber numberWithInt:i] forKey:kAYServiceArgsPriceType];
			[priceArr addObject:dic_price];
		}
	} else {
		
	}
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
	[tmp setValue:priceArr forKey:kAYServiceArgsPriceArr];
	[tmp setValue:@"part_price" forKey:@"key"];
	[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

@end
