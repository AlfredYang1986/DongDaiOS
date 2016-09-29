//
//  AYBabyInfoController.m
//  BabySharing
//
//  Created by Alfred Yang on 12/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYBabyInfoController.h"
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
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"

#import "AYDongDaSegDefines.h"
#import "AYSearchDefines.h"

#define SHOW_OFFSET_Y                       SCREEN_HEIGHT - 196

@interface AYBabyInfoController ()

@end

@implementation AYBabyInfoController{
    NSMutableArray *loading_status;
    NSMutableArray *querydate;
    
    UIView *picker;
    UIView *picker2;
}

- (void)postPerform{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dic setValue:@"2016-06-07" forKey:@"brith"];
    [dic setValue:@"boy" forKey:@"baby_sex"];
    NSArray *tmp = @[dic];
    querydate = [tmp mutableCopy];
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
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"BabyInfo"];
    
    id obj = (id)cmd_recommend;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_recommend;
    [cmd_delegate performWithResult:&obj];
    
    {
        id<AYViewBase> view_picker = [self.views objectForKey:@"Picker"];
        picker = (UIView*)view_picker;
        [self.view bringSubviewToFront:picker];
        id<AYCommand> cmd_datasource = [view_picker.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_picker.commands objectForKey:@"registerDelegate:"];
        
        id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"BabyInfoPicker"];
        
        id obj = (id)cmd_recommend;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_recommend;
        [cmd_delegate performWithResult:&obj];
    }
    {
        id<AYViewBase> view_picker = [self.views objectForKey:@"Picker2"];
        picker2 = (UIView*)view_picker;
        [self.view bringSubviewToFront:picker2];
        id<AYCommand> cmd_datasource = [view_picker.commands objectForKey:@"registerDatasource:"];
        id<AYCommand> cmd_delegate = [view_picker.commands objectForKey:@"registerDelegate:"];
        
        id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"BabyInfoPicker2"];
        
        id obj = (id)cmd_recommend;
        [cmd_datasource performWithResult:&obj];
        obj = (id)cmd_recommend;
        [cmd_delegate performWithResult:&obj];
    }
    
    id<AYCommand> cmd_search = [view_table.commands objectForKey:@"registerCellWithNib:"];
    NSString* nib_search_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"BabyInfoCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_search performWithResult:&nib_search_name];
    
    id<AYCommand> change_date = [cmd_recommend.commands objectForKey:@"changeQueryData:"];
    NSArray *tmp = [querydate copy];
    [change_date performWithResult:&tmp];
    
    loading_status = [[NSMutableArray alloc]init];
    {
        UIView* view_loading = [self.views objectForKey:@"Loading"];
        [self.view bringSubviewToFront:view_loading];
        view_loading.hidden = YES;
    }
    
    UIView* headView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 10)];
    headView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.f];
    [self.view addSubview:headView];
    
    CALayer* line2 = [CALayer layer];
    line2.borderColor = [UIColor colorWithWhite:0.6922 alpha:0.10].CGColor;
    line2.borderWidth = 1.f;
    line2.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    [headView.layer addSublayer:line2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    view.backgroundColor = [UIColor whiteColor];
    
    id<AYViewBase> bar = (id<AYViewBase>)view;
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    UIButton* bar_right_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [bar_right_btn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.f] forState:UIControlStateNormal];
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
    
    titleView.text = @"宝宝信息";
    titleView.font = [UIFont systemFontOfSize:16.f];
    titleView.textColor = [UIColor colorWithWhite:0.4 alpha:1.f];
    [titleView sizeToFit];
    titleView.center = CGPointMake(SCREEN_WIDTH / 2, 44 / 2);
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64 + 10, SCREEN_WIDTH, SCREEN_HEIGHT - 74);
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    UIButton *addBtn = [[UIButton alloc]init];
    [headView addSubview:addBtn];
    [addBtn setImage:IMGRESOURCE(@"icon_pick") forState:UIControlStateNormal];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView).offset(-15);
        make.centerY.equalTo(headView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [addBtn addTarget:self action:@selector(didAddBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    ((UITableView*)view).tableHeaderView = headView;
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsHorizontalScrollIndicator = NO;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.f];
    return nil;
}

- (id)PickerLayout:(UIView*)view{
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
    view.backgroundColor = [Tools garyColor];
    return nil;
}
- (id)Picker2Layout:(UIView*)view{
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
    view.backgroundColor = [Tools garyColor];
    return nil;
}

- (id)LoadingLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    return nil;
}

