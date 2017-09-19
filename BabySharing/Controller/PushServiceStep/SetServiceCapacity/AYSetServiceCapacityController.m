//
//  AYSetServiceCapacityController.m
//  BabySharing
//
//  Created by Alfred Yang on 29/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetServiceCapacityController.h"

#import "AYSetCapacityOptView.h"

@implementation AYSetServiceCapacityController {
    
	NSMutableDictionary *push_service_info;
    NSMutableDictionary *dic_detail;
	
	NSMutableArray *optViewArr;
	
	BOOL isAlreadyEnable;
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
	
	UILabel *titleLabel = [Tools creatUILabelWithText:@"师生设定" andTextColor:[Tools blackColor] andFontSize:630.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	titleLabel.numberOfLines = 0;
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view).offset(40);
		make.top.equalTo(self.view).offset(SCREEN_HEIGHT * 168/667);
	}];
	
	CGFloat unitHeight = 56.f;
	CGFloat betMargin = 16.f;
	CGFloat topMargin = SCREEN_HEIGHT * 300/667;
	
	NSArray *titles = @[@"孩子年龄范围", @"接待孩子数量", @"服务者数量"];
	NSArray *subTitles = @[@"2-11", @"8", @"8"];
	optViewArr = [NSMutableArray array];
	for (int i = 0; i < titles.count; ++i) {
		AYSetCapacityOptView *optView = [[AYSetCapacityOptView alloc] initWithTitle:[titles objectAtIndex:i] andSubTitle:[subTitles objectAtIndex:i]];
		[self.view addSubview:optView];
		optView.tag = i;
		optView.userInteractionEnabled = YES;
		[optView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSetCapacityLabelTap:)]];
		[optView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.view).offset(topMargin + i*(unitHeight+betMargin));
			make.left.equalTo(self.view).offset(40);
			make.right.equalTo(self.view).offset(-40);
			make.height.mas_equalTo(unitHeight);
		}];
		[optViewArr addObject:optView];
	}
	
	dic_detail = [[NSMutableDictionary alloc] init];
	NSDictionary *info_detail = [push_service_info objectForKey:kAYServiceArgsDetailInfo];
	NSDictionary *age_boundary = [info_detail objectForKey:kAYServiceArgsAgeBoundary];
	if (age_boundary) {
		[dic_detail setValue:age_boundary forKey:kAYServiceArgsAgeBoundary];
		NSString *ageStr = [NSString stringWithFormat:@"%@-%@", [age_boundary objectForKey:kAYServiceArgsAgeBoundaryLow], [age_boundary objectForKey:kAYServiceArgsAgeBoundaryUp]];
		[[optViewArr objectAtIndex:0] setSubTitleWithString:ageStr];
	}
	NSNumber *capacity = [info_detail objectForKey:kAYServiceArgsCapacity];
	if(capacity) {
		[dic_detail setValue:capacity forKey:kAYServiceArgsCapacity];
		[[optViewArr objectAtIndex:1] setSubTitleWithString:[NSString stringWithFormat:@"%@", capacity]];
	}
	NSNumber *servant = [info_detail objectForKey:kAYServiceArgsServantNumb];
	if (servant) {
		[dic_detail setValue:[info_detail objectForKey:kAYServiceArgsServantNumb] forKey:kAYServiceArgsServantNumb];
		[[optViewArr objectAtIndex:2] setSubTitleWithString:[NSString stringWithFormat:@"%@", servant]];
	}
	
	
	{
		id<AYViewBase> view_picker = [self.views objectForKey:@"Picker"];
		id<AYCommand> cmd_datasource = [view_picker.commands objectForKey:@"registerDatasource:"];
		id<AYCommand> cmd_delegate = [view_picker.commands objectForKey:@"registerDelegate:"];
		
		id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"SetAgeBoundary"];
		
		id obj = (id)cmd_recommend;
		[cmd_datasource performWithResult:&obj];
		obj = (id)cmd_recommend;
		[cmd_delegate performWithResult:&obj];
		
		[self.view bringSubviewToFront:(UIView*)view_picker];
		NSNumber *index = [NSNumber numberWithInteger:0];
		kAYDelegatesSendMessage(@"SetAgeBoundary", kAYDelegateChangeDataMessage, &index)
	}
	
	
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
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    view.backgroundColor = [UIColor whiteColor];
	
    UIImage* left = IMGRESOURCE(@"bar_left_theme");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	UIButton *btn_right = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools garyColor] andFontSize:616 andBackgroundColor:nil];
	btn_right.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &btn_right)
	
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
	view.clipsToBounds = YES;
    return nil;
}

