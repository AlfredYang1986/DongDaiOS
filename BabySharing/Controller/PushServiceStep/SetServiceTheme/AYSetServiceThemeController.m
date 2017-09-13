//
//  AYSetServiceThemeController.m
//  BabySharing
//
//  Created by Alfred Yang on 29/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetServiceThemeController.h"
#import "AYServiceArgsDefines.h"

#define CellHeight			100

@implementation AYSetServiceThemeController {
	
    BOOL isEdit;
	
	NSInteger backArgsOfRowNumb;
	
	NSMutableDictionary *service_info;
	NSMutableDictionary *info_categ;
	NSString *CatStr;
	NSString *secondaryTmp;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
        id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
        if ([tmp isKindOfClass:[NSMutableDictionary class]]) {
			service_info = tmp;
			info_categ  = [service_info objectForKey:kAYServiceArgsCategoryInfo];
			CatStr = [info_categ objectForKey:kAYServiceArgsCat];
			
        } else if ([tmp isKindOfClass:[NSString class]]) {
            isEdit = YES;
        }
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		NSNumber *is_change = [dic objectForKey:kAYControllerChangeArgsKey];
		if (is_change.boolValue) {
			
			NSMutableDictionary *tmp = [info_categ copy];
			kAYDelegatesSendMessage(@"SetServiceTheme", @"changeQueryData:", &tmp);
			kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
			
			UIView *tableView = [self.views objectForKey:kAYTableView];
			[UIView animateWithDuration:0.25 animations:^{
				tableView.frame = CGRectMake(0, SCREEN_HEIGHT - backArgsOfRowNumb * CellHeight - 49, SCREEN_WIDTH, backArgsOfRowNumb * CellHeight);
			}];
		} else {
			if (secondaryTmp) {
				[info_categ setValue:secondaryTmp forKey:kAYServiceArgsCatSecondary];
			}
		}
		
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"SetServiceTheme"];
    
    id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
    
    id obj = (id)cmd_notify;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_notify;
    [cmd_delegate performWithResult:&obj];
    
    NSString* cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SetServiceThemeCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &cell_name)
	
	NSString *titleStr;
	if ([CatStr isEqualToString:kAYStringNursery]) {
		titleStr = @"您的看顾是什么类型?";
	} else if ([CatStr isEqualToString:kAYStringCourse]) {
		titleStr = @"您的课程是什么类型?";
	} else {
		titleStr = @"参数设置错误";
	}
	
	UILabel *titleLabel = [Tools creatUILabelWithText:titleStr andTextColor:[Tools themeColor] andFontSize:624.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	titleLabel.numberOfLines = 0;
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.view);
		make.top.equalTo(self.view).offset(SCREEN_HEIGHT * 200/667);
		make.width.mas_equalTo(240);
	}];
	
	NSMutableDictionary *tmp = [info_categ copy];
    kAYDelegatesSendMessage(@"SetServiceTheme", @"changeQueryData:", &tmp);
	
	backArgsOfRowNumb = ((NSNumber*)tmp).integerValue;
	
	UIView *tableView = [self.views objectForKey:kAYTableView];
	tableView.frame = CGRectMake(0, SCREEN_HEIGHT - backArgsOfRowNumb * CellHeight, SCREEN_WIDTH, backArgsOfRowNumb * CellHeight);
	
	UIButton *nextBtn = [Tools creatUIButtonWithTitle:@"下一步" andTitleColor:[Tools whiteColor] andFontSize:316.f andBackgroundColor:[Tools themeColor]];
	[self.view addSubview:nextBtn];
	[nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.view);
		make.bottom.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 49));
	}];
//	nextBtn.hidden = YES;
	[self.view sendSubviewToBack:nextBtn];
	[nextBtn addTarget:self action:@selector(didServiceThemeNextBtnClick) forControlEvents:UIControlEventTouchUpInside];
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
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	
    UIImage* left = IMGRESOURCE(@"bar_left_theme");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    view.backgroundColor = [Tools whiteColor];
    return nil;
}

#pragma mark -- actions
- (void)didServiceThemeNextBtnClick {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"NapArea");
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];

	[dic_push setValue:service_info forKey:kAYControllerChangeArgsKey];

	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:[NSNumber numberWithBool:YES] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    
    return nil;
}

- (id)serviceThemeSeted:(NSString*)args {
    
    if (isEdit) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
        [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
        [dic setValue:args forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = POP;
        [cmd performWithResult:&dic];
        
    } else {
		if ([CatStr isEqualToString:kAYStringNursery]) {
			[info_categ setValue:args forKey:kAYServiceArgsCatSecondary];
			[self didServiceThemeNextBtnClick];
			
		} else if ([CatStr isEqualToString:kAYStringCourse]) {
			// 变换选项:修改/仅浏览
			secondaryTmp = [info_categ objectForKey:kAYServiceArgsCatSecondary];
			[info_categ setValue:args forKey:kAYServiceArgsCatSecondary];
			
			id<AYCommand> des = DEFAULTCONTROLLER(@"SetCourseSign");
			NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
			[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
			[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
			[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
			
			[dic_push setValue:info_categ forKey:kAYControllerChangeArgsKey];
			
			id<AYCommand> cmd = PUSH;
			[cmd performWithResult:&dic_push];
			
		} else {
			
		}
    }
    return nil;
}

@end
