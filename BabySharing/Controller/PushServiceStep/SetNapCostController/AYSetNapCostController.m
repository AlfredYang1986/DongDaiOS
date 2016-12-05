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

#import "OptionOfPlayingView.h"
#import "AYInsetLabel.h"
#import "AYServiceArgsDefines.h"

#define STATUS_BAR_HEIGHT           20
#define FAKE_BAR_HEIGHT             44
#define LIMITNUMB                   228
#define kTableFrameY                218

@interface AYSetNapCostController ()<UITextViewDelegate>

@end

@implementation AYSetNapCostController{
    
    UITextField *costTextField;
    UITextField *timeTextField;
    NSString *setedCostString;
    
    NSInteger course_duration;
    ServiceType service_type;
    
    NSInteger least_hours;
    
    CGFloat setY;
    UIButton *plusBtn;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary *dic_cost = [dic objectForKey:kAYControllerChangeArgsKey];
        if (dic_cost) {
            setedCostString = [dic_cost objectForKey:@"price"];
            least_hours = ((NSNumber*)[dic_cost objectForKey:@"least_hours"]).integerValue;
            course_duration = ((NSNumber*)[dic_cost objectForKey:kAYServiceArgsCourseduration]).integerValue;
            service_type = ((NSNumber*)[dic_cost objectForKey:kAYServiceArgsServiceCat]).intValue;
        }
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    AYInsetLabel *h1 = [[AYInsetLabel alloc]init];
    h1.textInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    h1.textColor = [Tools blackColor];
    h1.font = kAYFontLight(14.f);
    h1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:h1];
    [h1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(124);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 42));
    }];
    
    costTextField = [[UITextField alloc]init];
    [self.view addSubview:costTextField];
    costTextField.font = kAYFontLight(14.f);
    costTextField.textColor = [Tools blackColor];
    costTextField.textAlignment = NSTextAlignmentRight;
    costTextField.keyboardType = UIKeyboardTypeNumberPad;
    //    costTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [costTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(h1).insets(UIEdgeInsetsMake(0, 115, 0, 35));
    }];
    if (setedCostString) {
        NSString *price = [NSString stringWithFormat:@"%@",setedCostString];
        costTextField.text = price;
    }
    
    UILabel *RMBSign = [Tools creatUILabelWithText:@"元" andTextColor:[Tools themeColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:RMBSign];
    [RMBSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(h1);
        make.right.equalTo(h1).offset(-15);
    }];
    
    NSString *titleStr;
    
    switch (service_type) {
            case ServiceTypeLookAfter:
        {
            h1.text = @"每小时价格";
            titleStr = @"看顾价格";
        }
            break;
            case ServiceTypeCourse:
        {
            h1.text = @"单次课程价格";
            titleStr = @"课程价格";
            
            AYInsetLabel *h2 = [[AYInsetLabel alloc]init];
            h2.text = @"课程时长";
            h2.textInsets = UIEdgeInsetsMake(0, 15, 0, 0);
            h2.textColor = [Tools blackColor];
            h2.font = kAYFontLight(14.f);
            h2.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:h2];
            [h2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(h1.mas_bottom).offset(20);
                make.centerX.equalTo(self.view);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, 42));
            }];
            
            timeTextField = [[UITextField alloc]init];
            [self.view addSubview:timeTextField];
            timeTextField.font = kAYFontLight(14.f);
            timeTextField.textColor = [Tools blackColor];
            timeTextField.textAlignment = NSTextAlignmentRight;
            timeTextField.keyboardType = UIKeyboardTypeNumberPad;
            [timeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(h2).insets(UIEdgeInsetsMake(0, 115, 0, 50));
            }];
            if (course_duration != 0) {
                NSString *duration = [NSString stringWithFormat:@"%ld",course_duration];
                timeTextField.text = duration;
            }
            
            UILabel *TIMESign = [Tools creatUILabelWithText:@"分钟" andTextColor:[Tools themeColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
            [self.view addSubview:TIMESign];
            [TIMESign mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(h2);
                make.right.equalTo(h2).offset(-15);
            }];
        }
            break;
        default:
            break;
    }
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &titleStr)
    