- (id)PickerLayout:(UIView*)view {
	view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, view.bounds.size.height);
	return nil;
}

#pragma mark -- actions
- (void)didSetCapacityLabelTap:(UITapGestureRecognizer*)tap {
	NSNumber *index = [NSNumber numberWithInteger:tap.view.tag];
	kAYDelegatesSendMessage(@"SetAgeBoundary", kAYDelegateChangeDataMessage, &index)
	kAYViewsSendMessage(kAYPickerView, kAYTableRefreshMessage, nil)
	kAYViewsSendMessage(kAYPickerView, kAYPickerShowViewMessage, nil)
}

- (void)setNavRightBtnEnableStatus {
	if (!isAlreadyEnable) {
		UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:616.f andBackgroundColor:nil];
		kAYViewsSendMessage(@"FakeNavBar", kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
		isAlreadyEnable = YES;
	}
}
- (void)didNextBtnClick {
    
    id<AYCommand> des = DEFAULTCONTROLLER(@"MainInfo");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    [dic_push setValue:push_service_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [dic setValue:[NSNumber numberWithBool:YES] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	[dic_detail setValue:@"part_capacity" forKey:@"key"];
	[dic setValue:[dic_detail copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
    return nil;
}

- (id)didSaveClick {
	
	id<AYDelegateBase> cmd_commend = [self.delegates objectForKey:@"SetAgeBoundary"];
	id<AYCommand> cmd_index = [cmd_commend.commands objectForKey:@"queryCurrentSelected:"];
	id brige = [self.views objectForKey:kAYPickerView];
	[cmd_index performWithResult:&brige];
	
	NSDictionary *args = (NSDictionary*)brige;
	NSDictionary *info_ageboundary = [args objectForKey:kAYServiceArgsAgeBoundary];
	if ([args objectForKey:kAYServiceArgsAgeBoundary]) {
		[dic_detail setValue:[args objectForKey:kAYServiceArgsAgeBoundary] forKey:kAYServiceArgsAgeBoundary];
		NSString *ageStr = [NSString stringWithFormat:@"%@-%@", [info_ageboundary objectForKey:kAYServiceArgsAgeBoundaryLow], [info_ageboundary objectForKey:kAYServiceArgsAgeBoundaryUp]];
		[[optViewArr objectAtIndex:0] setSubTitleWithString:ageStr];
	}
	if ([args objectForKey:kAYServiceArgsCapacity]) {
		[dic_detail setValue:[args objectForKey:kAYServiceArgsCapacity] forKey:kAYServiceArgsCapacity];
		[[optViewArr objectAtIndex:1] setSubTitleWithString:[NSString stringWithFormat:@"%@", [args objectForKey:kAYServiceArgsCapacity]]];
	}
	if ([args objectForKey:kAYServiceArgsServantNumb]) {
		[dic_detail setValue:[args objectForKey:kAYServiceArgsServantNumb] forKey:kAYServiceArgsServantNumb];
		[[optViewArr objectAtIndex:2] setSubTitleWithString:[NSString stringWithFormat:@"%@", [args objectForKey:kAYServiceArgsServantNumb]]];
	}
	
	[self setNavRightBtnEnableStatus];
	return nil;
}

- (id)didCancelClick {
	//do nothing else ,but be have to invoke this methed
	return nil;
}

@end
