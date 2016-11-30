//
//  AYSetServiceCapacityController.m
//  BabySharing
//
//  Created by Alfred Yang on 29/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetServiceCapacityController.h"

@interface AYSetServiceCapacityController ()

@end

@implementation AYSetServiceCapacityController {
    NSMutableDictionary *service_info;
    
    NSMutableDictionary *ages_dic;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
        service_info = [dic objectForKey:kAYControllerChangeArgsKey];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ages_dic = [[NSMutableDictionary alloc]init];
    [ages_dic setValue:[NSNumber numberWithInt:2] forKey:@"lsl"];
    [ages_dic setValue:[NSNumber numberWithInt:11] forKey:@"usl"];
    [service_info setValue:[ages_dic copy] forKey:@"age_boundary"];
    [service_info setValue:[NSNumber numberWithInt:4] forKey:@"capacity"];
    [service_info setValue:[NSNumber numberWithInt:1] forKey:@"servant_no"];
    
    id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"SetServiceCapacity"];
    
    id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
    
    id obj = (id)cmd_notify;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_notify;
    [cmd_delegate performWithResult:&obj];
    
    NSString* cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SetServiceCapacityCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &cell_name)
    
    UIButton *nextBtn = [Tools creatUIButtonWithTitle:@"下一步" andTitleColor:[Tools whiteColor] andFontSize:17.f andBackgroundColor:[Tools themeColor]];
    [self.view addSubview:nextBtn];
    [nextBtn addTarget:self action:@selector(didNextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 49));
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
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    view.backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    view.backgroundColor = [UIColor whiteColor];
    
    NSString *title = @"更多信息";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
//    view.backgroundColor = [Tools whiteColor];
    ((UITableView*)view).contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    return nil;
}

#pragma mark -- actions
- (void)didNextBtnClick {
    
    id<AYCommand> des = DEFAULTCONTROLLER(@"MainInfo");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    [dic_push setValue:service_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

#pragma mark -- notifies
- (id)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//    [dic setValue:[NSNumber numberWithBool:YES] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)rightBtnSelected {
    
    return nil;
}

- (id)resetCapacityNumb:(NSDictionary*)args {
    NSNumber *index = [args objectForKey:@"index"];
    NSNumber *count = [args objectForKey:@"count"];
    
    if (index.intValue == 0) {      //lsl
        [ages_dic setValue:count forKey:@"lsl"];
        [service_info setValue:ages_dic forKey:@"age_boundary"];
    }
    else if (index.intValue == 1) {     //usl
        [ages_dic setValue:count forKey:@"usl"];
        [service_info setValue:ages_dic forKey:@"age_boundary"];
    }
    else if (index.intValue == 2) {     //capacity
        [service_info setValue:count forKey:@"capacity"];
    }
    else if (index.intValue == 3) {     //servant_no
        [service_info setValue:count forKey:@"servant_no"];
    }
    else {
        
    }
    
    return nil;
}

@end
