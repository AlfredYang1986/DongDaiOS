//
//  AYEditServiceCapacityController.m
//  BabySharing
//
//  Created by Alfred Yang on 6/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYEditServiceCapacityController.h"
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

@implementation AYEditServiceCapacityController {
    
    NSMutableDictionary *service_info_part;
    
    UILabel *agesNumbLabel;
    UITextField *babyNumb;
    UITextField *servantNumb;
    
    BOOL isAlreadyEnable;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        //        NSDictionary *dic_facility = [dic objectForKey:kAYControllerChangeArgsKey];
        service_info_part = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    {
        id<AYViewBase> view_picker = [self.views objectForKey:@"Picker"];
         UIView* picker = (UIView*)view_picker;
        [self.view bringSubviewToFront:picker];
        id<AYCommand> cmd_datasource = [view_picker.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_picker.commands objectForKey:@"registerDelegate:"];
        
        id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"EditServiceCapacity"];
        
        id obj = (id)cmd_recommend;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_recommend;
        [cmd_delegate performWithResult:&obj];
    }
    
    id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
    UITableView *tableView = (UITableView*)view_notify;
    
    AYInsetLabel *babyAgesTitle = [[AYInsetLabel alloc]initWithTitle:@"接纳孩子年龄" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:[Tools whiteColor]];
    babyAgesTitle.textInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [tableView addSubview:babyAgesTitle];
    [babyAgesTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableView).offset(20);
        make.centerX.equalTo(tableView);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 42));
    }];
    babyAgesTitle.userInteractionEnabled = YES;
    [babyAgesTitle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editBabyAgesClick:)]];
    
    agesNumbLabel = [Tools creatUILabelWithText:@"2岁 - 11岁" andTextColor:[Tools themeColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
    [tableView addSubview:agesNumbLabel];
    [agesNumbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(babyAgesTitle).offset(-15);
        make.centerY.equalTo(babyAgesTitle);
    }];
    
    NSDictionary *dic_ages = [service_info_part objectForKey:kAYServiceArgsAgeBoundary];
    NSNumber *age_lsl = [dic_ages objectForKey:kAYServiceArgsAgeBoundaryLow];
    NSNumber *age_usl = [dic_ages objectForKey:kAYServiceArgsAgeBoundaryUp];
    if (age_lsl && age_usl) {
        agesNumbLabel.text = [NSString stringWithFormat:@"%@岁 - %@岁", age_lsl, age_usl];
    }
    
    /*capacity*/
    AYInsetLabel *babyNumbTitle = [[AYInsetLabel alloc]initWithTitle:@"最多接受孩子数量" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:[Tools whiteColor]];
    babyNumbTitle.textInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [tableView addSubview:babyNumbTitle];
    [babyNumbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(babyAgesTitle.mas_bottom).offset(1);
        make.centerX.equalTo(tableView);
        make.size.equalTo(babyAgesTitle);
    }];
    
    UILabel *babyNumbSign = [Tools creatUILabelWithText:@"个" andTextColor:[Tools themeColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
    [tableView addSubview:babyNumbSign];
    [babyNumbSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(babyNumbTitle).offset(-15);
        make.centerY.equalTo(babyNumbTitle);
    }];
    
    babyNumb = [[UITextField alloc]init];
    babyNumb.textColor = [Tools themeColor];
    babyNumb.font = kAYFontLight(14.f);
    babyNumb.textAlignment = NSTextAlignmentRight;
    babyNumb.keyboardType = UIKeyboardTypeNumberPad;
    babyNumb.delegate = self;
    [tableView addSubview:babyNumb];
    [babyNumb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(babyNumbSign.mas_left).offset(-5);
        make.centerY.equalTo(babyNumbTitle);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    NSNumber *capacityNumb = [service_info_part objectForKey:kAYServiceArgsCapacity];
    if (capacityNumb) {
        babyNumb.text = [NSString stringWithFormat:@"%@", capacityNumb];
    }
    
    /*servant*/
    AYInsetLabel *servantNumbTitle = [[AYInsetLabel alloc]initWithTitle:@"服务者数量" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:[Tools whiteColor]];
    servantNumbTitle.textInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [tableView addSubview:servantNumbTitle];
    [servantNumbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(babyNumbTitle.mas_bottom).offset(1);
        make.centerX.equalTo(tableView);
        make.size.equalTo(babyAgesTitle);
    }];
    
    UILabel *servantNumbSign = [Tools creatUILabelWithText:@"个" andTextColor:[Tools themeColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
    [tableView addSubview:servantNumbSign];
    [servantNumbSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(servantNumbTitle).offset(-15);
        make.centerY.equalTo(servantNumbTitle);
    }];
    
    servantNumb = [[UITextField alloc]init];
    servantNumb.textColor  = [Tools themeColor];
    servantNumb.font  = kAYFontLight(14.f);
    servantNumb.textAlignment  = NSTextAlignmentRight;
//    servantNumb.keyboardType  = UIKeyboardTypeNumberPad;
    servantNumb.delegate = self;
    [tableView addSubview:servantNumb];
    [servantNumb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(servantNumbSign.mas_left).offset(-5);
        make.centerY.equalTo(servantNumbTitle);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    NSNumber *servant_no = [service_info_part objectForKey:kAYServiceArgsServantNumb];
    if (servant_no) {
        servantNumb.text = [NSString stringWithFormat:@"%@", servant_no];
    }
    
    /*categary*/
    AYInsetLabel *serviceCatTitle = [[AYInsetLabel alloc]initWithTitle:@"服务类型" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:[Tools whiteColor]];
    serviceCatTitle.textInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [tableView addSubview:serviceCatTitle];
    [serviceCatTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(servantNumbTitle.mas_bottom).offset(30);
        make.centerX.equalTo(tableView);
        make.size.equalTo(babyAgesTitle);
    }];
    
    UILabel *serCatLabel = [Tools creatUILabelWithText:@"服务类型" andTextColor:[Tools themeColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
    [tableView addSubview:serCatLabel];
    [serCatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(serviceCatTitle);
        make.right.equalTo(serviceCatTitle).offset(-15);
    }];
    
    /*theme*/
    AYInsetLabel *serviceThemeTitle = [[AYInsetLabel alloc]initWithTitle:@"服务主题" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:[Tools whiteColor]];
    serviceThemeTitle.textInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [tableView addSubview:serviceThemeTitle];
    [serviceThemeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(serviceCatTitle.mas_bottom).offset(30);
        make.centerX.equalTo(tableView);
        make.size.equalTo(babyAgesTitle);
    }];
    
    UILabel *serThemeLabel = [Tools creatUILabelWithText:@"服务主题" andTextColor:[Tools themeColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
    [tableView addSubview:serThemeLabel];
    [serThemeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(serviceThemeTitle);
        make.right.equalTo(serviceThemeTitle).offset(-15);
    }];
    
    NSString *catStr;
    NSArray *options_title_cans;
    NSNumber *args_cat = [service_info_part objectForKey:kAYServiceArgsServiceCat];
    NSNumber *cans = [service_info_part objectForKey:kAYServiceArgsTheme];
    if (args_cat.intValue == ServiceTypeLookAfter) {
        catStr = @"看顾服务";
        options_title_cans = kAY_service_options_title_lookafter;
    }
    else if (args_cat.intValue == ServiceTypeCourse) {
        catStr = @"课程";
        options_title_cans = kAY_service_options_title_course;
    }
    
    serCatLabel.text = catStr;
    long options = cans.longValue;
    for (int i = 0; i < options_title_cans.count; ++i) {
        long note_pow = pow(2, i);
        if ((options & note_pow)) {
            serThemeLabel.text = [NSString stringWithFormat:@"%@",options_title_cans[i]];
            break;
        }
    }//
    
    babyNumbTitle.userInteractionEnabled = YES;
    servantNumbTitle.userInteractionEnabled = YES;
    
    [babyNumbTitle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBabyNumbTitle:)]];
    [servantNumbTitle addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapServantNumbTitle:)]];
    
    tableView.userInteractionEnabled = YES;
    [tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTableViewElseWhere:)]];
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
    NSString *title = @"服务详情";
    [cmd_title performWithResult:&title];
    
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools garyColor] andFontSize:16.f andBackgroundColor:nil];
    bar_right_btn.userInteractionEnabled = NO;
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    CGFloat margin = 0;
    view.frame = CGRectMake(margin, 64, SCREEN_WIDTH - margin * 2, SCREEN_HEIGHT - 64);
    //    ((UITableView*)view).contentInset = UIEdgeInsetsMake(SCREEN_HEIGHT - 64, 0, 0, 0);
    return nil;
}

