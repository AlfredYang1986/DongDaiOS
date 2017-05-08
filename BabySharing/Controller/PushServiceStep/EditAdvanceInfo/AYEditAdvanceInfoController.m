//
//  AYEditAdvanceInfoController.m
//  BabySharing
//
//  Created by Alfred Yang on 6/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYEditAdvanceInfoController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYServiceArgsDefines.h"
#import "AYInsetLabel.h"
#import "AYAdvanceOptView.h"

#define LIMITNUMB                   228

@implementation AYEditAdvanceInfoController {
    
    NSMutableDictionary *service_info;
    UILabel *addressLabel;
	AYAdvanceOptView *positionTitle;
	
    BOOL isHaveChanged;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
//        NSDictionary *dic_facility = [dic objectForKey:kAYControllerChangeArgsKey];
        service_info = [[dic objectForKey:kAYControllerChangeArgsKey] mutableCopy];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
        isHaveChanged = YES;
        
        NSDictionary *dic_args = [dic objectForKey:kAYControllerChangeArgsKey];
        NSNumber *capacity = [dic_args objectForKey:kAYServiceArgsCapacity];
        if (capacity) {
            [service_info setValue:[dic_args objectForKey:kAYServiceArgsAgeBoundary] forKey:kAYServiceArgsAgeBoundary];
            [service_info setValue:[dic_args objectForKey:kAYServiceArgsCapacity] forKey:kAYServiceArgsCapacity];
            [service_info setValue:[dic_args objectForKey:kAYServiceArgsServantNumb] forKey:kAYServiceArgsServantNumb];
            [service_info setValue:[dic_args objectForKey:kAYServiceArgsServiceCat] forKey:kAYServiceArgsServiceCat];
            [service_info setValue:[dic_args objectForKey:kAYServiceArgsCourseCat] forKey:kAYServiceArgsCourseCat];
            //[service_info setValue:[dic_args objectForKey:kAYServiceArgsTheme] forKey:kAYServiceArgsTheme];
            [service_info setValue:[dic_args objectForKey:kAYServiceArgsIsAdjustSKU] forKey:kAYServiceArgsIsAdjustSKU];
        }
        
        NSNumber *facility = [dic_args objectForKey:kAYServiceArgsFacility];
        if (facility) {
            [service_info setValue:facility forKey:kAYServiceArgsFacility];
        }
        
        NSString *addressStr = [dic_args objectForKey:kAYServiceArgsAddress];
        if (addressStr) {
            [service_info setValue:[dic_args objectForKey:kAYServiceArgsLocation] forKey:kAYServiceArgsLocation];
            [service_info setValue:[dic_args objectForKey:kAYServiceArgsDistinct] forKey:kAYServiceArgsDistinct];
            [service_info setValue:[dic_args objectForKey:kAYServiceArgsAdjustAddress] forKey:kAYServiceArgsAdjustAddress];
            positionTitle.subTitleLabel.text = addressStr;
            [service_info setValue:addressStr forKey:kAYServiceArgsAddress];
        }
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
    UITableView *tableView = (UITableView*)view_notify;
	
	UILabel *placelabel = [Tools creatUILabelWithText:@"场地信息" andTextColor:[Tools themeColor] andFontSize:620.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	AYAdvanceOptView *placeTitle = [[AYAdvanceOptView alloc] initWithTitle:placelabel];
	placeTitle.access.hidden = YES;
	[tableView addSubview:placeTitle];
	[placeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(tableView).offset(10);
		make.centerX.equalTo(tableView);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 50));
	}];
	
	UILabel *positionLabel = [Tools creatUILabelWithText:@"位置" andTextColor:[Tools blackColor] andFontSize:316.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	positionTitle = [[AYAdvanceOptView alloc] initWithTitle:positionLabel];
	[tableView addSubview:positionTitle];
	[positionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(placeTitle.mas_bottom).offset(0);
		make.centerX.equalTo(tableView);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 64));
	}];
	positionTitle.userInteractionEnabled = YES;
	[positionTitle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPositionLabelTap)]];
	
	NSString *addressStr = [service_info objectForKey:kAYServiceArgsAddress];
	if (addressStr && ![addressStr isEqualToString:@""]) {
		positionTitle.subTitleLabel.text = addressStr;
	} else {
		positionTitle.subTitleLabel.text = @"场地地址";
	}
	
	UILabel *facilityLabel = [Tools creatUILabelWithText:@"场地友好性" andTextColor:[Tools blackColor] andFontSize:316.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	AYAdvanceOptView *facilityTitle = [[AYAdvanceOptView alloc] initWithTitle:facilityLabel];
    [tableView addSubview:facilityTitle];
    [facilityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(positionTitle.mas_bottom).offset(0);
        make.centerX.equalTo(tableView);
        make.size.equalTo(positionTitle);
    }];
    facilityTitle.userInteractionEnabled = YES;
    [facilityTitle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didFacilityLabelTap)]];
    
    UILabel *detailLabel = [Tools creatUILabelWithText:@"详情" andTextColor:[Tools themeColor] andFontSize:620.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	AYAdvanceOptView *detailTitle = [[AYAdvanceOptView alloc] initWithTitle:detailLabel];
	detailTitle.access.hidden = YES;
    [tableView addSubview:detailTitle];
    [detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tableView);
        make.top.equalTo(facilityTitle.mas_bottom).offset(25);
		make.size.equalTo(placeTitle);
    }];
	
    UILabel *infoLabel = [Tools creatUILabelWithText:@"服务详情" andTextColor:[Tools blackColor] andFontSize:316.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	AYAdvanceOptView *infoTitle = [[AYAdvanceOptView alloc]initWithTitle:infoLabel];
    [tableView addSubview:infoTitle];
    [infoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailTitle.mas_bottom).offset(20);
        make.centerX.equalTo(tableView);
        make.size.equalTo(positionTitle);
    }];
    infoTitle.userInteractionEnabled = YES;
    [infoTitle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didInfoLabelTap)]];
	
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
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
    NSNumber *isHidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &isHidden)
    
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    CGFloat margin = 0;
    view.frame = CGRectMake(margin, 64, SCREEN_WIDTH - margin * 2, SCREEN_HEIGHT - 64);
    
