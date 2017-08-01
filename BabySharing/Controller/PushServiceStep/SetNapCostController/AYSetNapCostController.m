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

#import "AYInsetLabel.h"
#import "AYServiceArgsDefines.h"

#define STATUS_BAR_HEIGHT           20
#define FAKE_BAR_HEIGHT             44
#define LIMITNUMB                   228
#define kTableFrameY                218

@implementation AYSetNapCostController{
    
    UITextField *costTextField;
    UITextField *timeTextField;
    NSString *setedCostString;
    
    int course_duration;
    ServiceType service_type;
    
    NSInteger currentNumbCount;
    
    CGFloat setY;
    UIButton *plusBtn;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary *dic_cost = [dic objectForKey:kAYControllerChangeArgsKey];
        if (dic_cost) {
            setedCostString = [dic_cost objectForKey:kAYServiceArgsPrice];
            service_type = ((NSNumber*)[dic_cost objectForKey:kAYServiceArgsCat]).intValue;
            
            if (service_type == ServiceTypeCourse) {
                NSNumber *count_note =  [dic_cost objectForKey:kAYServiceArgsLeastTimes];
                currentNumbCount = count_note.integerValue;
                course_duration = ((NSNumber*)[dic_cost objectForKey:kAYServiceArgsCourseduration]).intValue;
                
            } else if(service_type == ServiceTypeNursery) {
                
                NSNumber *count_note = [dic_cost objectForKey:kAYServiceArgsLeastHours];
                currentNumbCount = count_note.integerValue;
            }
            
        }
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UILabel *titleLabel = [Tools creatUILabelWithText:@"标题" andTextColor:[Tools themeColor] andFontSize:620.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(80);
		make.left.equalTo(self.view).offset(20);
	}];
	
	CGFloat insetLabelHeight = 64.f;
    AYInsetLabel *h1 = [[AYInsetLabel alloc]initWithTitle:@"" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:[Tools whiteColor]];
    h1.textInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.view addSubview:h1];
    [h1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel).offset(35);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 40, insetLabelHeight));
    }];
	
    costTextField = [[UITextField alloc]init];
    [self.view addSubview:costTextField];
    costTextField.font = [UIFont boldSystemFontOfSize:16.f];
    costTextField.textColor = [Tools themeColor];
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
    
    UILabel *RMBSign = [Tools creatUILabelWithText:@"元" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:RMBSign];
    [RMBSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(h1);
        make.right.equalTo(h1).offset(-15);
    }];
    
    /***************************************/
    AYInsetLabel *h3 = [[AYInsetLabel alloc]initWithTitle:@"单次最少预定时长" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:[Tools whiteColor]];
    h3.textInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.view addSubview:h3];
	
	UILabel *iconLael = [Tools creatUILabelWithText:@"小时" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
    [self.view addSubview:iconLael];
    [iconLael mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(h3);
        make.right.equalTo(h3).offset(-15);
    }];
	
	CGFloat btnWH = 32.f;
    plusBtn = [[UIButton alloc]init];
    if (!currentNumbCount || currentNumbCount == 0) {
		currentNumbCount = 1;
    }
    [plusBtn setTitle:[NSString stringWithFormat:@"%d",(int)currentNumbCount] forState:UIControlStateNormal];
	[Tools setViewBorder:plusBtn withRadius:btnWH*0.5 andBorderWidth:0 andBorderColor:nil andBackground:[Tools themeColor]];
    plusBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [plusBtn setTitleColor:[Tools whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:plusBtn];
    [plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconLael);
        make.right.equalTo(iconLael.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(btnWH, btnWH));
    }];
    [plusBtn addTarget:self action:@selector(didPlusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *minusBtn = [[UIButton alloc]init];
    CALayer *minusLayer = [CALayer layer];
    minusLayer.frame = CGRectMake(0, 0, btnWH * 0.6, 2);
    minusLayer.position = CGPointMake(btnWH * 0.5, btnWH * 0.5);
    minusLayer.backgroundColor = [Tools themeColor].CGColor;
    [minusBtn.layer addSublayer:minusLayer];
    [self.view addSubview:minusBtn];
    [minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(plusBtn);
        make.right.equalTo(plusBtn.mas_left).offset(-10);
        make.size.equalTo(plusBtn);
    }];
    [minusBtn addTarget:self action:@selector(didMinusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
	[Tools creatCALayerWithFrame:CGRectMake(20, 115, SCREEN_WIDTH - 20 * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:self.view];
	
    NSString *titleStr;
    switch (service_type) {
            case ServiceTypeNursery:
        {
            h1.text = @"每小时价格";
            titleStr = @"看顾价格";
            
            [h3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(h1.mas_bottom).offset(1);
                make.centerX.equalTo(h1);
                make.size.equalTo(h1);
            }];
			
			[Tools creatCALayerWithFrame:CGRectMake(20, 115 + insetLabelHeight, SCREEN_WIDTH - 20 * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:self.view];
			[Tools creatCALayerWithFrame:CGRectMake(20, 115 + insetLabelHeight * 2, SCREEN_WIDTH - 20 * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:self.view];
        }
            break;
            case ServiceTypeCourse:
        {
            h1.text = @"单次课程价格";
            titleStr = @"课程价格";
            
            AYInsetLabel *h2 = [[AYInsetLabel alloc]initWithTitle:@"课程时长" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:[Tools whiteColor]];
            h2.textInsets = UIEdgeInsetsMake(0, 5, 0, 0);
            [self.view addSubview:h2];
            [h2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(h1.mas_bottom).offset(1);
                make.centerX.equalTo(self.view);
                make.size.equalTo(h1);
            }];
            
            timeTextField = [[UITextField alloc]init];
            [self.view addSubview:timeTextField];
            timeTextField.font = [UIFont boldSystemFontOfSize:16.f];
            timeTextField.textColor = [Tools themeColor];
            timeTextField.textAlignment = NSTextAlignmentRight;
            timeTextField.keyboardType = UIKeyboardTypeNumberPad;
            [timeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(h2).insets(UIEdgeInsetsMake(0, 115, 0, 50));
            }];
            if (course_duration != 0) {
                NSString *duration = [NSString stringWithFormat:@"%d", course_duration];
                timeTextField.text = duration;
            }
            
            UILabel *TIMESign = [Tools creatUILabelWithText:@"分钟" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
            [self.view addSubview:TIMESign];
            [TIMESign mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(h2);
                make.right.equalTo(h2).offset(-15);
            }];
            
            /*********************/
            h3.text = @"最少预定次数";
            iconLael.text = @"次";
            [h3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(h2.mas_bottom);
                make.centerX.equalTo(h1);
                make.size.equalTo(h1);
            }];
			
			[Tools creatCALayerWithFrame:CGRectMake(20, 115 + insetLabelHeight, SCREEN_WIDTH - 20 * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:self.view];
			[Tools creatCALayerWithFrame:CGRectMake(20, 115 + insetLabelHeight * 2, SCREEN_WIDTH - 20 * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:self.view];
			[Tools creatCALayerWithFrame:CGRectMake(20, 115 + insetLabelHeight * 3, SCREEN_WIDTH - 20 * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:self.view];
        }
            break;
        default:
            break;
    }
    
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &titleStr)
	titleLabel.text = titleStr;
    
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
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"保存" andTitleColor:[Tools themeColor] andFontSize:16.f andBackgroundColor:nil];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
    
//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, kTableFrameY, SCREEN_WIDTH, SCREEN_HEIGHT - kTableFrameY);
    return nil;
}

#pragma mark -- actions
- (void)didPlusBtnClick:(UIButton*)btn {
    if (currentNumbCount == 8) {
//        id<AYViewBase> view_tip = VIEW(@"AlertTip", @"AlertTip");
//        id<AYCommand> cmd_add = [view_tip.commands objectForKey:@"setAlertTipInfo:"];
//        NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
//        [args setValue:self.view forKey:@"super_view"];
//        [args setValue:@"最少预定时长最多暂支持8个小时" forKey:@"title"];
//        [args setValue:[NSNumber numberWithFloat:SCREEN_HEIGHT * 0.5] forKey:@"set_y"];
//        [cmd_add performWithResult:&args];
        
        NSString *title = @"最少预定时长最多暂支持8个小时";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        
        return;
    }
    currentNumbCount ++;
    [plusBtn setTitle:[NSString stringWithFormat:@"%ld", currentNumbCount] forState:UIControlStateNormal];
}

- (void)didMinusBtnClick:(UIButton*)btn {
    if (currentNumbCount == 1) {
        return;
    }
    currentNumbCount --;
    [plusBtn setTitle:[NSString stringWithFormat:@"%ld", currentNumbCount] forState:UIControlStateNormal];
}


- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {
    NSLog(@"tap esle where");
	if ([costTextField isFirstResponder]) {
		[costTextField resignFirstResponder];
	}
	if ([timeTextField isFirstResponder]) {
		[timeTextField resignFirstResponder];
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
    
//    if (!costTextField.text || [costTextField.text isEqualToString:@""] || !timeTextField.text || [timeTextField.text isEqualToString:@""]) {
//        NSString *title = @"参数缺省";
//        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
//        return nil;
//    }
    
    //整合数据
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
    [dic_info setValue:[NSNumber numberWithFloat:costTextField.text.floatValue] forKey:kAYServiceArgsPrice];
    [dic_info setValue:[NSNumber numberWithFloat:timeTextField.text.floatValue] forKey:kAYServiceArgsCourseduration];
    
    if (service_type == ServiceTypeNursery) {
        [dic_info setValue:[NSNumber numberWithInteger:currentNumbCount] forKey:kAYServiceArgsLeastHours];
    }
    else if (service_type == ServiceTypeCourse) {
        [dic_info setValue:[NSNumber numberWithInteger:currentNumbCount] forKey:kAYServiceArgsLeastTimes];
    }
    
    [dic_info setValue:@"nap_cost" forKey:@"key"];
    
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
    [costTextField resignFirstResponder];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

@end
