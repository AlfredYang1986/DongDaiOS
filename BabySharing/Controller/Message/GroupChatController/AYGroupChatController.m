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
//#import "AYChatGroupInfoCellDefines.h"
#import "AYChatMessageCellDefines.h"
#import "AYRemoteCallCommand.h"
#import "AYChatInputView.h"
#import "AYNotifyDefines.h"
#import "AYModelFacade.h"

#import "GotyeOCChatTarget.h"
#import "GotyeOCMessage.h"

#import "EMMessage.h"
#import "EMConversation.h"
#import "EMChatroom.h"

static NSString* const kAYGroupChatControllerMessageTable = @"Table";
static NSString* const kAYGroupChatControllerUserInfoTable = @"Table2";

#define InputViewheight             64
#define ChatHeadheight              50

@implementation AYGroupChatController {
    
    NSString* owner_id;
//    NSNumber* group_id;
    NSString* user_id;
    NSString* theme;
    
    dispatch_semaphore_t semaphore_owner_info;
    __block BOOL owner_info_success;
    __block NSDictionary* owner_info_result;
   
    dispatch_semaphore_t semaphore_msg_lst;
    __block NSMutableArray* current_messages;
    
    id messageNote;
    NSDictionary *order_info;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        NSDictionary* args = [dic objectForKey:kAYControllerChangeArgsKey];
        
        owner_id = [args objectForKey:@"owner_id"];
        user_id = [args objectForKey:@"user_id"];
        
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
    self.view.backgroundColor = [Tools garyBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    count = 0;
    
    UIView* table_view = [self.views objectForKey:kAYGroupChatControllerMessageTable];
    [self.view sendSubviewToBack:table_view];
    
//setGroupChatViewInfo:
    NSDictionary* info = nil;
    CURRENUSER(info)
    id<AYFacadeBase> facade = [self.facades objectForKey:@"OrderRemote"];
    AYRemoteCallCommand *cmd_query = [facade.commands objectForKey:@"QueryOwnOrders"];
    NSMutableDictionary *dic_query = [[NSMutableDictionary alloc]init];
    [dic_query setValue:[info objectForKey:@"user_id"] forKey:@"user_id"];
    [dic_query setValue:owner_id forKey:@"owner_id"];
    
    [cmd_query performWithResult:[dic_query copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
            id args = [(NSArray*)result firstObject];
            order_info = args;
            kAYViewsSendMessage(@"", @"setGroupChatViewInfo:", &args)
        }
        
    }];
    
    semaphore_owner_info = dispatch_semaphore_create(0);
//    semaphore_join_lst = dispatch_semaphore_create(0);
    semaphore_msg_lst = dispatch_semaphore_create(0);
    
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
   
//    [self waitForControllerReady];
//    [self queryOwnerInfo];
//    [self enterChatGroup];
    [self queryEMMessages];
    
    UIView* view_table = [self.views objectForKey:@"Table"];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapElseWhere:)];
    [view_table addGestureRecognizer:tap];
    
    NSDictionary* user = nil;
    CURRENUSER(user);
//    BOOL isOwner = [[user objectForKey:@"user_id"] isEqualToString:owner_id];
    
    id<AYFacadeBase> f = DEFAULTFACADE(@"ScreenNameAndPhotoCache");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"QueryScreenNameAndPhoto"];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:owner_id forKey:@"user_id"];
    
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            NSString* user_name = [result objectForKey:@"screen_name"];
            kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &user_name)
        }
    }];
    
}

- (void)clearController {
    [super clearController];
    
    id<AYFacadeBase> f = USERCACHE;
    id<AYCommand> cmd = [f.commands objectForKey:@"ReleaseScreenNameAndPhoto"];
    [cmd performWithResult:nil];
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
    id<AYCommand> cmd_title = [bar.commands objectForKey:@"setTitleText:"];
    NSString *title = @"沟通";
    [cmd_title performWithResult:&title];
    
    id<AYCommand> cmd_left = [bar.commands objectForKey:@"setLeftBtnImg:"];
    UIImage* left = IMGRESOURCE(@"bar_left_black");
    [cmd_left performWithResult:&left];
    
    id<AYCommand> cmd_right_vis = [bar.commands objectForKey:@"setRightBtnVisibility:"];
    NSNumber* right_hidden = [NSNumber numberWithBool:YES];
    [cmd_right_vis performWithResult:&right_hidden];
    
    id<AYCommand> cmd_bot = [bar.commands objectForKey:@"setBarBotLine"];
    [cmd_bot performWithResult:nil];
    
    return nil;
}

