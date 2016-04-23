//
//  AYGroupChatController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYGroupChatController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYUserDisplayDefines.h"
#import "AYChatGroupInfoCellDefines.h"
#import "AYChatMessageCellDefines.h"
#import "AYRemoteCallCommand.h"

#define BACK_BTN_WIDTH          23
#define BACK_BTN_HEIGHT         23
#define BOTTOM_MARGIN           10.5

#define INPUT_HEIGHT            37

#define INPUT_CONTAINER_HEIGHT  49

#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width

#define USER_BTN_WIDTH          40
#define USER_BTN_HEIGHT         23


#define USER_INFO_PANE_HEIGHT               194
#define USER_INFO_PANE_MARGIN               10.5
#define USER_INGO_PANE_BOTTOM_MARGIN        4
#define USER_INFO_PANE_WIDTH                width - 2 * USER_INFO_PANE_MARGIN
#define USER_INFO_CONTAINER_HEIGHT          USER_INFO_PANE_HEIGHT

#define USER_INFO_BACK_BTN_HEIGHT           30
#define USER_INFO_BACK_BTN_WIDTH            30

static NSString* const kAYGroupChatControllerMessageTable = @"Table";
static NSString* const kAYGroupChatControllerUserInfoTable = @"Table2";

@implementation AYGroupChatController {
    CGRect keyBoardFrame;
    NSString* owner_id;
    NSNumber* group_id;
    NSString* post_id;
    NSString* theme;
    
    dispatch_semaphore_t semaphore_owner_info;
    __block BOOL owner_info_success;
    __block NSDictionary* owner_info_result;
    
    dispatch_semaphore_t semaphore_join_lst;
    __block BOOL join_lst_success;
    __block NSArray* join_lst_result;
    
    __block NSNumber* join_count;
    
    __block NSArray* current_messages;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
        owner_id = [args objectForKey:@"owner_id"];
        post_id = [args objectForKey:@"post_id"];
        theme = [args objectForKey:@"theme"];   // group name
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        
    }
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithWhite:0.1098 alpha:1.f];
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIView* table_view = [self.views objectForKey:kAYGroupChatControllerMessageTable];
    [self.view sendSubviewToBack:table_view];

    UIView* img = [self.views objectForKey:@"Image"];
    [self.view sendSubviewToBack:img];
    
    UIView* loading = [self.views objectForKey:@"Loading"];
    [self.view bringSubviewToFront:loading];
    
    semaphore_owner_info = dispatch_semaphore_create(0);
    semaphore_join_lst = dispatch_semaphore_create(0);
    
    {
        id<AYViewBase> view_user_info = [self.views objectForKey:kAYGroupChatControllerUserInfoTable];
        id<AYDelegateBase> del_user_info = [self.delegates objectForKey:@"GroupChatUserInfo"];
        
        id<AYCommand> cmd_delegate = [view_user_info.commands objectForKey:@"registerDelegate:"];
        id<AYCommand> cmd_datasource = [view_user_info.commands objectForKey:@"registerDatasource:"];
        
        id obj = del_user_info;
        [cmd_delegate performWithResult:&obj];
        obj = del_user_info;
        [cmd_datasource performWithResult:&obj];
       
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYUserDisplayTableCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
        id<AYCommand> view_reg_cell = [view_user_info.commands objectForKey:@"registerCellWithNib:"];
        [view_reg_cell performWithResult:&class_name];
        
        class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYChatGroupInfoCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
        [view_reg_cell performWithResult:&class_name];
    }
    
    {
        id<AYViewBase> view_message = [self.views objectForKey:kAYGroupChatControllerMessageTable];
        id<AYDelegateBase> del_message = [self.delegates objectForKey:@"GroupChatMessages"];
        
        id<AYCommand> cmd_delegate = [view_message.commands objectForKey:@"registerDelegate:"];
        id<AYCommand> cmd_datasource = [view_message.commands objectForKey:@"registerDatasource:"];
        
        id obj = del_message;
        [cmd_delegate performWithResult:&obj];
        obj = del_message;
        [cmd_datasource performWithResult:&obj];
       
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:kAYChatMessageCellName] stringByAppendingString:kAYFactoryManagerViewsuffix];
        id<AYCommand> view_reg_cell = [view_message.commands objectForKey:@"registerCellWithClass:"];
        [view_reg_cell performWithResult:&class_name];
    }
    
    {
        id<AYViewBase> view_input = [self.views objectForKey:@"ChatInput"];
        id<AYDelegateBase> del_input = [self.delegates objectForKey:@"ChatGroupInput"];
        
        id<AYCommand> cmd = [view_input.commands objectForKey:@"regInputDelegate:"];
        
        id obj = del_input;
        [cmd performWithResult:&obj];
    }
   
    [self waitForControllerReady];
    [self queryOwnerInfo];
    [self enterChatGroup];
   
    UIView* view_table = [self.views objectForKey:@"Table"];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere:)];
    [view_table addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -- layouts
- (id)GroupChatHeaderLayout:(UIView*)view {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    NSNumber* height = nil;
    id<AYCommand> cmd = [((id<AYViewBase>)view).commands objectForKey:@"querGroupChatViewHeight"];
    [cmd performWithResult:&height];
    
    view.frame = CGRectMake(0, 0, width, height.floatValue);
    view.backgroundColor = [UIColor clearColor];
    
    NSString* str = @"Alfred Test";
    id<AYCommand> cmd_test = [((id<AYViewBase>)view).commands objectForKey:@"setGroupChatViewInfo:"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:str forKey:@"theme"];
    [cmd_test performWithResult:&dic];
    
    return nil;
}

- (id)ImageLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    view.frame = CGRectMake(0, 0, width, height);
    ((UIImageView*)view).image = PNGRESOURCE(@"group_chat_bg_img");
    return nil;
}

