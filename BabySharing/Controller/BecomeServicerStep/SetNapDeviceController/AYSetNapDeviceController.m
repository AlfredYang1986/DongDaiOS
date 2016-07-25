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
#import "AYDongDaSegDefines.h"
#import "AYAlbumDefines.h"
#import "AYRemoteCallDefines.h"
#import "Tools.h"

#import "OptionOfPlayingView.h"

#define STATUS_BAR_HEIGHT           20
#define FAKE_BAR_HEIGHT             44
#define SCREEN_WIDTH                [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT               [UIScreen mainScreen].bounds.size.height
#define LIMITNUMB                   228

@interface AYSetNapDeviceController ()<UITextViewDelegate>

@end

@implementation AYSetNapDeviceController {
    
    NSString *customString;
    
    OptionOfPlayingView *safeDesktopView;
    OptionOfPlayingView *safePlugView;
    OptionOfPlayingView *medPackView;
    OptionOfPlayingView *noSmokeView;
    OptionOfPlayingView *fenceView;
    OptionOfPlayingView *petView;
    OptionOfPlayingView *safeFloorView;
    
    UITextField *customField;
    NSMutableArray *optionsData;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary *dic_cost = [dic objectForKey:kAYControllerChangeArgsKey];
        if (dic_cost) {
            optionsData = [dic_cost objectForKey:@"options"];
            customString = [dic_cost objectForKey:@"option_custom"];
        }
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (!optionsData) {
        optionsData = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
    }
    
    id<AYViewBase> nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYCommand> cmd_nav = [nav.commands objectForKey:@"setBackGroundColor:"];
    UIColor* c_nav = [UIColor clearColor];
    [cmd_nav performWithResult:&c_nav];
    
    
    safeDesktopView = [[OptionOfPlayingView alloc]initWithTitle:@"安全桌角" andIndex:0];
    [self.view addSubview:safeDesktopView];
    [safeDesktopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(84);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 20, 25));
    }];
    safeDesktopView.optionBtn.selected = ((NSNumber*)[optionsData objectAtIndex:0]).boolValue;
    [safeDesktopView.optionBtn addTarget:self action:@selector(didOptionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    safePlugView = [[OptionOfPlayingView alloc]initWithTitle:@"安全插座" andIndex:1];
    [self.view addSubview:safePlugView];
    [safePlugView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(safeDesktopView.mas_bottom).offset(10);
        make.size.equalTo(safeDesktopView);
    }];
    safePlugView.optionBtn.selected = ((NSNumber*)[optionsData objectAtIndex:1]).boolValue;
    [safePlugView.optionBtn addTarget:self action:@selector(didOptionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    medPackView = [[OptionOfPlayingView alloc]initWithTitle:@"急救包" andIndex:2];
    [self.view addSubview:medPackView];
    [medPackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(safePlugView.mas_bottom).offset(10);
        make.size.equalTo(safeDesktopView);
    }];
    medPackView.optionBtn.selected = ((NSNumber*)[optionsData objectAtIndex:2]).boolValue;
    [medPackView.optionBtn addTarget:self action:@selector(didOptionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    noSmokeView = [[OptionOfPlayingView alloc]initWithTitle:@"无烟" andIndex:3];
    [self.view addSubview:noSmokeView];
    [noSmokeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(medPackView.mas_bottom).offset(10);
        make.size.equalTo(safeDesktopView);
    }];
    noSmokeView.optionBtn.selected = ((NSNumber*)[optionsData objectAtIndex:3]).boolValue;
    [noSmokeView.optionBtn addTarget:self action:@selector(didOptionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    fenceView = [[OptionOfPlayingView alloc]initWithTitle:@"安全护栏" andIndex:4];
    [self.view addSubview:fenceView];
    [fenceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(noSmokeView.mas_bottom).offset(10);
        make.size.equalTo(safeDesktopView);
    }];
    fenceView.optionBtn.selected = ((NSNumber*)[optionsData objectAtIndex:4]).boolValue;
    [fenceView.optionBtn addTarget:self action:@selector(didOptionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    petView = [[OptionOfPlayingView alloc]initWithTitle:@"宠物" andIndex:5];
    [self.view addSubview:petView];
    [petView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(fenceView.mas_bottom).offset(10);
        make.size.equalTo(safeDesktopView);
    }];
    petView.optionBtn.selected = ((NSNumber*)[optionsData objectAtIndex:5]).boolValue;
    [petView.optionBtn addTarget:self action:@selector(didOptionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    safeFloorView = [[OptionOfPlayingView alloc]initWithTitle:@"防摔地板" andIndex:6];
    [self.view addSubview:safeFloorView];
    [safeFloorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(petView.mas_bottom).offset(10);
        make.size.equalTo(safeDesktopView);
    }];
    safeFloorView.optionBtn.selected = ((NSNumber*)[optionsData objectAtIndex:6]).boolValue;
    [safeFloorView.optionBtn addTarget:self action:@selector(didOptionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *customTitle = [[UILabel alloc]init];
    [self.view addSubview:customTitle];
    customTitle = [Tools setLabelWith:customTitle andText:@"自填" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    [customTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(safeFloorView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(20);
    }];
    
    customField = [[UITextField alloc]init];
    [self.view addSubview:customField];
    if (customString) {
        customField.text = customString;
    }
    customField.textColor = [Tools blackColor];
    customField.font = [UIFont systemFontOfSize:14.f];
    customField.backgroundColor = [UIColor whiteColor];
    [customField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(customTitle);
        make.left.equalTo(self.view).offset(80);
        make.right.equalTo(self.view).offset(-20);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, FAKE_BAR_HEIGHT);
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, FAKE_BAR_HEIGHT - 0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
    [view.layer addSublayer:line];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [bar_right_btn setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    [bar_right_btn setTitle:@"保存" forState:UIControlStateNormal];
    bar_right_btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [bar_right_btn sizeToFit];
    bar_right_btn.center = CGPointMake(SCREEN_WIDTH - 15.5 - bar_right_btn.frame.size.width / 2, 44 / 2);
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
    [cmd_right performWithResult:&bar_right_btn];
    
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    UILabel* titleView = (UILabel*)view;
    titleView.text = @"场地友好设施";
    titleView.font = [UIFont systemFontOfSize:16.f];
    titleView.textColor = [Tools blackColor];
    [titleView sizeToFit];
    titleView.center = CGPointMake(SCREEN_WIDTH / 2, 44 / 2 + 20);
    return nil;
}

#pragma mark -- actions
-(void)didOptionBtnClick:(UIButton*)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [optionsData replaceObjectAtIndex:btn.tag withObject:[NSNumber numberWithBool:YES]];
    }else {
        [optionsData replaceObjectAtIndex:btn.tag withObject:[NSNumber numberWithBool:NO]];
    }
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
    NSMutableDictionary *dic_options = [[NSMutableDictionary alloc]init];
    [dic_options setValue:optionsData forKey:@"options"];
    [dic_options setValue:customField.text forKey:@"option_custom"];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
    [dic_info setValue:dic_options forKey:@"content"];
    [dic_info setValue:@"nap_device" forKey:@"key"];
    
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    if ([customField isFirstResponder]) {
        [customField resignFirstResponder];
    }
    return nil;
}

- (id)startRemoteCall:(id)obj {
    return nil;
}
@end