- (id)GroupChatHeaderLayout:(UIView*)view {
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, ChatHeadheight);
    view.backgroundColor = [UIColor whiteColor];
    
    return nil;
}

- (id)TableLayout:(UIView*)view {
    
    view.frame = CGRectMake(0, 64+ChatHeadheight, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44 - ChatHeadheight);
    view.backgroundColor = [UIColor clearColor];
    //预设高度
    ((UITableView*)view).estimatedRowHeight = 90;
    ((UITableView*)view).rowHeight = UITableViewAutomaticDimension;
    return nil;
}

- (id)ChatInputLayout:(UIView*)view {
    view.frame = CGRectMake(0, SCREEN_HEIGHT - InputViewheight, SCREEN_WIDTH, InputViewheight);
    return nil;
}

#pragma mark -- notifications
- (id)leftBtnSelected {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic];
    return nil;
}

- (id)didChatOrderDetailClick {
    
    id<AYCommand> des = DEFAULTCONTROLLER(@"OrderInfo");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:[order_info copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = PUSH;
    [cmd_show_module performWithResult:&dic];
    return nil;
}

- (id)EMMessageSendSuccess:(id)args {
    NSLog(@"send message success");
    
    NSDictionary* dic = (NSDictionary*)args;
    EMMessage* m = (EMMessage*)[dic objectForKey:@"message"];
    if ([m.conversationId isEqualToString:owner_id]) {
        [current_messages addObject:m];
    }
    
    [self setMessagesToDelegate];
    [self scrollTableToFoot:YES];
    return nil;
}

- (id)EMMessageSendFailed:(id)args {
    
    NSString *title = @"发送消息失败";
    AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
    return nil;
}

- (id)EMReceiveMessage:(id)args {
    NSLog(@"receive message success");
    
    NSDictionary* dic = (NSDictionary*)args;
    EMMessage* m = (EMMessage*)[dic objectForKey:@"message"];
    if ([m.conversationId isEqualToString:owner_id] && messageNote != m) {
        [current_messages addObject:m];
    }
    messageNote = m;
    
    [self setMessagesToDelegate];
    [self scrollTableToFoot:YES];
    return nil;
}

#pragma mark -- actions
- (id)sendMessage:(id)args {
    NSString* text = (NSString*)args;
    
    id<AYFacadeBase> f = [self.facades objectForKey:@"EM"];
    id<AYCommand> cmd = [f.commands objectForKey:@"SendEMMessage"];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:text forKey:@"text"];
    [dic setValue:owner_id forKey:@"owner_id"];
    
    [cmd performWithResult:&dic];
    return nil;
}

