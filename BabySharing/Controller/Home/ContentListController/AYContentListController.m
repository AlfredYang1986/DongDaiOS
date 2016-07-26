//
//  AYContentListController.m
//  BabySharing
//
//  Created by Alfred Yang on 13/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYContentListController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#import "AYSearchDefines.h"
#import "Tools.h"

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height
#define HEADVIEWHEIGHT                          95

@interface AYContentListController ()

@end

@implementation AYContentListController{
    NSMutableArray *loading_status;
    
    UILabel *countTitleLabel;
    UIImageView *star_rang;
}

- (void)postPerform{
    
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
//        NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:1.f alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    loading_status = [[NSMutableArray alloc]init];
    {
        UIView* view_loading = [self.views objectForKey:@"Loading"];
        [self.view bringSubviewToFront:view_loading];
        view_loading.hidden = YES;
    }
    
//    UIView* view_nav = [self.views objectForKey:@"FakeNavBar"];
//    id<AYViewBase> view_title = [self.views objectForKey:@"SetNevigationBarTitle"];
//    [view_nav addSubview:(UIView*)view_title];
    
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    id<AYCommand> cmd_datasource = [view_table.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_table.commands objectForKey:@"registerDelegate:"];
    
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"ContentList"];
    
    id obj = (id)cmd_recommend;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_recommend;
    [cmd_delegate performWithResult:&obj];
    
    id<AYCommand> cmd_search = [view_table.commands objectForKey:@"registerCellWithNib:"];
    NSString* nib_search_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"ContentListCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    [cmd_search performWithResult:&nib_search_name];
    
    countTitleLabel = [[UILabel alloc]init];
    countTitleLabel = [Tools setLabelWith:countTitleLabel andText:@"0条评论 * 0个共同好友" andTextColor:[Tools blackColor] andFontSize:17.f andBackgroundColor:nil andTextAlignment:0];
    [self.view addSubview:countTitleLabel];
    [countTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(25);
        make.left.equalTo(self.view).offset(18);
    }];
    
    star_rang = [[UIImageView alloc]init];
    star_rang.image = IMGRESOURCE(@"star_rang_5");
    [self.view addSubview:star_rang];
    [star_rang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(countTitleLabel);
        make.top.equalTo(countTitleLabel.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(90, 14));
    }];
    
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:[UIImage imageNamed:@"content_close"] forState:UIControlStateNormal];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(countTitleLabel);
        make.right.equalTo(self.view).offset(-18);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    [closeBtn addTarget:self action:@selector(didCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *line_separator = [CALayer layer];
    line_separator.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.f].CGColor;
    line_separator.frame = CGRectMake(0, HEADVIEWHEIGHT - 1, SCREEN_WIDTH, 1);
    [self.view.layer addSublayer:line_separator];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

#pragma mark -- layouts
//- (id)FakeStatusBarLayout:(UIView*)view {
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    view.frame = CGRectMake(0, 0, width, 20);
//    view.backgroundColor = [UIColor whiteColor];
//    return nil;
//}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, HEADVIEWHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - HEADVIEWHEIGHT);
    view.backgroundColor = [UIColor whiteColor];
    
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).showsHorizontalScrollIndicator = NO;
    ((UITableView*)view).showsVerticalScrollIndicator = NO;
    
    ((UITableView*)view).estimatedRowHeight = 150;
    ((UITableView*)view).rowHeight = UITableViewAutomaticDimension;
    
    return nil;
}

#pragma mark -- actions
-(void)didCloseBtnClick{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionReversModuleValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    id<AYCommand> cmd = REVERSMODULE;
    [cmd performWithResult:&dic];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    return nil;
}

- (id)rightBtnSelected {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end