- (id)TableLayout:(UIView*)view {
    
    view.backgroundColor = [UIColor clearColor];
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;  // 去除表框
#define MARGIN_BETWEEN_TABVIEW_2_HEADER         20
#define MARGIN_BETWEEN_TABVIEW_2_BOTTOM         10
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    NSNumber* header_height = nil;
    
    id<AYViewBase> header = [self.views objectForKey:@"GroupChatHeader"];
    id<AYCommand> cmd = [header.commands objectForKey:@"querGroupChatViewHeight"];
    [cmd performWithResult:&header_height];
    
    view.frame = CGRectMake(0, header_height.floatValue + MARGIN_BETWEEN_TABVIEW_2_HEADER, width, height - header_height.floatValue - INPUT_CONTAINER_HEIGHT - MARGIN_BETWEEN_TABVIEW_2_BOTTOM - MARGIN_BETWEEN_TABVIEW_2_HEADER);
    return nil;
}

- (id)ChatInputLayout:(UIView*)view {
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    view.frame = CGRectMake(0, height - INPUT_CONTAINER_HEIGHT, SCREEN_WIDTH, INPUT_CONTAINER_HEIGHT);
    return nil;
}

- (id)Table2Layout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    view.frame = CGRectMake(USER_INFO_PANE_MARGIN + width, height - USER_INFO_CONTAINER_HEIGHT, USER_INFO_PANE_WIDTH, USER_INFO_CONTAINER_HEIGHT);
    ((UITableView*)view).separatorStyle = UITableViewCellSeparatorStyleNone;
    ((UITableView*)view).scrollEnabled = NO;
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5.0;
    view.clipsToBounds = YES;
    return nil;
}

- (id)LoadingLayout:(UIView*)view {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    view.frame = CGRectMake(0, 0, width, height);
    view.hidden = YES;
    view.userInteractionEnabled = NO;
    return nil;
}

#pragma mark -- notifications
- (id) didSelectedBackBtn {
    NSLog(@"pop view controller");
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)didSelectedUserInfoBtn {
   
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
   
    void(^animationBlock)(void) = ^() {
        [UIView animateWithDuration:0.3f animations:^{
            UIView* view_input = [self.views objectForKey:@"ChatInput"];
            view_input.center = CGPointMake(view_input.center.x - width, view_input.center.y);
            UIView* view_user_info = [self.views objectForKey:kAYGroupChatControllerUserInfoTable];
            view_user_info.center = CGPointMake(view_user_info.center.x - width, view_user_info.center.y);
        }];
    };
    
    if (self.view.center.y != height / 2) {
        
        id<AYViewBase> view = [self.views objectForKey:@"ChatInput"];
        id<AYCommand> cmd = [view.commands objectForKey:@"resignFocus"];
        [cmd performWithResult:nil];
        [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseInOut animations:animationBlock completion:nil];
    } else animationBlock();
    
    return nil;
}