- (void)scrollTableToFoot:(BOOL)animated {
    UITableView* queryView = [self.views objectForKey:kAYGroupChatControllerMessageTable];
    
    NSInteger s = [queryView numberOfSections];
    if (s<1) return;
    NSInteger r = [queryView numberOfRowsInSection:s-1];
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    [queryView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
//    if (queryView.contentSize.height > queryView.frame.size.height)
//    {
//        CGPoint offset = CGPointMake(0, queryView.contentSize.height - queryView.frame.size.height);
//        [queryView setContentOffset:offset animated:animated];
//    }
//    [queryView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionBottom animated:animated];
    
}

#pragma mark -- get input view height
- (id)KeyboardShowKeyboard:(id)args {
    
    NSNumber* step = [(NSDictionary*)args objectForKey:kAYNotifyKeyboardArgsHeightKey];
    
    UIView *inputView = [self.views objectForKey:@"ChatInput"];
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    
    [UIView animateWithDuration:0.3f animations:^{
        
//        inputView.center = CGPointMake(inputView.center.x, inputView.center.y - step.floatValue);
//        table_view.center = CGPointMake(table_view.center.x, table_view.center.y - step.floatValue);
        
        ((UIView*)inputView).frame = CGRectMake(0, SCREEN_HEIGHT - InputViewheight - step.floatValue, SCREEN_WIDTH, InputViewheight);
        ((UIView*)view_table).frame = CGRectMake(0, kStatusAndNavBarH - step.floatValue, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH  - InputViewheight);
        
//        self.view.center = CGPointMake(self.view.center.x, SCREEN_HEIGHT / 2 - step.floatValue);
    }];
    
    return nil;
}

- (id)KeyboardHideKeyboard:(id)args {
    id<AYViewBase> inputView = [self.views objectForKey:@"ChatInput"];
    id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
    
    [UIView animateWithDuration:0.3f animations:^{
//        self.view.center = CGPointMake(self.view.center.x, SCREEN_HEIGHT / 2);
        ((UIView*)inputView).frame = CGRectMake(0, SCREEN_HEIGHT - InputViewheight, SCREEN_WIDTH, InputViewheight);
        ((UIView*)view_table).frame = CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH - InputViewheight);
    }];
    
    return nil;
}

- (void)tapElseWhere:(UITapGestureRecognizer*)gusture {
    id<AYViewBase> view = [self.views objectForKey:@"ChatInput"];
    id<AYCommand> cmd = [view.commands objectForKey:@"resignFocus"];
    [cmd performWithResult:nil];
}

#pragma mark -- block user interaction

#pragma mark -- query user info
- (void)waitForControllerReady {
    dispatch_queue_t qw = dispatch_queue_create("query data wait", nil);
    dispatch_async(qw, ^{
        dispatch_semaphore_wait(semaphore_owner_info, dispatch_time(DISPATCH_TIME_NOW, 30.f * NSEC_PER_SEC));
//        dispatch_semaphore_wait(semaphore_join_lst, dispatch_time(DISPATCH_TIME_NOW, 30.f * NSEC_PER_SEC));
        dispatch_semaphore_wait(semaphore_msg_lst, dispatch_time(DISPATCH_TIME_NOW, 30.f * NSEC_PER_SEC));
        
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
//    [dic setValue:owner_info_result forKey:@"owner"];
//    [dic setValue:join_lst_result forKey:@"joiners"];
//    [dic setValue:join_count forKey:@"count"];
    
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
    
    [self scrollTableToFoot:YES];
}

#pragma mark -- create chat
- (void)createChat {
    
    id<AYFacadeBase> em = [self.facades objectForKey:@"EM"];
    id<AYCommand> cmd = [em.commands objectForKey:@"CreateEMChat"];
    id conversationID = owner_id;
    
    [cmd performWithResult:&conversationID];
}

- (void)queryEMMessages {
    id<AYFacadeBase> em = [self.facades objectForKey:@"EM"];
    id<AYCommand> cmd = [em.commands objectForKey:@"QueryEMMessages"];
    id brige_id_message = owner_id;
    
    [cmd performWithResult:&brige_id_message];
    
    current_messages = [(NSArray*)brige_id_message mutableCopy];
    NSLog(@"michauxs -- %@", current_messages);
    
    if (current_messages.count == 0) {
        [self createChat];
    } else {
        [self setMessagesToDelegate];
        [self scrollTableToFoot:NO];
    }
}

#pragma mark -- enter group chat
//- (id)EMGetGroupMemberSuccess:(id)args {
//    join_lst_success = YES;
//    join_lst_result = [args objectForKey:@"result"];
//    dispatch_semaphore_signal(semaphore_join_lst);   
//    return nil;
//}

- (void)GroupChatControllerIsReady {
    UIView* loading = [self.views objectForKey:@"Loading"];
    loading.hidden = YES;
    [loading removeFromSuperview];
    id<AYCommand> cmd = [((id<AYViewBase>)loading).commands objectForKey:@"stopGif"];
    [cmd performWithResult:nil];
}
@end
