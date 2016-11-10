//
//  AYSetNapAgesController.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetNapAgesController.h"
#import "AYViewBase.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYInsetLabel.h"

#define STATUS_BAR_HEIGHT           20
#define FAKE_BAR_HEIGHT             44
#define SHOW_OFFSET_Y               SCREEN_HEIGHT - 196
#define childNumbLimit                  8
#define waiterNumbLimit                 8

@implementation AYSetNapAgesController{
    
    UILabel *boundaryLabel;
    UIButton *plusBtn;
    UIButton *plusWaiterBtn;
    
    NSDictionary *setedAgesData;
    NSInteger countChild;
    NSInteger countWaiter;
    
    UIView *picker;
    NSNumber *usl;
    NSNumber *lsl;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary *age_dic = [dic objectForKey:kAYControllerChangeArgsKey];
        if (age_dic) {
            setedAgesData = [age_dic objectForKey:@"age_boundary"];
            countChild = ((NSNumber*)[age_dic objectForKey:@"capacity"]).integerValue;
//            countWaiter
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
    
    {
        id<AYViewBase> view_picker = [self.views objectForKey:@"Picker"];
        picker = (UIView*)view_picker;
        [self.view bringSubviewToFront:picker];
        id<AYCommand> cmd_datasource = [view_picker.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_picker.commands objectForKey:@"registerDelegate:"];
        
        id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"SetNapAges"];
        
        id obj = (id)cmd_recommend;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_recommend;
        [cmd_delegate performWithResult:&obj];
    }
    
    AYInsetLabel *h1 = [[AYInsetLabel alloc]init];
    h1.text = @"服务适合孩子年龄";
    h1.textInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    h1.textColor = [Tools blackColor];
    h1.font = kAYFontLight(14.f);
    h1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:h1];
    [h1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(124);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 50, 42));
    }];
    
    boundaryLabel = [[UILabel alloc]init];
    boundaryLabel = [Tools setLabelWith:boundaryLabel andText:@"岁" andTextColor:[Tools themeColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
    if (setedAgesData) {
        NSNumber *usl_numb = ((NSNumber *)[setedAgesData objectForKey:@"usl"]);
        NSNumber *lsl_numb = ((NSNumber *)[setedAgesData objectForKey:@"lsl"]);
        NSString *ages = [NSString stringWithFormat:@"%d ~ %d 岁", lsl_numb.intValue, usl_numb.intValue];
        boundaryLabel.text = ages;
    }
    [self.view addSubview:boundaryLabel];
    [boundaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(h1);
        make.right.equalTo(h1).offset(-15);
    }];
    h1.userInteractionEnabled = YES;
    [h1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setNapBabyAgesClick:)]];
    
    /***************************************/
    AYInsetLabel *h3 = [[AYInsetLabel alloc]init];
    h3.text = @"最多接纳孩子数量";
    h3.textInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    h3.textColor = [Tools blackColor];
    h3.font = kAYFontLight(14.f);
    h3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:h3];
    [h3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(h1.mas_bottom).offset(12);
        make.centerX.equalTo(h1);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 50, 42));
    }];
    
    UILabel *iconLael = [[UILabel alloc]init];
    iconLael = [Tools setLabelWith:iconLael andText:@"个" andTextColor:[Tools themeColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
    [self.view addSubview:iconLael];
    [iconLael mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(h3);
        make.right.equalTo(h3).offset(-15);
    }];
    
    plusBtn = [[UIButton alloc]init];
    if (!countChild || countChild == 0) {
        countChild = 1;
    }
    [plusBtn setTitle:[NSString stringWithFormat:@"%ld",countChild] forState:UIControlStateNormal];
    plusBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [plusBtn setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    plusBtn.layer.borderColor = [Tools themeColor].CGColor;
    plusBtn.layer.borderWidth = 1.f;
    [self.view addSubview:plusBtn];
    [plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconLael);
        make.right.equalTo(iconLael.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [plusBtn addTarget:self action:@selector(didPlusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *minusBtn = [[UIButton alloc]init];
    CALayer *minusLayer = [CALayer layer];
    minusLayer.frame = CGRectMake(0, 0, 12, 1);
    minusLayer.position = CGPointMake(12, 12);
    minusLayer.backgroundColor = [Tools themeColor].CGColor;
    [minusBtn.layer addSublayer:minusLayer];
    [self.view addSubview:minusBtn];
    [minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(plusBtn);
        make.right.equalTo(plusBtn.mas_left).offset(-10);
        make.size.equalTo(plusBtn);
    }];
    [minusBtn addTarget:self action:@selector(didMinusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    /***************************************/
    
    AYInsetLabel *waiterLabel = [[AYInsetLabel alloc]init];
    waiterLabel.text = @"服务者数量";
    waiterLabel.textInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    waiterLabel.textColor = [Tools blackColor];
    waiterLabel.font = kAYFontLight(14.f);
    waiterLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:waiterLabel];
    [waiterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(h3.mas_bottom).offset(1);
        make.centerX.equalTo(h1);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 50, 42));
    }];
    
    UILabel *waiterNumbSign = [Tools creatUILabelWithText:@"个" andTextColor:[Tools themeColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
    [self.view addSubview:waiterNumbSign];
    [waiterNumbSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(waiterLabel);
        make.right.equalTo(waiterLabel).offset(-15);
    }];
    
    plusWaiterBtn = [[UIButton alloc]init];
    if (!countWaiter || countWaiter == 0) {
        countWaiter = 1;
    }
    [plusWaiterBtn setTitle:[NSString stringWithFormat:@"%ld",countWaiter] forState:UIControlStateNormal];
    plusWaiterBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [plusWaiterBtn setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    plusWaiterBtn.layer.borderColor = [Tools themeColor].CGColor;
    plusWaiterBtn.layer.borderWidth = 1.f;
    [self.view addSubview:plusWaiterBtn];
    [plusWaiterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(waiterNumbSign);
        make.right.equalTo(waiterNumbSign.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [plusWaiterBtn addTarget:self action:@selector(didPlusWaiterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *minusWaiterBtn = [[UIButton alloc]init];
    CALayer *minusLayer2 = [CALayer layer];
    minusLayer2.frame = CGRectMake(0, 0, 12, 1);
    minusLayer2.position = CGPointMake(12, 12);
    minusLayer2.backgroundColor = [Tools themeColor].CGColor;
    [minusWaiterBtn.layer addSublayer:minusLayer2];
    [self.view addSubview:minusWaiterBtn];
    [minusWaiterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(plusWaiterBtn);
        make.right.equalTo(plusWaiterBtn.mas_left).offset(-10);
        make.size.equalTo(plusWaiterBtn);
    }];
    [minusWaiterBtn addTarget:self action:@selector(didMinusWaiterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_title = [bar.commands objectForKey:@"setTitleText:"];
    NSString *title = @"孩子年龄";
    [cmd_title performWithResult:&title];
    
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
    
    id<AYCommand> cmd_bot = [bar.commands objectForKey:@"setBarBotLine"];
    [cmd_bot performWithResult:nil];
    
    return nil;
}

- (id)PickerLayout:(UIView*)view{
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
    view.backgroundColor = [Tools garyColor];
    return nil;
}


- (void)setNapBabyAgesClick:(UIGestureRecognizer*)tap {
    id<AYViewBase> view_picker = [self.views objectForKey:@"Picker"];
    id<AYCommand> cmd_show = [view_picker.commands objectForKey:@"showPickerView"];
    [cmd_show performWithResult:nil];
}

#pragma mark -- actions
- (void)didPlusBtnClick:(UIButton*)btn {
    if (countChild == childNumbLimit) {
        NSString *title = @"服务同时最多接纳8个孩子";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        return;
    }
    countChild ++;
    [plusBtn setTitle:[NSString stringWithFormat:@"%ld",countChild] forState:UIControlStateNormal];
}

- (void)didMinusBtnClick:(UIButton*)btn {
    if (countChild == 1) {
        return;
    }
    countChild --;
    [plusBtn setTitle:[NSString stringWithFormat:@"%ld",countChild] forState:UIControlStateNormal];
}

- (void)didPlusWaiterBtnClick:(UIButton*)btn {
//    if (countWaiter == waiterNumbLimit) {
//        return;
//    }
    countWaiter ++;
    [plusWaiterBtn setTitle:[NSString stringWithFormat:@"%ld",countWaiter] forState:UIControlStateNormal];
}

- (void)didMinusWaiterBtnClick:(UIButton*)btn {
    if (countWaiter == 1) {
        return;
    }
    countWaiter --;
    [plusWaiterBtn setTitle:[NSString stringWithFormat:@"%ld",countWaiter] forState:UIControlStateNormal];
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
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSMutableDictionary *dic_info = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary *sl_dic = [[NSMutableDictionary alloc]init];
    
    if (usl && lsl) {
        [sl_dic setValue:usl forKey:@"usl"];
        [sl_dic setValue:lsl forKey:@"lsl"];
    } else if(setedAgesData){
        sl_dic = [setedAgesData mutableCopy];
    } else {
        NSString *title = @"您还没有设置孩子年龄阶段";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        return nil;
    }
    
    [dic_info setValue:@"nap_ages" forKey:@"key"];
    [dic_info setValue:sl_dic forKey:@"age_boundary"];
    NSString *chilrenNumb = plusBtn.titleLabel.text;
    [dic_info setValue:[NSNumber numberWithInt:chilrenNumb.intValue] forKey:@"capacity"];
    
    NSString *waiterNumb = plusBtn.titleLabel.text;
    [dic_info setValue:[NSNumber numberWithInt:waiterNumb.intValue] forKey:@"capacity_waiter"];
    
    [dic setValue:dic_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    return nil;
}

- (id)didSaveClick {
    id<AYDelegateBase> cmd_commend = [self.delegates objectForKey:@"SetNapAges"];
    id<AYCommand> cmd_index = [cmd_commend.commands objectForKey:@"queryCurrentSelected:"];
    NSDictionary *dic = nil;
    [cmd_index performWithResult:&dic];
    
    if (dic) {
        usl = ((NSNumber *)[dic objectForKey:@"usl"]);
        lsl = ((NSNumber *)[dic objectForKey:@"lsl"]);
        NSString *ages = [NSString stringWithFormat:@"%d ~ %d 岁",lsl.intValue,usl.intValue];
        boundaryLabel.text = ages;
    }
    
//    if (picker.frame.origin.y == SHOW_OFFSET_Y) {
//        [UIView animateWithDuration:0.25 animations:^{
//            picker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
//        }];
//    }
    
    return nil;
}
- (id)didCancelClick {
//    if (picker.frame.origin.y == SHOW_OFFSET_Y) {
//        [UIView animateWithDuration:0.25 animations:^{
//            picker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
//        }];
//    }
    return nil;
}

- (id)startRemoteCall:(id)obj {
    return nil;
}
@end
