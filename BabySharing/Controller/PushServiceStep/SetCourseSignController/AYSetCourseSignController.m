//
//  AYSetCourseSignController.m
//  BabySharing
//
//  Created by Alfred Yang on 9/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetCourseSignController.h"
#import "AYViewBase.h"
#import "AYFactoryManager.h"
#import "AYServiceArgsDefines.h"

#define kExpandHeight		110

@implementation AYSetCourseSignController {
    NSMutableDictionary *info_categ;
	
	UIView *coustomView;
	UILabel *coustomLabel;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
	NSDictionary* dic = (NSDictionary*)*obj;
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        info_categ = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	coustomView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, 45)];
	[self.view addSubview:coustomView];
	coustomView.clipsToBounds = YES;
	
	UILabel *tipCoustomLabel = [Tools creatUILabelWithText:@"创建新的标签" andTextColor:[Tools blackColor] andFontSize:617 andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[coustomView addSubview:tipCoustomLabel];
	[tipCoustomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(coustomView).offset(20);
		make.right.equalTo(coustomView).offset(-20);
		make.top.equalTo(coustomView);
		make.height.equalTo(@44);
	}];
	
	UIImageView *accessView = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"plan_time_icon")];
	[coustomView addSubview:accessView];
	[accessView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(coustomView).offset(-20);
		make.centerY.equalTo(tipCoustomLabel);
		make.size.mas_equalTo(CGSizeMake(14, 14));
	}];
	
	[Tools creatCALayerWithFrame:CGRectMake(20, 44, SCREEN_WIDTH - 40, 0.5) andColor:[Tools garyLineColor] inSuperView:coustomView];
	
	CGFloat itemWidth = (SCREEN_WIDTH - 40 - 3*8)/4;
	coustomLabel = [Tools creatUILabelWithText:@"" andTextColor:[Tools whiteColor] andFontSize:315 andBackgroundColor:[Tools themeColor] andTextAlignment:NSTextAlignmentCenter];
	[coustomView addSubview:coustomLabel];
	[coustomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(tipCoustomLabel);
		make.top.equalTo(tipCoustomLabel.mas_bottom).offset(26);
		make.size.mas_equalTo(CGSizeMake(itemWidth, 33));
	}];
	
	id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"SetCourseSign"];
	id obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDelegateMessage, &obj)
	obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterDatasourceMessage, &obj)
    
    NSString* cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SetCourseSignCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &cell_name)
	
    id tmp = [info_categ copy];
    kAYDelegatesSendMessage(@"SetCourseSign", @"changeQueryData:", &tmp);
    
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    
//    NSString *title = @"服务标签";
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
    UIImage* left = IMGRESOURCE(@"bar_left_theme");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
	CGFloat marginTop = 64+45+10;
    view.frame = CGRectMake(0, marginTop, SCREEN_WIDTH, SCREEN_HEIGHT - marginTop);
    view.backgroundColor = [Tools whiteColor];
    return nil;
}

#pragma mark -- actions
- (void)didNorseLabelTap {
    id<AYCommand> des = DEFAULTCONTROLLER(@"NapLocation");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:@"push" forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:[NSNumber numberWithBool:NO] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

- (id)rightBtnSelected {
    
    return nil;
}

- (id)courseCansSeted:(id)args {
	[info_categ setValue:args forKey:kAYServiceArgsCatThirdly];
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:[NSNumber numberWithBool:YES] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

- (id)didCourseSignViewTap:(id)args {
	[info_categ setValue:args forKey:kAYServiceArgsCatThirdly];
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:[NSNumber numberWithBool:YES] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

@end
