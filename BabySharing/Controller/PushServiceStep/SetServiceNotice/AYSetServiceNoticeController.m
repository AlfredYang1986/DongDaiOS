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
        NSDictionary *notice_args = [dic objectForKey:kAYControllerChangeArgsKey];
        setedNoticeStr = [notice_args objectForKey:kAYServiceArgsNotice];
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UILabel *titleLabel = [Tools creatUILabelWithText:@"服务守则" andTextColor:[Tools themeColor] andFontSize:620.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(80);
		make.left.equalTo(self.view).offset(20);
	}];
	
	[Tools creatCALayerWithFrame:CGRectMake(20, 115, SCREEN_WIDTH - 20 * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:self.view];
	
	CGFloat insetLabelHeight = 64.f;
	
	UIView *allowView = [[UIView alloc]init];
	[self.view addSubview:allowView];
	[allowView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(116);
		make.centerX.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, insetLabelHeight));
	}];
	[Tools creatCALayerWithFrame:CGRectMake(0, insetLabelHeight - 0.5, SCREEN_WIDTH - 20 * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:allowView];
	
	UILabel *h1 = [Tools creatUILabelWithText:@"需要家长陪同" andTextColor:[Tools blackColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[allowView addSubview:h1];
	[h1 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(allowView);
		make.left.equalTo(allowView).offset(5);
	}];
    
    isALeaveSwitch = [[UISwitch alloc]init];
    isALeaveSwitch.onTintColor = [Tools themeColor];
//    isALeaveSwitch.transform= CGAffineTransformMakeScale(0.69, 0.69);
    [allowView addSubview:isALeaveSwitch];
    [isALeaveSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(allowView);
        make.right.equalTo(allowView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(49, 31));
    }];
    isALeaveSwitch.on = isAllowLeave;
	
	UIView *otherNoticeView = [[UIView alloc]init];
	[self.view addSubview:otherNoticeView];
	[otherNoticeView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(allowView.mas_bottom);
		make.centerX.equalTo(allowView);
		make.size.equalTo(allowView);
	}];
	[Tools creatCALayerWithFrame:CGRectMake(0, insetLabelHeight - 0.5, SCREEN_WIDTH - 20 * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:otherNoticeView];
	
	UILabel *otherLabel = [Tools creatUILabelWithText:@"其他守则" andTextColor:[Tools blackColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
    [otherNoticeView addSubview:otherLabel];
    [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(otherNoticeView);
		make.left.equalTo(otherNoticeView).offset(5);
    }];
    otherNoticeView.userInteractionEnabled = YES;
    [otherNoticeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didOtherNoticeTap)]];
    
    UIImageView *access = [[UIImageView alloc]init];
    [otherNoticeView addSubview:access];
    access.image = IMGRESOURCE(@"plan_time_icon");
    [access mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(otherNoticeView).offset(-10);
        make.centerY.equalTo(otherNoticeView);
        make.size.mas_equalTo(CGSizeMake(23, 23));
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
	
    NSNumber *is_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
    
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, kTableFrameY, SCREEN_WIDTH, SCREEN_HEIGHT - kTableFrameY);
    return nil;
}

#pragma mark -- actions
//- (void)didYesBtnClick {
//    optionBtn.selected = !optionBtn.selected;
//}

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
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    return nil;
}

@end
