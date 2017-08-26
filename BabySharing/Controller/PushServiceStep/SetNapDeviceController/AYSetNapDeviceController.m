//
//  AYSetNapDeviceController.m
//  BabySharing
//
//  Created by Alfred Yang on 21/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetNapDeviceController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYServiceArgsDefines.h"

#define LIMITNUMB                   228

@implementation AYSetNapDeviceController {
	
    NSMutableArray *optionsData;
	
	NSDictionary *show_service_info;
	NSMutableDictionary *note_update_info;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    
	NSDictionary* dic = (NSDictionary*)*obj;
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        id args = [dic objectForKey:kAYControllerChangeArgsKey];
        if ([args isKindOfClass:[NSArray class]]) {
			optionsData = [NSMutableArray arrayWithArray:args];
		} else {
			show_service_info = args;
			optionsData = [NSMutableArray arrayWithArray:[[args objectForKey:kAYServiceArgsDetailInfo] objectForKey:kAYServiceArgsFacility]];
		}
		
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (!optionsData) {
		optionsData = [NSMutableArray array];
	}
	
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"SetNapCost"];
	id obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
	obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
	
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SetNapOptionsCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
    
	id data = [optionsData copy];
    kAYDelegatesSendMessage(@"SetNapCost", kAYDelegateChangeDataMessage, &data)
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
	
	//    NSString *title = @"场地友好性";
	//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIImage* left = IMGRESOURCE(@"bar_left_theme");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil];
//	bar_right_btn.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
	
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    CGFloat margin = 0;
    view.frame = CGRectMake(margin, 64, SCREEN_WIDTH - margin * 2, SCREEN_HEIGHT - 64);
	
    ((UITableView*)view).backgroundColor = [UIColor clearColor];
    return nil;
}

#pragma mark -- actions
- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {
    NSLog(@"tap esle where");
}

-(id)didOptionBtnClick:(NSString*)args {
	if ([optionsData containsObject:args]) {
		[optionsData removeObject:args];
	} else
		[optionsData addObject:args];
	
    return nil;
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
    
    //整合数据
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	if (show_service_info) {
		[note_update_info setValue:optionsData forKey:kAYServiceArgsFacility];
		[dic setValue:[note_update_info copy] forKey:kAYControllerChangeArgsKey];
	} else {
		if (optionsData.count != 0) {
			NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
			[dic_info setValue:[optionsData copy] forKey:kAYServiceArgsFacility];
			[dic_info setValue:kAYServiceArgsFacility forKey:@"key"];
			
			[dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
		}
	}
	
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
	
    return nil;
}




-(id)textChange:(NSString*)text {
	
    return nil;
}

@end
