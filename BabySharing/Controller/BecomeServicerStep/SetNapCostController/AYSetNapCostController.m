//
//  AYSetNapCostController.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetNapCostController.h"
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
#define kTableFrameY                218

@interface AYSetNapCostController ()<UITextViewDelegate>

@end

@implementation AYSetNapCostController{
    
    UITextField *costTextField;
    NSString *setedCostString;
    NSString *customString;
    
    UITextField *customField;
    
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
            setedCostString = [dic_cost objectForKey:@"cost"];
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
    
    UILabel *title = [[UILabel alloc]init];
    [self.view addSubview:title];
    title = [Tools setLabelWith:title andText:@"看护价格                    人民币/小时" andTextColor:[Tools blackColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:1];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(104);
        make.centerX.equalTo(self.view);
    }];
    
    costTextField = [[UITextField alloc]init];
    [self.view addSubview:costTextField];
    if (setedCostString) {
        costTextField.text = setedCostString;
    }else costTextField.text = @"100";
    costTextField.textColor = [Tools themeColor];
    costTextField.font = [UIFont systemFontOfSize:14.f];
    costTextField.textAlignment = NSTextAlignmentCenter;
    costTextField.backgroundColor = [UIColor whiteColor];
    costTextField.keyboardType = UIKeyboardTypeNumberPad;
    if (isShow) {
        costTextField.enabled = NO;
    }
    [costTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title);
        make.centerX.equalTo(title).offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    UILabel *h1 = [[UILabel alloc]init];
    h1 = [Tools setLabelWith:h1 andText:@"我能带宝宝干什么？" andTextColor:[Tools garyColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:1];
    [self.view addSubview:h1];
    [h1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(title.mas_bottom).offset(30);
    }];
    UILabel *h2 = [[UILabel alloc]init];
    h2 = [Tools setLabelWith:h2 andText:@"可以提高妈妈看护的价值哦！" andTextColor:[Tools garyColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:1];
    [self.view addSubview:h2];
    [h2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(h1.mas_bottom).offset(6);
    }];
    
//    UIView *line = [[UIView alloc]init];
//    line.backgroundColor = [Tools garyLineColor];
//    [self.view addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(h2.mas_bottom).offset(25);
//        make.centerX.equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
//    }];
    
    {
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
    }
    
//    NSArray *options_title_cans = @[@"看书",@"做瑜伽",@"做蛋糕",@"玩玩具",@"画画"];
//    
//    for (int i = 0; i < options_title_cans.count; ++i) {
//        setY = 35 * i;
//        OptionOfPlayingView *optionView = [[OptionOfPlayingView alloc]initWithTitle:[options_title_cans objectAtIndex:i] andIndex:i];
//        [self.view addSubview:optionView];
//        [optionView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.view);
//            make.top.equalTo(h2.mas_bottom).offset(10 + setY);
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
//        make.top.equalTo(h2.mas_bottom).offset(10 + setY + 45);
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
//    [costTextField becomeFirstResponder];
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
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_title = [bar.commands objectForKey:@"setTitleText:"];
    NSString *title = @"价格设置";
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
    
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, FAKE_BAR_HEIGHT - 0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
    [view.layer addSublayer:line];
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, kTableFrameY, SCREEN_WIDTH, SCREEN_HEIGHT - kTableFrameY);
    
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
    if ([costTextField isFirstResponder]) {
        [costTextField resignFirstResponder];
    }
}

//-(id)didOptionBtnClick:(NSDictionary*)args{
//    
//    int index = ((NSNumber*)[args objectForKey:@"index"]).intValue;
//    BOOL isSelected = ((NSNumber*)[args objectForKey:@"isSelected"]).boolValue;
//    if (isSelected) {
//        notePow += pow(2, index);
//    }else {
//        notePow -= pow(2, index);
//    }
//    return nil;
//}

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
    [dic_options setValue:costTextField.text forKey:@"cost"];
    [dic_options setValue:[NSNumber numberWithLong:notePow] forKey:@"option_pow"];
    [dic_options setValue:customField.text forKey:@"option_custom"];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
    [dic_info setValue:dic_options forKey:@"content"];
    [dic_info setValue:@"nap_cost" forKey:@"key"];
    
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    [costTextField resignFirstResponder];
    return nil;
}

@end
