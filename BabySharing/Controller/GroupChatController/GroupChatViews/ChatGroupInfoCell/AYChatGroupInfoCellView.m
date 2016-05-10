//
//  MessageChatGroupInfoCell.m
//  BabySharing
//
//  Created by Alfred Yang on 1/28/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "AYChatGroupInfoCellView.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYNotificationCellDefines.h"
#import "AYChatGroupInfoCellDefines.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYControllerActionDefines.h"

#define USER_INFO_BACK_BTN_HEIGHT           30
#define USER_INFO_BACK_BTN_WIDTH            30

@interface AYChatGroupInfoCellView ()
@property (weak, nonatomic) IBOutlet UIView *user_list_view;
@property (weak, nonatomic) IBOutlet UILabel* online_count_label;

@end

@implementation AYChatGroupInfoCellView {
    UIButton* back_btn;
    
    NSArray* user_lst;
}

@synthesize user_list_view = _user_list_view;
@synthesize online_count_label = _online_count_label;

- (void)awakeFromNib {
    // Initialization code
    _user_list_view.backgroundColor = [UIColor clearColor];
    
    _online_count_label.font = [UIFont systemFontOfSize:14.f];
    _online_count_label.textColor = [UIColor colorWithWhite:0.2902 alpha:1.f];
    
    if (back_btn == nil) {
        back_btn = [[UIButton alloc]init];
        CALayer* layer = [CALayer layer];
        layer.contents = (id)PNGRESOURCE(@"group_chat").CGImage;
        layer.frame = CGRectMake(0, 0, 22, 22);
        layer.position = CGPointMake(USER_INFO_BACK_BTN_WIDTH / 2, USER_INFO_BACK_BTN_HEIGHT / 2);
        
        //  [back_btn setBackgroundImage:[UIImage imageNamed:[resourceBundle_dongda pathForResource:@"dongda_next_light" ofType:@"png"]] forState:UIControlStateNormal];
        [back_btn addTarget:self action:@selector(userInfo2InputView) forControlEvents:UIControlEventTouchUpInside];
        back_btn.frame = CGRectMake(self.bounds.size.width - USER_INFO_BACK_BTN_WIDTH - 10.5, 10.5, USER_INFO_BACK_BTN_WIDTH, USER_INFO_BACK_BTN_HEIGHT);
        [back_btn.layer addSublayer:layer];
        [self addSubview:back_btn];
        [self bringSubviewToFront:back_btn];
    }
    
    [self setUpReuseCell];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    back_btn.frame = CGRectMake(self.bounds.size.width - USER_INFO_BACK_BTN_WIDTH - 10.5, 10.5, USER_INFO_BACK_BTN_WIDTH, USER_INFO_BACK_BTN_HEIGHT);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#define PREFERRED_HEIGHT            115

+ (CGFloat)preferredHeight {
    return PREFERRED_HEIGHT;
}

- (void)setChatGroupJoinerNumber:(NSNumber*)number {
    _online_count_label.text = [NSString stringWithFormat:@"%ld个人正在圈聊", (long)number.integerValue];
}

- (void)setChatGroupUserList:(NSArray*)lst {
    user_lst = lst;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (UIView* view in _user_list_view.subviews) {
            [view removeFromSuperview];
        }
       
#define PHOTO_WIDTH             40
#define PHOTO_HEIGHT            40
#define PHOTO_MARGIN            8
        
        CGFloat offset = 8;
        CGFloat offset_y = 38;
        for (int index = 0; index < MIN(user_lst.count, 6); ++index) {
            NSDictionary* user_dic = [user_lst objectAtIndex:index];
            UIButton* tmp = [[UIButton alloc]initWithFrame:CGRectMake(offset, offset_y / 2, PHOTO_WIDTH, PHOTO_HEIGHT)];
            tmp.layer.cornerRadius = PHOTO_HEIGHT / 2;
            tmp.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25f].CGColor;
            tmp.layer.borderWidth = 1.5f;
            tmp.clipsToBounds = YES;
            [tmp setBackgroundImage:PNGRESOURCE(@"default_user") forState:UIControlStateNormal];
            tmp.tag = index + 1;
            
            NSString* photo_name = [user_dic objectForKey:@"screen_photo"];
            
            id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
            AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            [dic setValue:photo_name forKey:@"image"];
            [dic setValue:@"img_icon" forKey:@"expect_size"];
            [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
                UIImage* img = (UIImage*)result;
                if (img != nil) {
                    [tmp setBackgroundImage:img forState:UIControlStateNormal];
                }
            }];
            [_user_list_view addSubview:tmp];
           
            [tmp addTarget:self action:@selector(headerTaped:) forControlEvents:UIControlEventTouchUpInside];
            
            offset += PHOTO_WIDTH + PHOTO_MARGIN;
        }
    });
}

- (void)headerTaped:(UIButton*)btn {
    NSInteger index = btn.tag - 1;
    
    NSDictionary* user_dic = [user_lst objectAtIndex:index];
    NSString* user_id = [user_dic objectForKey:@"user_id"];
   
    UIViewController* des = DEFAULTCONTROLLER(@"Profile");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:user_id forKey:kAYControllerChangeArgsKey];
    
    [_controller performWithResult:&dic_push];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(kAYChatGroupInfoCellName, kAYChatGroupInfoCellName);
    
    NSMutableDictionary* arr_commands = [[NSMutableDictionary alloc]initWithCapacity:cell.commands.count];
    for (NSString* name in cell.commands.allKeys) {
        AYViewCommand* cmd = [cell.commands objectForKey:name];
        AYViewCommand* c = [[AYViewCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_commands setValue:c forKey:name];
    }
    self.commands = [arr_commands copy];
    
    NSMutableDictionary* arr_notifies = [[NSMutableDictionary alloc]initWithCapacity:cell.notifies.count];
    for (NSString* name in cell.notifies.allKeys) {
        AYViewNotifyCommand* cmd = [cell.notifies objectForKey:name];
        AYViewNotifyCommand* c = [[AYViewNotifyCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_notifies setValue:c forKey:name];
    }
    self.notifies = [arr_notifies copy];
}

#pragma mark -- commands
- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

#pragma mark -- messages
- (id)queryCellHeight {
    return [NSNumber numberWithFloat:[AYChatGroupInfoCellView preferredHeight]];
}

- (id)setCellInfo:(id)args {
  
    AYChatGroupInfoCellView* cell = [args objectForKey:kAYChatGroupInfoCellCellKey];
    NSDictionary* dic = [args objectForKey:kAYChatGroupInfoCellContentKey];
    
    [cell setChatGroupJoinerNumber:[dic objectForKey:@"count"]];
    [cell setChatGroupUserList:[dic objectForKey:@"joiners"]];
    
    return nil;
}

#pragma mark -- actions
- (void)userInfo2InputView {
    id<AYCommand> cmd = [self.notifies objectForKey:@"hiddenChatGroupInfoPane"];
    [cmd performWithResult:nil];
}
@end
