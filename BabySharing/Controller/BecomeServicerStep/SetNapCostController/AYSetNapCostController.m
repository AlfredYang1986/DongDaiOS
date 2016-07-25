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

@interface AYSetNapCostController ()<UITextViewDelegate>

@end

@implementation AYSetNapCostController{
    
    UITextField *costTextField;
    NSString *setedCostString;
    NSString *customString;
    
    OptionOfPlayingView *readBookView;
    OptionOfPlayingView *playYujiaView;
    OptionOfPlayingView *makeCakeView;
    OptionOfPlayingView *playToyView;
    OptionOfPlayingView *drawingView;
    
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
            setedCostString = [dic_cost objectForKey:@"cost"];
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
        optionsData = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
    }
    
    id<AYViewBase> nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYCommand> cmd_nav = [nav.commands objectForKey:@"setBackGroundColor:"];
    UIColor* c_nav = [UIColor clearColor];
    [cmd_nav performWithResult:&c_nav];
    
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
    
    readBookView = [[OptionOfPlayingView alloc]initWithTitle:@"看书" andIndex:0];
    [self.view addSubview:readBookView];
    [readBookView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(h2.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 20, 25));
    }];
    readBookView.optionBtn.selected = ((NSNumber*)[optionsData objectAtIndex:0]).boolValue;
    [readBookView.optionBtn addTarget:self action:@selector(didOptionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    playYujiaView = [[OptionOfPlayingView alloc]initWithTitle:@"做瑜伽" andIndex:1];
    [self.view addSubview:playYujiaView];
    [playYujiaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(readBookView.mas_bottom).offset(10);
        make.size.equalTo(readBookView);
    }];
    playYujiaView.optionBtn.selected = ((NSNumber*)[optionsData objectAtIndex:1]).boolValue;
    [playYujiaView.optionBtn addTarget:self action:@selector(didOptionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    makeCakeView = [[OptionOfPlayingView alloc]initWithTitle:@"做蛋糕" andIndex:2];
    [self.view addSubview:makeCakeView];
    [makeCakeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(playYujiaView.mas_bottom).offset(10);
        make.size.equalTo(readBookView);
    }];
    makeCakeView.optionBtn.selected = ((NSNumber*)[optionsData objectAtIndex:2]).boolValue;
    [makeCakeView.optionBtn addTarget:self action:@selector(didOptionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    playToyView = [[OptionOfPlayingView alloc]initWithTitle:@"玩玩具" andIndex:3];
    [self.view addSubview:playToyView];
    [playToyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(makeCakeView.mas_bottom).offset(10);
        make.size.equalTo(readBookView);
    }];
    playToyView.optionBtn.selected = ((NSNumber*)[optionsData objectAtIndex:3]).boolValue;
    [playToyView.optionBtn addTarget:self action:@selector(didOptionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    drawingView = [[OptionOfPlayingView alloc]initWithTitle:@"画画" andIndex:4];
    [self.view addSubview:drawingView];
    [drawingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(playToyView.mas_bottom).offset(10);
        make.size.equalTo(readBookView);
    }];
    drawingView.optionBtn.selected = ((NSNumber*)[optionsData objectAtIndex:4]).boolValue;
    [drawingView.optionBtn addTarget:self action:@selector(didOptionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *customTitle = [[UILabel alloc]init];
    [self.view addSubview:customTitle];
    customTitle = [Tools setLabelWith:customTitle andText:@"自填" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    [customTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(drawingView.mas_bottom).offset(10);
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
    [costTextField becomeFirstResponder];
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
    titleView.text = @"价格设置";
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
    [dic_options setValue:costTextField.text forKey:@"cost"];
    [dic_options setValue:optionsData forKey:@"options"];
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
    //    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您修改的信息已提交$.$" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
    return nil;
}

- (id)startRemoteCall:(id)obj {
    return nil;
}
@end
