//
//  AYConfirmRealNameController.m
//  BabySharing
//
//  Created by Alfred Yang on 14/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYConfirmRealNameController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#import "Tools.h"
#define SCREEN_WIDTH                        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                       [UIScreen mainScreen].bounds.size.height

@interface AYConfirmRealNameController ()

@end

@implementation AYConfirmRealNameController{
    UITextField *nameTextField;
    UITextField *coderTextField;
}

- (void)postPerform{
    
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9490 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:(UIView*)view_title];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tap];
    
    UILabel *title = [[UILabel alloc]init];
    title = [Tools setLabelWith:title andText:@"实名认证" andTextColor:[Tools blackColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:1];
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(160);
        make.centerX.equalTo(self.view);
    }];
    
    UILabel *descLabel = [[UILabel alloc]init];
    descLabel = [Tools setLabelWith:descLabel andText:@"验证您的实名信息\n增加您的个人信任" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:1];
    descLabel.numberOfLines = 2;
    [self.view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(20);
        make.centerX.equalTo(title);
    }];
    
    UIView *nameView = [[UIView alloc]init];
    nameView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLabel.mas_bottom).offset(50);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(40);
    }];
    UILabel *realName = [[UILabel alloc]init];
    realName = [Tools setLabelWith:realName andText:@"真实姓名" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    [nameView addSubview:realName];
    [realName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameView);
        make.left.equalTo(nameView).offset(10);
    }];
    nameTextField = [[UITextField alloc]init];
    nameTextField.placeholder = @"请输入真实姓名";
    nameTextField.font = [UIFont systemFontOfSize:14.f];
    nameTextField.textColor = [Tools blackColor];
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [nameView addSubview:nameTextField];
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameView);
        make.left.equalTo(nameView).offset(100);
        make.right.equalTo(nameView).offset(-5);
    }];
    
    UIView *coderView = [[UIView alloc]init];
    coderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:coderView];
    [coderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameView.mas_bottom).offset(20);
        make.centerX.equalTo(nameView);
        make.size.equalTo(nameView);
    }];
    UILabel *coder = [[UILabel alloc]init];
    coder = [Tools setLabelWith:coder andText:@"身份证号码" andTextColor:[Tools garyColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:0];
    [coderView addSubview:coder];
    [coder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(coderView);
        make.left.equalTo(coderView).offset(10);
    }];
    coderTextField = [[UITextField alloc]init];
    coderTextField.placeholder = @"请输入身份证号";
    coderTextField.font = [UIFont systemFontOfSize:14.f];
    coderTextField.textColor = [Tools blackColor];
    coderTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [coderView addSubview:coderTextField];
    [coderTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(coderView);
        make.left.equalTo(coderView).offset(100);
        make.right.equalTo(coderView).offset(-5);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 0, width, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    view.frame = CGRectMake(0, 20, width, 44);
    view.backgroundColor = [UIColor whiteColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [bar_right_btn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.f] forState:UIControlStateNormal];
    [bar_right_btn setTitle:@"完成" forState:UIControlStateNormal];
    bar_right_btn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [bar_right_btn sizeToFit];
    bar_right_btn.center = CGPointMake(width - 15.5 - bar_right_btn.frame.size.width / 2, 44 / 2);
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
    [cmd_right performWithResult:&bar_right_btn];
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, 44 - 0.5, SCREEN_WIDTH, 0.5);
    line.backgroundColor = [Tools colorWithRED:178 GREEN:178 BLUE:178 ALPHA:1.f].CGColor;
    [view.layer addSublayer:line];
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    UILabel* titleView = (UILabel*)view;
    titleView.text = @"验证您的身份";
    titleView.font = [UIFont systemFontOfSize:16.f];
    titleView.textColor = [UIColor colorWithWhite:0.4 alpha:1.f];
    [titleView sizeToFit];
    titleView.center = CGPointMake(SCREEN_WIDTH / 2, 44 / 2);
    return nil;
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}
- (id)rightBtnSelected {
    if (![nameTextField.text isEqualToString:@""] && ![coderTextField.text isEqualToString:@""]) {
        
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的信息已提交，请耐心等待$.$" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
    } else
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请完善个人信息！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
    return nil;
}

- (void)tapGesture:(UITapGestureRecognizer*)gesture {
    NSLog(@"tap esle where");
    if ([nameTextField isFirstResponder]) {
        [nameTextField resignFirstResponder];
    }
    if ([coderTextField isFirstResponder]) {
        [coderTextField resignFirstResponder];
    }
}

@end
