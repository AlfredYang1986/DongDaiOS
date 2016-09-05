//
//  AYSearchFilterKidsAgesController.m
//  BabySharing
//
//  Created by BM on 9/1/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSearchFilterKidsAgesController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"
#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"

#import "Tools.h"
#import "AYCommandDefines.h"

#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height
#define SHOW_OFFSET_Y           SCREEN_HEIGHT - 196
#define STATUS_HEIGHT           20
#define NAV_HEIGHT              45

#define TEXT_COLOR              [Tools blackColor]

#define CONTROLLER_MARGIN       10.f

#define FIELD_HEIGHT                        80

@implementation AYSearchFilterKidsAgesController {
    id dic_split_value;
    
    UILabel *setAgeslabel;
    NSTimeInterval dob;
    
    UIView *picker;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        dic_split_value = [dic objectForKey:kAYControllerSplitValueKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    UILabel* title = [[UILabel alloc]init];
    title.text = @"您的孩子年龄";
    title.font = [UIFont systemFontOfSize:24.f];
    title.textColor = TEXT_COLOR;
    [title sizeToFit];
    title.frame = CGRectMake(CONTROLLER_MARGIN, STATUS_HEIGHT + NAV_HEIGHT + CONTROLLER_MARGIN, SCREEN_WIDTH - 2 * CONTROLLER_MARGIN, title.frame.size.height);
    
    [self.view addSubview:title];
  
    NSString* str = @"为了筛选更准确的信息，我们会向您咨询一次孩子年龄";
    UIFont* font = [UIFont systemFontOfSize:14.f];
    CGSize sz = [Tools sizeWithString:str withFont:font andMaxSize:CGSizeMake(SCREEN_WIDTH - 2 * CONTROLLER_MARGIN, FLT_MAX)];
    
    UILabel* des = [[UILabel alloc]init];
    des.text = str;
    des.font = font;
    des.textColor = TEXT_COLOR;
    des.numberOfLines = 0;
    des.frame = CGRectMake(CONTROLLER_MARGIN, STATUS_HEIGHT + NAV_HEIGHT + CONTROLLER_MARGIN * 2 + title.frame.size.height, sz.width, sz.height);
    
    [self.view addSubview:des];
   
//    UITextField* field = [[UITextField alloc]init];
//    field.frame = CGRectMake(CONTROLLER_MARGIN, STATUS_HEIGHT + NAV_HEIGHT + CONTROLLER_MARGIN * 4 + title.frame.size.height + sz.height, SCREEN_WIDTH - 2 * CONTROLLER_MARGIN, FIELD_HEIGHT);
//    field.textAlignment = NSTextAlignmentCenter;
    
    setAgeslabel = [[UILabel alloc]init];
    setAgeslabel = [Tools setLabelWith:setAgeslabel andText:@"点击筛选年龄阶段" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:setAgeslabel];
    [setAgeslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(175);
    }];
    
    setAgeslabel.userInteractionEnabled = YES;
    [setAgeslabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setNapBabyAgesClick:)]];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(15.f, 225, SCREEN_WIDTH - 30, 1.0f);
    bottomBorder.backgroundColor = [Tools themeColor].CGColor;
    [self.view.layer addSublayer:bottomBorder];
    
    /**
     * 保存按钮
     */
    UIButton* btn = [[UIButton alloc]init];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(10, SCREEN_HEIGHT - 10 - 45, SCREEN_WIDTH - 2 * 10, 45);
    btn.backgroundColor = [Tools themeColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.layer setCornerRadius:4.f];
    [btn addTarget:self action:@selector(saveBtnSelected) forControlEvents:UIControlEventTouchUpInside];
    
    {
        id<AYViewBase> view_picker = [self.views objectForKey:@"Picker"];
        picker = (UIView*)view_picker;
        [self.view bringSubviewToFront:picker];
        id<AYCommand> cmd_datasource = [view_picker.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_picker.commands objectForKey:@"registerDelegate:"];
        
        id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"SearchFilterKidsAges"];
        
        id obj = (id)cmd_recommend;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_recommend;
        [cmd_delegate performWithResult:&obj];
    }
    
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, STATUS_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, STATUS_HEIGHT, SCREEN_WIDTH, NAV_HEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    {
        UIImage* img = IMGRESOURCE(@"content_close");
        id<AYCommand> cmd = [((id<AYViewBase>)view).commands objectForKey:@"setLeftBtnImg:"];
        [cmd performWithResult:&img];
    }
    return nil;
}

- (id)PickerLayout:(UIView*)view {
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
    view.backgroundColor = [Tools garyColor];
    
    return nil;
}

#pragma mark -- actions
- (void)saveBtnSelected {
    
    id<AYCommand> cmd = POPSPLIT;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopSplitValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_args = [[NSMutableDictionary alloc]init];
    [dic_args setValue:[NSNumber numberWithDouble:dob] forKey:@"dob"];
    [dic setValue:dic_args forKey:kAYControllerChangeArgsKey];
    
    [dic setValue:dic_split_value forKey:kAYControllerSplitValueKey];
    [cmd performWithResult:&dic];
}

- (void)setNapBabyAgesClick:(UIGestureRecognizer*)tap {
    if (picker.frame.origin.y == SCREEN_HEIGHT) {
        [UIView animateWithDuration:0.25 animations:^{
            picker.frame = CGRectMake(0, SHOW_OFFSET_Y, SCREEN_WIDTH, 196);
        }];
    }
}
#pragma mark -- commands
- (id)leftBtnSelected {
    id<AYCommand> cmd = POPSPLIT;
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopSplitValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:dic_split_value forKey:kAYControllerSplitValueKey];
    [cmd performWithResult:&dic];
    
    return nil;
}

- (id)rightBtnSelected {
    // TODO : reset search filter conditions
    return nil;
}

- (id)didSaveClick {
    id<AYDelegateBase> cmd_commend = [self.delegates objectForKey:@"SearchFilterKidsAges"];
    id<AYCommand> cmd_index = [cmd_commend.commands objectForKey:@"queryCurrentSelected:"];
    NSString *args = nil;
    [cmd_index performWithResult:&args];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日"];
    NSTimeZone* timeZone = [NSTimeZone defaultTimeZone];
    [format setTimeZone:timeZone];
    NSDate *filterDate = [format dateFromString:args];
    
    dob = filterDate.timeIntervalSince1970;
    NSTimeInterval now = [NSDate date].timeIntervalSince1970;
    NSTimeInterval howLong = now - dob;
    
    long years = (long)howLong / (86400 * 365);
    long mouths = (long)howLong % (86400 * 365) / (86400 * 30);
    NSString *agesStr = [NSString stringWithFormat:@"%ld岁%ld个月",years,mouths];
    
    if (agesStr) {
        setAgeslabel.text = agesStr;
    }
    if (picker.frame.origin.y == SHOW_OFFSET_Y) {
        [UIView animateWithDuration:0.25 animations:^{
            picker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
        }];
    }
    return nil;
}
- (id)didCancelClick {
    if (picker.frame.origin.y == SHOW_OFFSET_Y) {
        [UIView animateWithDuration:0.25 animations:^{
            picker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
        }];
    }
    
    return nil;
}
@end
