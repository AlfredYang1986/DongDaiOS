//
//  AYSetCourseSignController.m
//  BabySharing
//
//  Created by Alfred Yang on 9/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetCourseSignController.h"
#import "AYViewBase.h"
#import "AYFactoryManager.h"
#import "AYServiceArgsDefines.h"

@implementation AYSetCourseSignController {
    NSMutableDictionary *title_info;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
        title_info = [dic objectForKey:kAYControllerChangeArgsKey];
//        course_sign_index = [dic_course objectForKey:kAYServiceArgsCourseSign];
//        course_coustom = [dic_course objectForKey:kAYServiceArgsCourseCoustom];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"SetCourseSign"];
    
    id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
    id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
    
    id obj = (id)cmd_notify;
    [cmd_datasource performWithResult:&obj];
    obj = (id)cmd_notify;
    [cmd_delegate performWithResult:&obj];
    
    NSString* cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SetServiceThemeCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &cell_name)
    
    cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"SetCourseSignCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
    kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &cell_name)
    
//    NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
    id tmp = [title_info copy];
    kAYDelegatesSendMessage(@"SetCourseSign", @"changeQueryData:", &tmp);
    
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
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    
    NSString *title = @"服务标签";
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
    
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
    
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
    return nil;
}

- (id)TableLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    view.backgroundColor = [Tools whiteColor];
    return nil;
}

#pragma mark -- actions
- (void)didNorseLabelTap {
    id<AYCommand> des = DEFAULTCONTROLLER(@"NapLocation");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:@"push" forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
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
    
    return nil;
}

@end