//    ((UITableView*)view).contentInset = UIEdgeInsetsMake(SCREEN_HEIGHT - 64, 0, 0, 0);
    ((UITableView*)view).backgroundColor = [UIColor clearColor];
    return nil;
}

#pragma mark -- actions
- (void)didPositionLabelTap {
    id<AYCommand> des = DEFAULTCONTROLLER(@"NapArea");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    
//    NSMutableDictionary *service_info = [[NSMutableDictionary alloc]init];
    [dic_push setValue:@"editMode" forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)didFacilityLabelTap {
    
    id<AYCommand> dest = DEFAULTCONTROLLER(@"SetNapDevice");
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_args = [[NSMutableDictionary alloc]init];
    [dic_args setValue:[service_info objectForKey:kAYServiceArgsFacility] forKey:kAYServiceArgsFacility];
    //    [dic_args setValue:[service_info objectForKey:@"option_custom"] forKey:@"option_custom"];
    [dic_push setValue:dic_args forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

- (void)didInfoLabelTap {
    
    id<AYCommand> dest = DEFAULTCONTROLLER(@"EditServiceCapacity");
    
    NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
    [tmp setValue:[service_info objectForKey:kAYServiceArgsAgeBoundary] forKey:kAYServiceArgsAgeBoundary];
    [tmp setValue:[service_info objectForKey:kAYServiceArgsCapacity] forKey:kAYServiceArgsCapacity];
    [tmp setValue:[service_info objectForKey:kAYServiceArgsServantNumb] forKey:kAYServiceArgsServantNumb];
    [tmp setValue:[service_info objectForKey:kAYServiceArgsServiceCat] forKey:kAYServiceArgsServiceCat];
    [tmp setValue:[service_info objectForKey:kAYServiceArgsCourseCat] forKey:kAYServiceArgsCourseCat];
    [tmp setValue:[service_info objectForKey:kAYServiceArgsIsAdjustSKU] forKey:kAYServiceArgsIsAdjustSKU];
    
    [dic_push setValue:tmp forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    if (isHaveChanged) {
        NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
        [dic_info setValue:kAYServiceArgsInfo forKey:@"key"];
        [dic_info setValue:service_info forKey:kAYServiceArgsInfo];
        [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    }
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
    [dic_info setValue:kAYServiceArgsInfo forKey:@"key"];
    [dic_info setValue:service_info forKey:kAYServiceArgsInfo];
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

@end
