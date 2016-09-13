//
//  AYOrderTimesController.m
//  BabySharing
//
//  Created by Alfred Yang on 13/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYOrderTimesController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"
#import "AYCommandDefines.h"

#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"
#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"

#import "OrderTimesOptionView.h"

#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height
#define SHOW_OFFSET_Y           SCREEN_HEIGHT - 196
#define STATUS_HEIGHT           20
#define NAV_HEIGHT              45

#define TEXT_COLOR              [Tools blackColor]

#define CONTROLLER_MARGIN       10.f

#define FIELD_HEIGHT                        80

@implementation AYOrderTimesController {
    
    UILabel *setAgeslabel;
    NSTimeInterval dob;
    
    OrderTimesOptionView *startView;
    OrderTimesOptionView *endView;
    
    NSMutableDictionary *dic_times;
    
    UIView *picker;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
//        dic_split_value = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (!dic_times) {
        dic_times = [[NSMutableDictionary alloc]initWithCapacity:2];
    }
    
    startView = [[OrderTimesOptionView alloc]initWithTitle:@"开始时间"];
    [self.view addSubview:startView];
    [startView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH * 0.5, 75));
    }];
    startView.userInteractionEnabled = YES;
    [startView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSetStartTime)]];
    startView.states = 1;
    
    startView.timeLabel.text = @"10:00";
    
    endView = [[OrderTimesOptionView alloc]initWithTitle:@"结束时间"];
    [self.view addSubview:endView];
    [endView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(startView);
        make.right.equalTo(self.view);
        make.size.equalTo(startView);
    }];
    endView.userInteractionEnabled = YES;
    [endView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSetEndTime)]];
    endView.states = 0;
    
    endView.timeLabel.text = @"12:00";
    
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
        
        id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"OrderTimes"];
        
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
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [dic setValue:dic_args forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
}

- (void)didSetStartTime {
    endView.states = 0;
    startView.states = 1;
    
    endView.userInteractionEnabled = NO;
    [self showPickerView];
}
- (void)didSetEndTime {
    endView.states = 1;
    startView.states = 0;
    
    startView.userInteractionEnabled = NO;
    [self showPickerView];
}

- (void)showPickerView {
    
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"OrderTimes"];
    id<AYCommand> cmd_scroll_center = [cmd_recommend.commands objectForKey:@"scrollToCenter"];
    [cmd_scroll_center performWithResult:nil];
    
    if (picker.frame.origin.y == SCREEN_HEIGHT) {
        [UIView animateWithDuration:0.25 animations:^{
            picker.frame = CGRectMake(0, SHOW_OFFSET_Y, SCREEN_WIDTH, 196);
        }];
    }
}
#pragma mark -- commands
- (id)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    
    return nil;
}

- (id)rightBtnSelected {
    return nil;
}

- (id)didSaveClick {
    id<AYDelegateBase> cmd_commend = [self.delegates objectForKey:@"OrderTimes"];
    id<AYCommand> cmd_index = [cmd_commend.commands objectForKey:@"queryCurrentSelected:"];
    NSString *args = nil;
    [cmd_index performWithResult:&args];
    
    if (startView.userInteractionEnabled) {
        startView.timeLabel.text = args;
    }
    if (endView.userInteractionEnabled) {
        endView.timeLabel.text = args;
    }
    
    [self didCancelClick];
    return nil;
}
- (id)didCancelClick {
    if (picker.frame.origin.y == SHOW_OFFSET_Y) {
        [UIView animateWithDuration:0.25 animations:^{
            picker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
        }];
    }
    startView.userInteractionEnabled = endView.userInteractionEnabled = YES;
    return nil;
}
@end