- (id)PickerLayout:(UIView*)view{
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, view.bounds.size.height);
    return nil;
}

#pragma mark -- actions
- (void)tapTableViewElseWhere:(UITapGestureRecognizer*)tap {
    [babyNumb resignFirstResponder];
    [servantNumb resignFirstResponder];
}

- (void)editBabyAgesClick:(UIGestureRecognizer*)tap {
    [self tapTableViewElseWhere:nil];
    kAYViewsSendMessage(kAYPickerView, kAYPickerShowViewMessage, nil)
}

- (void)tapBabyNumbTitle:(UIGestureRecognizer*)tap {
    [babyNumb becomeFirstResponder];
}

- (void)tapServantNumbTitle:(UIGestureRecognizer*)tap {
    [servantNumb becomeFirstResponder];
}

#pragma mark -- textfied delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == babyNumb) {
        [service_info_part setValue:[NSNumber numberWithInt:textField.text.intValue] forKey:kAYServiceArgsCapacity];
    }
    else if (textField == servantNumb) {
        [service_info_part setValue:[NSNumber numberWithInt:textField.text.intValue] forKey:kAYServiceArgsServantNumb];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
//    int numb = string.intValue;
//    if (numb == 0) {
//        
//    }
    
    if (!isAlreadyEnable) {
        UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil];
        kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
        isAlreadyEnable = YES;
    }
    return YES;
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
    if ([babyNumb isFirstResponder]) {
        [service_info_part setValue:[NSNumber numberWithInt:babyNumb.text.intValue] forKey:kAYServiceArgsCapacity];
    }
    else if ([servantNumb isFirstResponder]) {
        [service_info_part setValue:[NSNumber numberWithInt:servantNumb.text.intValue] forKey:kAYServiceArgsServantNumb];
    }
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:service_info_part forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)didSaveClick {
    id<AYDelegateBase> cmd_commend = [self.delegates objectForKey:@"EditServiceCapacity"];
    id<AYCommand> cmd_index = [cmd_commend.commands objectForKey:@"queryCurrentSelected:"];
    NSDictionary *dic = nil;
    [cmd_index performWithResult:&dic];
    
    if (dic) {
        NSNumber* usl = ((NSNumber *)[dic objectForKey:kAYServiceArgsAgeBoundaryUp]);
        NSNumber* lsl = ((NSNumber *)[dic objectForKey:kAYServiceArgsAgeBoundaryLow]);
        
        if (usl.intValue < lsl.intValue) {
            NSString *title = @"年龄设置错误";
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            return nil;
        }
        
        [service_info_part setValue:dic forKey:kAYServiceArgsAgeBoundary];
        
        NSString *ages = [NSString stringWithFormat:@"%@ - %@ 岁",lsl, usl];
        agesNumbLabel.text = ages;
        
        if (!isAlreadyEnable) {
            UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil];
            kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
            isAlreadyEnable = YES;
        }
    }
    
    return nil;
}

- (id)didCancelClick {
    //do nothing else ,but be have to invoke this methed
    return nil;
}
@end
