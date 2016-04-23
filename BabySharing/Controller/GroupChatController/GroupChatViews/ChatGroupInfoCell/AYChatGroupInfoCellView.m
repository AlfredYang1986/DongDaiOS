//
//  MessageChatGroupInfoCell.m
//  BabySharing
//
//  Created by Alfred Yang on 1/28/16.
//  Copyright © 2016 BM. All rights reserved.
//

#import "AYChatGroupInfoCellView.h"
#import "TmpFileStorageModel.h"

#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYNotificationCellDefines.h"
#import "AYChatGroupInfoCellDefines.h"

#define USER_INFO_BACK_BTN_HEIGHT           30
#define USER_INFO_BACK_BTN_WIDTH            30

@interface AYChatGroupInfoCellView ()
@property (weak, nonatomic) IBOutlet UIView *user_list_view;
@property (weak, nonatomic) IBOutlet UILabel* online_count_label;

@end

@implementation AYChatGroupInfoCellView {
    UIButton* back_btn;
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

- (void)setChatGroupUserList:(NSArray*)user_lst {
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
            
            NSString* photo_name = [user_dic objectForKey:@"screen_photo"];
            UIImage* userImg = [TmpFileStorageModel enumImageWithName:photo_name withDownLoadFinishBolck:^(BOOL success, UIImage *user_img) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self) {
                            [tmp setBackgroundImage:user_img forState:UIControlStateNormal];
                            NSLog(@"owner img download success");
                        }
                    });
                } else {
                    NSLog(@"down load owner image %@ failed", photo_name);
                }
            }];
            
            if (userImg == nil) {
                userImg = PNGRESOURCE(@"screen_photo");
            }
            [tmp setBackgroundImage:userImg forState:UIControlStateNormal];
            [_user_list_view addSubview:tmp];
            
            offset += PHOTO_WIDTH + PHOTO_MARGIN;
        }
    });
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(kAYChatGroupInfoCellName, kAYChatGroupInfoCellName);
    self.commands = [[cell commands] copy];
    self.notifies = [[cell notifies] copy];
    
    for (AYViewCommand* cmd in self.commands.allValues) {
        cmd.view = self;
    }
    
    for (AYViewNotifyCommand* nty in self.notifies.allValues) {
        nty.view = self;
    }
    
    NSLog(@"reuser view with commands : %@", self.commands);
    NSLog(@"reuser view with notifications: %@", self.notifies);
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
