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
    
    UITextField *customField;
//    NSMutableArray *optionsData;
    long notePow;
    CGFloat setY;
    
    BOOL isShow;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary *dic_cost = [dic objectForKey:kAYControllerChangeArgsKey];
        if (dic_cost) {
//            optionsData = [dic_cost objectForKey:@"options"];
            customString = [dic_cost objectForKey:@"option_custom"];
            notePow = ((NSNumber*)[dic_cost objectForKey:@"option_pow"]).longValue;
            isShow = ((NSNumber*)[dic_cost objectForKey:@"show"]).boolValue;
            
        }
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools garyBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"SetNapCost"];
    
    id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
    
    id obj = (id)cmd_notify;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_notify;
    [cmd_delegate performWithResult:&obj];
    
    id<AYCommand> cmd_cell = [view_notify.commands objectForKey:@"registerCellWithClass:"];
    NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SetNapOptionsCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_cell performWithResult:&class_name];
    
    
    id<AYCommand> cmd_query = [cmd_notify.commands objectForKey:@"queryData:"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    NSArray *options = @[@"安全桌角",@"安全插座",@"急救包",@"无烟",@"安全护栏",@"宠物",@"防摔地板",@"自填"];
    [dic setValue:options forKey:@"title"];
    [dic setValue:[NSNumber numberWithBool:isShow] forKey:@"isShow"];
    if (notePow) {
        NSNumber *numb = [NSNumber numberWithLong:notePow];
        [dic setValue:numb forKey:@"option"];
    }
    if (customString) {
        [dic setValue:customString forKey:@"custom"];
    }
    [cmd_query performWithResult:&dic];
    
//    for (int i = 0; i < options_title_capacity.count; ++i) {
//        setY = 35 * i;
//        OptionOfPlayingView *optionView = [[OptionOfPlayingView alloc]initWithTitle:[options_title_capacity objectAtIndex:i] andIndex:i];
//        [self.view addSubview:optionView];
//        [optionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.view);
//            make.top.equalTo(self.view).offset(84 + setY);
//            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 20, 25));
//        }];
//        optionView.optionBtn.selected = ((notePow & (long)pow(2, i)) != 0);
//        if (isShow) {
//            optionView.optionBtn.userInteractionEnabled = NO;
//        } else
//        [optionView.optionBtn addTarget:self action:@selector(didOptionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    
//    UILabel *customTitle = [[UILabel alloc]init];
//    [self.view addSubview:customTitle];
//    customTitle = [Tools setLabelWith:customTitle andText:@"自填" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
//    [customTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(84 + setY + 45);
//        make.left.equalTo(self.view).offset(20);
//    }];
//    
//    customField = [[UITextField alloc]init];
//    [self.view addSubview:customField];
//    if (customString) {
//        customField.text = customString;
//    }
//    customField.textColor = [Tools blackColor];
//    customField.font = [UIFont systemFontOfSize:14.f];
//    customField.backgroundColor = [UIColor whiteColor];
//    customField.layer.cornerRadius = 4.f;
//    customField.clipsToBounds = YES;
//    UILabel*paddingView= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 30)];
//    paddingView.backgroundColor= [UIColor clearColor];
//    customField.leftView = paddingView;
//    customField.leftViewMode = UITextFieldViewModeAlways;
//    customField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    if (isShow) {
//        customField.enabled = NO;
//    }
//    [customField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(customTitle);
//        make.left.equalTo(self.view).offset(80);
//        make.right.equalTo(self.view).offset(-15);
//        make.height.mas_equalTo(30);
//    }];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere:)];
    [self.view addGestureRecognizer:tap];
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
    view.backgroundColor = [UIColor whiteColor];
    
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, FAKE_BAR_HEIGHT - 0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
    [view.layer addSublayer:line];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_title = [bar.commands objectForKey:@"setTitleText:"];
    NSString *title = @"场地友好设施";
    [cmd_title performWithResult:&title];
    
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    if (isShow) {
        id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnVisibility:"];
        id right = [NSNumber numberWithBool:YES];
        [cmd_right performWithResult:&right];
        
    } else {
    
        UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [bar_right_btn setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
        [bar_right_btn setTitle:@"保存" forState:UIControlStateNormal];
        bar_right_btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [bar_right_btn sizeToFit];
        bar_right_btn.center = CGPointMake(SCREEN_WIDTH - 15.5 - bar_right_btn.frame.size.width / 2, 44 / 2);
        id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
        [cmd_right performWithResult:&bar_right_btn];
    }
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    ((UITableView*)view).backgroundColor = [UIColor clearColor];
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return nil;
}

#pragma mark -- actions
- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {
    NSLog(@"tap esle where");
    if ([customField isFirstResponder]) {
        [customField resignFirstResponder];
    }
}

-(id)didOptionBtnClick:(UIButton*)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        notePow += pow(2, btn.tag);
    }else {
        notePow -= pow(2, btn.tag);
    }
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
    NSMutableDictionary *dic_options = [[NSMutableDictionary alloc]init];
//    [dic_options setValue:optionsData forKey:@"options"];
    [dic_options setValue:[NSNumber numberWithLong:notePow] forKey:@"option_pow"];
    [dic_options setValue:customString forKey:@"option_custom"];
    
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

-(id)textChange:(NSString*)text {
    customString = text;
    return nil;
}

@end
