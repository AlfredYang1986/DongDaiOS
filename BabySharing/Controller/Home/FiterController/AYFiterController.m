//
//  AYLocationResultController.m
//  BabySharing
//
//  Created by Alfred Yang on 2/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYFiterController.h"
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
#import "LoginToken.h"
#import "LoginToken+ContextOpt.h"

#import "AYSearchDefines.h"
#import "Tools.h"

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height

@implementation AYFiterController{
    NSMutableArray *loading_status;
    UIButton *didSearchBtn;
}

- (void)postPerform{
    
}
#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
//        NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Tools garyBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    loading_status = [[NSMutableArray alloc]init];
    {
        UIView* view_loading = [self.views objectForKey:@"Loading"];
        [self.view bringSubviewToFront:view_loading];
        view_loading.hidden = YES;
    }
    
    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    [view_nav addSubview:(UIView*)view_title];
    
    UIView* headView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 10)];
    headView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.f];
    [self.view addSubview:headView];
    
    CALayer* line2 = [CALayer layer];
    line2.borderColor = [UIColor colorWithWhite:0.6922 alpha:0.10].CGColor;
    line2.borderWidth = 1.f;
    line2.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    [headView.layer addSublayer:line2];
    
    didSearchBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, [UIScreen mainScreen].bounds.size.height - 45 - 15, SCREEN_WIDTH - 30, 45)];
    [didSearchBtn setBackgroundColor:[Tools themeColor]];
    [didSearchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    didSearchBtn.titleLabel.font = [UIFont systemFontOfSize:20.f];
    [didSearchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    didSearchBtn.layer.cornerRadius = 4.f;
    didSearchBtn.clipsToBounds = YES;
    [self.view addSubview:didSearchBtn];
    
    [didSearchBtn addTarget:self action:@selector(didSearchBtnClick) forControlEvents:UIControlEventTouchUpInside];
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
    [bar_right_btn setTitleColor:[Tools themeColor] forState:UIControlStateNormal];
    [bar_right_btn setTitle:@"重置" forState:UIControlStateNormal];
    bar_right_btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [bar_right_btn sizeToFit];
    bar_right_btn.center = CGPointMake(width - 15.5 - bar_right_btn.frame.size.width / 2, 44 / 2);
    id<AYCommand> cmd_right = [bar.commands objectForKey:@"setRightBtnWithBtn:"];
    [cmd_right performWithResult:&bar_right_btn];
    
    return nil;
}

- (id)SetNevigationBarTitleLayout:(UIView*)view {
    UILabel* titleView = (UILabel*)view;
    
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    id<AYCommand> cmd_title = [view_title.commands objectForKey:@"changeNevigationBarTitle:"];
    
    NSDate *todayDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM月dd日 EEEE"];
    NSString* title = [formatter stringFromDate:todayDate];
    [cmd_title performWithResult:&title];
    
//    titleView.text = dayDate;
    titleView.font = [UIFont systemFontOfSize:16.f];
    titleView.textColor = [UIColor colorWithWhite:0.4 alpha:1.f];
    [titleView sizeToFit];
    titleView.center = CGPointMake(SCREEN_WIDTH / 2, 44 / 2);
    return nil;
}
-(id)changeNavTitle:(NSString *)title{
    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
    id<AYCommand> cmd_title = [view_title.commands objectForKey:@"changeNevigationBarTitle:"];
    [cmd_title performWithResult:&title];
    
    UILabel* titleView = (UILabel*)view_title;
    titleView.font = [UIFont systemFontOfSize:16.f];
    titleView.textColor = [UIColor colorWithWhite:0.4 alpha:1.f];
    [titleView sizeToFit];
    titleView.center = CGPointMake(SCREEN_WIDTH / 2, 44 / 2);
    return nil;
}

- (id)FiterScrollLayout:(UIView*)view {
    CGFloat margin = 0.f;
    view.frame = CGRectMake(margin, 74, SCREEN_WIDTH - 2* margin, SCREEN_HEIGHT - 74 - 65 -10);
    view.backgroundColor = [UIColor clearColor];
    ((UIScrollView*)view).showsVerticalScrollIndicator = NO;
    return nil;
}

#pragma mark -- actions
-(void)didSearchBtnClick{
    id<AYViewBase> view = [self.views objectForKey:@"FiterScroll"];
    id<AYCommand> cmd = [view.commands objectForKey:@"queryFiterArgs:"];
    NSDictionary *dic = nil;
    [cmd performWithResult:&dic];
    NSLog(@"%@",dic);
    
    if (!dic) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"未设置正确的时间!－_－'" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        return;
    }
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_pop setValue:dic forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_pop = POP;
    [cmd_pop performWithResult:&dic_pop];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)rightBtnSelected {
    id<AYViewBase> view = [self.views objectForKey:@"FiterScroll"];
    id<AYCommand> cmd = [view.commands objectForKey:@"resetFiterArgs"];
    [cmd performWithResult:nil];
    return nil;
}

-(id)hiddenCLResultTable{
    return nil;
}

- (id)scrollToHideKeyBoard {
    UIView* view = [self.views objectForKey:@"SearchBar"];
    if ([view isFirstResponder]) {
        [view resignFirstResponder];
    }
    return nil;
}

-(BOOL)isActive{
    UIViewController * tmp = [Tools activityViewController];
    return tmp == self;
}
@end
