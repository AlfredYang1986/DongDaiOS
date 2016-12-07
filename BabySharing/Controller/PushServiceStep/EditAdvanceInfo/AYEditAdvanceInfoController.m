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

#define LIMITNUMB                   228

@implementation AYEditAdvanceInfoController {
    
    NSMutableDictionary *service_info;
    UILabel *addressLabel;
    
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
            [service_info setValue:[dic_args objectForKey:kAYServiceArgsTheme] forKey:kAYServiceArgsTheme];
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
            addressLabel.text = addressStr;
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
    
    UILabel *placeTitle = [Tools creatUILabelWithText:@"场地" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    [tableView addSubview:placeTitle];
    [placeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tableView);
        make.top.equalTo(tableView).offset(20);
    }];
    
    AYInsetLabel *positionLabel = [[AYInsetLabel alloc]init];
    positionLabel.text  = @"位置";
    positionLabel.textInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    positionLabel.textColor = [Tools blackColor];
    positionLabel.font = kAYFontLight(14.f);
    positionLabel.backgroundColor = [UIColor whiteColor];
    [tableView addSubview:positionLabel];
    [positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(placeTitle.mas_bottom).offset(20);
        make.centerX.equalTo(tableView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 42));
    }];
    positionLabel.userInteractionEnabled = YES;
    [positionLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPositionLabelTap)]];
    
    addressLabel = [Tools creatUILabelWithText:@"场地地址" andTextColor:[Tools themeColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
    [tableView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(positionLabel).offset(-15);
        make.centerY.equalTo(positionLabel);
    }];
    
    NSString *addressStr = [service_info objectForKey:kAYServiceArgsAddress];
    if (addressStr) {
        addressLabel.text = addressStr;
    }
    
    AYInsetLabel *facilityLabel = [[AYInsetLabel alloc]init];
    facilityLabel.text = @"场地友好性";
    facilityLabel.textInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    facilityLabel.textColor = [Tools blackColor];
    facilityLabel.font = kAYFontLight(14.f);
    facilityLabel.backgroundColor = [UIColor whiteColor];
    [tableView addSubview:facilityLabel];
    [facilityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(positionLabel.mas_bottom).offset(20);
        make.centerX.equalTo(tableView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 42));
    }];
    facilityLabel.userInteractionEnabled = YES;
    [facilityLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didFacilityLabelTap)]];
    
    UIImageView *access = [[UIImageView alloc]init];
    [tableView addSubview:access];
    access.image = IMGRESOURCE(@"plan_time_icon");
    [access mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(facilityLabel.mas_right).offset(-15);
        make.centerY.equalTo(facilityLabel);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    UILabel *detailTitle = [Tools creatUILabelWithText:@"详情" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    [tableView addSubview:detailTitle];
    [detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tableView);
        make.top.equalTo(facilityLabel.mas_bottom).offset(25);
    }];
    
    AYInsetLabel *infoLabel = [[AYInsetLabel alloc]init];
    infoLabel.text = @"服务详情";
    infoLabel.textInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    infoLabel.textColor = [Tools blackColor];
    infoLabel.font = kAYFontLight(14.f);
    infoLabel.backgroundColor = [UIColor whiteColor];
    [tableView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailTitle.mas_bottom).offset(20);
        make.centerX.equalTo(tableView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 42));
    }];
    infoLabel.userInteractionEnabled = YES;
    [infoLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didInfoLabelTap)]];
    
    UIImageView *access2 = [[UIImageView alloc]init];
    [self.view addSubview:access2];
    access2.image = IMGRESOURCE(@"plan_time_icon");
    [access2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(infoLabel.mas_right).offset(-15);
        make.centerY.equalTo(infoLabel);
        make.size.mas_equalTo(CGSizeMake(15, 15));
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
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_title = [bar.commands objectForKey:@"setTitleText:"];
    NSString *title = @"更多信息";
    [cmd_title performWithResult:&title];
    
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    NSNumber *isHidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &isHidden)
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
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
    [tmp setValue:[service_info objectForKey:kAYServiceArgsTheme] forKey:kAYServiceArgsTheme];
    
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
        [dic_info setValue:kAYServiceArgsServiceInfo forKey:@"key"];
        [dic_info setValue:service_info forKey:kAYServiceArgsServiceInfo];
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
    [dic_info setValue:kAYServiceArgsServiceInfo forKey:@"key"];
    [dic_info setValue:service_info forKey:kAYServiceArgsServiceInfo];
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

@end