#pragma mark -- actions
-(void)didAddBtnClick{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dic setValue:@"2016-06-07" forKey:@"brith"];
    [dic setValue:@"boy" forKey:@"baby_sex"];
    [querydate addObject:dic];
    
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"BabyInfo"];
    id<AYCommand> change_date = [cmd_recommend.commands objectForKey:@"changeQueryData:"];
    NSArray *tmp = [querydate copy];
    [change_date performWithResult:&tmp];
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> fresh = [view_table.commands objectForKey:@"refresh"];
    [fresh performWithResult:nil];
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
    
    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"您修改的信息已提交$.$" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
    return nil;
}

- (id)sendDelMessage:(NSNumber*)args {
    NSInteger index = args.integerValue;
    [querydate removeObjectAtIndex:index];
    return nil;
}

- (id)showPicker:(NSNumber*)args {
    if (picker2.frame.origin.y == SHOW_OFFSET_Y) {
        [UIView animateWithDuration:0.25 animations:^{
            picker2.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                picker.frame = CGRectMake(0, SHOW_OFFSET_Y, SCREEN_WIDTH, 196);
            }];
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            picker.frame = CGRectMake(0, SHOW_OFFSET_Y, SCREEN_WIDTH, 196);
        }];
    }
    
    return nil;
}

- (id)showPicker2:(NSNumber*)args {
    if (picker.frame.origin.y == SHOW_OFFSET_Y) {
        [UIView animateWithDuration:0.25 animations:^{
            picker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                picker2.frame = CGRectMake(0, SHOW_OFFSET_Y, SCREEN_WIDTH, 196);
            }];
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            picker2.frame = CGRectMake(0, SHOW_OFFSET_Y, SCREEN_WIDTH, 196);
        }];
    }
    return nil;
}

-(id)didSaveClick {
    id<AYDelegateBase> cmd_commend = [self.delegates objectForKey:@"BabyInfo"];
    id<AYCommand> cmd_index = [cmd_commend.commands objectForKey:@"queryCurrentSelected:"];
    NSNumber *index = nil;
    [cmd_index performWithResult:&index];
    
    if (picker.frame.origin.y == SHOW_OFFSET_Y) {
        
        id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"BabyInfoPicker"];
        id<AYCommand> cmd = [cmd_recommend.commands objectForKey:@"queryBabyBirthday:"];
        NSString *brithday = nil;
        [cmd performWithResult:&brithday];
        
//        NSMutableDictionary *dic = [querydate objectAtIndex:index.integerValue];
        [[querydate objectAtIndex:index.integerValue] setValue:brithday forKey:@"brith"]; //c
        
        id<AYCommand> change_date = [cmd_commend.commands objectForKey:@"changeQueryData:"];
        NSArray *tmp = [querydate copy];
        [change_date performWithResult:&tmp];
        
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        id<AYCommand> fresh = [view_table.commands objectForKey:@"refresh"];
        [fresh performWithResult:nil];
        
        [UIView animateWithDuration:0.25 animations:^{
            picker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
        }];
    }else if(picker2.frame.origin.y == SHOW_OFFSET_Y){
        id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"BabyInfoPicker2"];
        id<AYCommand> cmd = [cmd_recommend.commands objectForKey:@"queryBabySex:"];
        NSString *sex = nil;
        [cmd performWithResult:&sex];
        
        [[querydate objectAtIndex:index.integerValue] setValue:sex forKey:@"baby_sex"]; //c
        
        id<AYCommand> change_date = [cmd_commend.commands objectForKey:@"changeQueryData:"];
        NSArray *tmp = [querydate copy];
        [change_date performWithResult:&tmp];
        
        id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
        id<AYCommand> fresh = [view_table.commands objectForKey:@"refresh"];
        [fresh performWithResult:nil];
        
        [UIView animateWithDuration:0.25 animations:^{
            picker2.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
        }];
    }
    
    return nil;
}
- (id)didCancelClick {
    if (picker.frame.origin.y == SHOW_OFFSET_Y) {
        [UIView animateWithDuration:0.25 animations:^{
            picker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
        }];
    }else if(picker2.frame.origin.y == SHOW_OFFSET_Y){
        [UIView animateWithDuration:0.25 animations:^{
            picker2.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 196);
        }];
    }
    
    return nil;
}

@end
