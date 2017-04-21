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
    ServiceType service_type;
    BOOL isEdit;
	
	NSInteger backArgsOfRowNumb;
	NSMutableDictionary *dic_cat_cans;
	NSMutableDictionary *dic_note;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
        id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
        if ([tmp isKindOfClass:[NSNumber class]]) {
            service_type = ((NSNumber*)[dic objectForKey:kAYControllerChangeArgsKey]).intValue;
			
			dic_cat_cans = [[NSMutableDictionary alloc]init];
			[dic_cat_cans setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYServiceArgsServiceCat];
			
        } else if ([tmp isKindOfClass:[NSString class]]) {
            isEdit = YES;
        }
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		NSNumber *is_change = [dic objectForKey:kAYControllerChangeArgsKey];
		if (is_change.boolValue) {
			
			NSMutableDictionary *tmp = [dic_cat_cans copy];
			kAYDelegatesSendMessage(@"SetServiceTheme", @"changeQueryData:", &tmp);
			kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
			
			UIView *tableView = [self.views objectForKey:kAYTableView];
			[UIView animateWithDuration:0.25 animations:^{
				tableView.frame = CGRectMake(0, SCREEN_HEIGHT - backArgsOfRowNumb * CellHeight - 49, SCREEN_WIDTH, backArgsOfRowNumb * CellHeight);
			}];
		} else {
			if (dic_note) {
				dic_cat_cans = dic_note;
			}
		}
		dic_note = nil;
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
    
    NSNumber *type = [NSNumber numberWithInt:service_type];
	NSString *titleStr;
	if (type.intValue == ServiceTypeLookAfter) {
		titleStr = @"您的看顾是什么类型?";
	} else if (type.intValue == ServiceTypeCourse) {
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
	
	NSMutableDictionary *tmp = [dic_cat_cans copy];
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
//    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
//    view.backgroundColor = [UIColor whiteColor];
	
//    NSString *title = @"服务主题";
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	
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

	[dic_push setValue:dic_cat_cans forKey:kAYControllerChangeArgsKey];

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

- (id)serviceThemeSeted:(NSNumber*)args {
//    notePow = pow(2, btn.tag);
//    long option = pow(2, args.longValue);
    
    if (isEdit) {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
        [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
        [dic setValue:args forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = POP;
        [cmd performWithResult:&dic];
        
    } else {
		
		switch (service_type) {
			case ServiceTypeLookAfter:
			{
				[dic_cat_cans setValue:args forKey:kAYServiceArgsTheme];
				[self didServiceThemeNextBtnClick];
			}
				break;
			case ServiceTypeCourse:
			{
				
				// 变换选项
				NSNumber *cans_cat = [[NSNumber alloc]init];
				cans_cat = [dic_cat_cans objectForKey:kAYServiceArgsCourseCat];
				
				if (![cans_cat isEqualToNumber:args]) {
					
					dic_note = [[NSMutableDictionary alloc]initWithDictionary:dic_cat_cans];
					[dic_cat_cans setValue:args forKey:kAYServiceArgsCourseCat];
					NSNumber *cans = [dic_cat_cans objectForKey:kAYServiceArgsCourseSign];
					if (cans) {
						[dic_cat_cans removeObjectForKey:kAYServiceArgsCourseSign];
					}
				}
				else {
					[dic_cat_cans setValue:args forKey:kAYServiceArgsCourseCat];
				}
				
				id<AYCommand> des = DEFAULTCONTROLLER(@"SetCourseSign");
				NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
				[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
				[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
				[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
				
				[dic_push setValue:dic_cat_cans forKey:kAYControllerChangeArgsKey];
				
				id<AYCommand> cmd = PUSH;
				[cmd performWithResult:&dic_push];
			}
				break;
			default:
				break;
		}
		
    }
    return nil;
}

@end