- (id)hiddenChatGroupInfoPane {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    UIView* view_user_info = [self.views objectForKey:kAYGroupChatControllerUserInfoTable];
    if (view_user_info.center.x < width) {
        [UIView animateWithDuration:0.3f animations:^{
            UIView* view_input = [self.views objectForKey:@"ChatInput"];
            view_input.center = CGPointMake(view_input.center.x + width, view_input.center.y);
            UIView* view_user_info = [self.views objectForKey:kAYGroupChatControllerUserInfoTable];
            view_user_info.center = CGPointMake(view_user_info.center.x + width, view_user_info.center.y);
        }];
    }
    return nil;
}

- (id)sendMessage:(id)args {
    NSString* text = (NSString*)args;
    
    id<AYFacadeBase> f = [self.facades objectForKey:@"XMPP"];
    id<AYCommand> cmd = [f.commands objectForKey:@"SendMessage"];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:text forKey:@"text"];
    [dic setValue:group_id forKey:@"group_id"];
    
    [cmd performWithResult:&dic];
    return nil;
}

- (id)XMPPMessageSendSuccess:(id)args {
    NSLog(@"send message success");
    
    return nil;
}

- (id)XMPPMessageSendFailed:(id)args {
    NSLog(@"send message failed");
    [[[UIAlertView alloc]initWithTitle:@"error" message:@"发送消息失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    return nil;
}

#pragma mark -- actions
#pragma mark -- get input view height
- (void)keyboardDidShow:(NSNotification*)notification {
    UIView *result = nil;
    NSArray *windowsArray = [UIApplication sharedApplication].windows;
    for (UIView *tmpWindow in windowsArray) {
        NSArray *viewArray = [tmpWindow subviews];
        for (UIView *tmpView  in viewArray) {
            NSLog(@"%@", [NSString stringWithUTF8String:object_getClassName(tmpView)]);
            // if ([[NSString stringWithUTF8String:object_getClassName(tmpView)] isEqualToString:@"UIPeripheralHostView"]) {
            if ([[NSString stringWithUTF8String:object_getClassName(tmpView)] isEqualToString:@"UIInputSetContainerView"]) {
                result = tmpView;
                break;
            }
        }
        
        if (result != nil) {
            break;
        }
    }
    
    //    keyboardView = result;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyBoardFrame = value.CGRectValue;
   
    [UIView animateWithDuration:0.3f animations:^{
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y - keyBoardFrame.size.height);
    }];
}

- (void)keyboardWasChange:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    keyBoardFrame = value.CGRectValue;
}

- (void)keyboardDidHidden:(NSNotification*)notification {
    [UIView animateWithDuration:0.3f animations:^{
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y + keyBoardFrame.size.height);
    }];
}

- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {
    id<AYViewBase> view = [self.views objectForKey:@"ChatInput"];
    id<AYCommand> cmd = [view.commands objectForKey:@"resignFocus"];
    [cmd performWithResult:nil];
}

#pragma mark -- block user interaction
- (id)startRemoteCall:(id)obj {
    UIView* loading = [self.views objectForKey:@"Loading"];
    if (loading.hidden == YES) {
        loading.hidden = NO;
        
        id<AYCommand> cmd = [((id<AYViewBase>)loading).commands objectForKey:@"startGif"];
        [cmd performWithResult:nil];
    }
    return nil;
}

- (id)endRemoteCall:(id)obj {
    return nil;
}

#pragma mark -- query user info
- (void)waitForControllerReady {
    dispatch_queue_t qw = dispatch_queue_create("query data wait", nil);
    dispatch_async(qw, ^{
        dispatch_semaphore_wait(semaphore_owner_info, dispatch_time(DISPATCH_TIME_NOW, 30.f * NSEC_PER_SEC));
        dispatch_semaphore_wait(semaphore_join_lst, dispatch_time(DISPATCH_TIME_NOW, 30.f * NSEC_PER_SEC));
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setInfoDataToDelegate];
            [self setMessagesToDelegate];
            
            [self GroupChatControllerIsReady];
        });
    });
}