//    AYInsetLabel *h3 = [[AYInsetLabel alloc]init];
//    h3.text = @"最少预定时长";
//    h3.textInsets = UIEdgeInsetsMake(0, 15, 0, 0);
//    h3.textColor = [Tools blackColor];
//    h3.font = kAYFontLight(14.f);
//    h3.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:h3];
//    [h3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(h1.mas_bottom).offset(15);
//        make.centerX.equalTo(h1);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 50, 42));
//    }];
//    
//    /***************************************/
//    UILabel *iconLael = [[UILabel alloc]init];
//    iconLael = [Tools setLabelWith:iconLael andText:@"小时" andTextColor:[Tools themeColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
//    [self.view addSubview:iconLael];
//    [iconLael mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(h3);
//        make.right.equalTo(h3).offset(-15);
//    }];
//    
//    plusBtn = [[UIButton alloc]init];
//    if (!least_hours || least_hours == 0) {
//        least_hours = 1;
//    }
//    [plusBtn setTitle:[NSString stringWithFormat:@"%ld",least_hours] forState:UIControlStateNormal];
//    plusBtn.titleLabel.font = kAYFontLight(12.f);
//    [plusBtn setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
//    plusBtn.layer.borderColor = [Tools themeColor].CGColor;
//    plusBtn.layer.borderWidth = 1.f;
//    [self.view addSubview:plusBtn];
//    [plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(iconLael);
//        make.right.equalTo(iconLael.mas_left).offset(-10);
//        make.size.mas_equalTo(CGSizeMake(24, 24));
//    }];
//    [plusBtn addTarget:self action:@selector(didPlusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *minusBtn = [[UIButton alloc]init];
//    CALayer *minusLayer = [CALayer layer];
//    minusLayer.frame = CGRectMake(0, 0, 12, 1);
//    minusLayer.position = CGPointMake(12, 12);
//    minusLayer.backgroundColor = [Tools themeColor].CGColor;
//    [minusBtn.layer addSublayer:minusLayer];
//    [self.view addSubview:minusBtn];
//    [minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(plusBtn);
//        make.right.equalTo(plusBtn.mas_left).offset(-10);
//        make.size.equalTo(plusBtn);
//    }];
//    [minusBtn addTarget:self action:@selector(didMinusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [costTextField becomeFirstResponder];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, FAKE_BAR_HEIGHT);
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_title = [bar.commands objectForKey:@"setTitleText:"];
    NSString *title = @"价格设置";
    [cmd_title performWithResult:&title];
    
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil];
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
    [cmd_right performWithResult:&bar_right_btn];
    
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
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
- (void)didPlusBtnClick:(UIButton*)btn {
    if (least_hours == 8) {
        id<AYViewBase> view_tip = VIEW(@"AlertTip", @"AlertTip");
        id<AYCommand> cmd_add = [view_tip.commands objectForKey:@"setAlertTipInfo:"];
        NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
        [args setValue:self.view forKey:@"super_view"];
        [args setValue:@"最少预定时长最多暂支持8个小时" forKey:@"title"];
        [args setValue:[NSNumber numberWithFloat:SCREEN_HEIGHT * 0.5] forKey:@"set_y"];
        [cmd_add performWithResult:&args];
        return;
    }
    least_hours ++;
    [plusBtn setTitle:[NSString stringWithFormat:@"%ld",least_hours] forState:UIControlStateNormal];
}

- (void)didMinusBtnClick:(UIButton*)btn {
    if (least_hours == 1) {
        return;
    }
    least_hours --;
    [plusBtn setTitle:[NSString stringWithFormat:@"%ld",least_hours] forState:UIControlStateNormal];
}


- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {
    NSLog(@"tap esle where");
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

//-(id)didOptionBtnClick:(UIButton*)btn{
//    btn.selected = !btn.selected;
//    if (btn.selected) {
//        notePow += pow(2, btn.tag);
//    }else {
//        notePow -= pow(2, btn.tag);
//    }
//    return nil;
//}

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
    
    NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
    [dic_info setValue:costTextField.text forKey:kAYServiceArgsPrice];
//    [dic_info setValue:[NSNumber numberWithInteger:least_hours] forKey:@"least_hours"];
    [dic_info setValue:timeTextField.text forKey:kAYServiceArgsCourseduration];
    [dic_info setValue:@"nap_cost" forKey:@"key"];
    
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    [costTextField resignFirstResponder];
    return nil;
}

@end