- (void)queryOwnerInfo {
    id<AYFacadeBase> f = [self.facades objectForKey:@"ProfileRemote"];
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"QueryUserProfile"];
    
    NSDictionary* user = nil;
    CURRENUSER(user);
    
    NSMutableDictionary* dic = [user mutableCopy];
    [dic setValue:owner_id forKey:@"owner_user_id"];
    
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        owner_info_success = success;
        owner_info_result = [result copy];
        
        dispatch_semaphore_signal(semaphore_owner_info);
    }];
}

- (void)setInfoDataToDelegate {
    id<AYDelegateBase> del = [self.delegates objectForKey:@"GroupChatUserInfo"];
    id<AYCommand> cmd = [del.commands objectForKey:@"changeQueryData:"];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:owner_info_result forKey:@"owner"];
    [dic setValue:join_lst_result forKey:@"joiners"];
    [dic setValue:join_count forKey:@"count"];
    
    [cmd performWithResult:&dic];
   
    id<AYViewBase> view = [self.views objectForKey:kAYGroupChatControllerUserInfoTable];
    id<AYCommand> cmd_refresh = [view.commands objectForKey:@"refresh"];
    [cmd_refresh performWithResult:nil];
}

- (void)setMessagesToDelegate {
    id<AYDelegateBase> del = [self.delegates objectForKey:@"GroupChatMessages"];
    id<AYCommand> cmd = [del.commands objectForKey:@"changeQueryData:"];
    
    id args = current_messages;
    [cmd performWithResult:&args];
    
    id<AYViewBase> view = [self.views objectForKey:kAYGroupChatControllerMessageTable];
    id<AYCommand> cmd_refresh = [view.commands objectForKey:@"refresh"];
    [cmd_refresh performWithResult:nil];
}

#pragma mark -- enter group chat
- (void)enterChatGroup {
    id<AYFacadeBase> f = [self.facades objectForKey:@"ChatSessionRemote"];
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"EnterChatGroup"];
    
    NSDictionary* user = nil;
    CURRENUSER(user);
    
    NSMutableDictionary* dic = [user mutableCopy];
    [dic setValue:theme forKey:@"group_name"];
    [dic setValue:post_id forKey:@"post_id"];
    [dic setValue:owner_id forKey:@"owner_id"];
    
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        join_lst_success = success;
        join_count = [result objectForKey:@"joiners_count"];
       
        id<AYFacadeBase> xmpp = [self.facades objectForKey:@"XMPP"];
        id<AYCommand> cmd = [xmpp.commands objectForKey:@"JoinGroup"];
       
        group_id = [result objectForKey:@"group_id"];
        id args = group_id;
        [cmd performWithResult:&args];
        
        id<AYViewBase> view = [self.views objectForKey:@"ChatInput"];
        id<AYCommand> cmd_joiner_count = [view.commands objectForKey:@"setJoinerCount:"];
        id count = join_count;
        [cmd_joiner_count performWithResult:&count];
        
        id<AYCommand> cmd_query_messages = [xmpp.commands objectForKey:@"QueryMessages"];
        NSMutableDictionary* args_query_messages = [[NSMutableDictionary alloc]init];
        [args_query_messages setValue:group_id forKey:@"group_id"];
        [cmd_query_messages performWithResult:&args_query_messages];
        current_messages = [args_query_messages copy];
    }];
}

- (id)XMPPGetGroupMemberSuccess:(id)args {
    join_lst_success = YES;
    join_lst_result = [args objectForKey:@"result"];
    dispatch_semaphore_signal(semaphore_join_lst);
    return nil;
}

- (void)GroupChatControllerIsReady {
    UIView* loading = [self.views objectForKey:@"Loading"];
    loading.hidden = YES;
    
    id<AYCommand> cmd = [((id<AYViewBase>)loading).commands objectForKey:@"stopGif"];
    [cmd performWithResult:nil];
}
@end
