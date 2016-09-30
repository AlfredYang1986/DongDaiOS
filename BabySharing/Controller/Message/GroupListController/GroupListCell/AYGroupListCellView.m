//
//  CycleOverCell.m
//  BabySharing
//
//  Created by Alfred Yang on 18/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "AYGroupListCellView.h"
#import "OBShapedButton.h"
#import "Targets.h"
#import "GotyeOCAPI.h"
#import "Tools.h"

#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYGroupListCellDefines.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

#import "EMConversation.h"
#import "EMMessage.h"
#import "EMTextMessageBody.h"

#define BRAGE_WIDTH     25
#define BRAGE_HEIGHT    BRAGE_WIDTH

@implementation AYGroupListCellView {
    OBShapedButton* brage;
}

@synthesize themeLabel = _themeLabel;
@synthesize themeImg = _themeImg;
@synthesize chatLabel = _chatLabel;
@synthesize timeLabel = _timeLabel;

@synthesize current_session = _current_session;
@synthesize screen_name = _screen_name;

+ (CGFloat)preferredHeight {
    return 90;
}

- (void)setSession:(Targets *)current_session {
    _current_session = current_session;
   
    [self changeImage];
    [self changeThemeText];
    [self changeUnreadLabel];
    NSLog(@"MonkeyHengLog: %@ === %lld", @"_current_session.group_id.longLongValue", _current_session.group_id.longLongValue);

    GotyeOCGroup* group = [GotyeOCGroup groupWithId:_current_session.group_id.longLongValue];
    GotyeOCMessage* m = [GotyeOCAPI getLastMessage:group];
   
    [self changeMessageTextWithMessage:m];
    [self changeTimeTextWithMessage:m];
  
    // TODO : 我日 以后改
    if (_screen_name == nil) {
        
    }
}

- (void)changeUnreadLabel {
    GotyeOCGroup* group = [GotyeOCGroup groupWithId:_current_session.group_id.longLongValue];
    int count = [GotyeOCAPI getUnreadMessageCount:group];
    if (count > 0) {
        brage.hidden = NO;
        NSString* str = [NSString stringWithFormat:@"%d", count];
        [brage setTitle:str forState:UIControlStateNormal];
    } else {
        brage.hidden = YES;
    }
}

- (void)changeThemeText {
    _themeLabel.text = _current_session.target_name;
}

- (void)changeMessageTextWithMessage:(GotyeOCMessage*)m {
    if (![m.text isEqualToString:@""]) {
        _chatLabel.text = [[_screen_name stringByAppendingString:@" : "] stringByAppendingString:m.text];
    }
}

- (void)changeTimeTextWithMessage:(GotyeOCMessage *)m {
    if ([GotyeOCAPI getUnreadMessageCount:[GotyeOCGroup groupWithId:_current_session.group_id.longLongValue]] == 0) {
        _timeLabel.text = @"";
        return;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSTimeInterval now_time = [NSDate date].timeIntervalSince1970;
    if (now_time - m.date > 24 * 60 * 60) {
        [formatter setDateFormat:@"MM-dd"];
    } else {
        [formatter setDateFormat:@"hh:mm"];
    }
    NSLog(@"MonkeyHengLog: %f === %u", now_time, m.date);
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:m.date];
    
    _timeLabel.text = [Tools compareCurrentTime:date];
}

- (void)changeImage {
    [self.themeImg setImage:IMGRESOURCE(@"default_user")];
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:_current_session.post_thumb forKey:@"image"];
    [dic setValue:@"img_icon" forKey:@"expect_size"];
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        UIImage* img = (UIImage*)result;
        if (img != nil) {
            [self.themeImg setImage:img];
        }
    }];
}

- (void)awakeFromNib {
    // Initialization code
    _themeImg.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25].CGColor;
    _themeImg.layer.borderWidth = 2.f;
    _themeImg.layer.cornerRadius = 22.5f;
    _themeImg.clipsToBounds = YES;
    
//    brage = [[OBShapedButton alloc] init];
//    [brage setBackgroundImage:PNGRESOURCE(@"chat_round") forState:UIControlStateNormal];
//    brage.frame = CGRectMake(0, 0, BRAGE_WIDTH, BRAGE_HEIGHT);
//    brage.center = CGPointMake(48 + BRAGE_WIDTH / 2, 5.5 + BRAGE_HEIGHT / 2);
//    [brage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [brage setTitle:@"10" forState:UIControlStateNormal];
//    brage.titleLabel.font = [UIFont systemFontOfSize:12.f];
//    [self addSubview:brage];
    
    [self setUpReuseCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(kAYGroupListCellName, kAYGroupListCellName);
    
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
- (id)queryContentCellHeight {
    return [NSNumber numberWithFloat:[AYGroupListCellView preferredHeight]];
}

- (id)resetContent:(id)args {
    NSDictionary* dic = (NSDictionary*)args;
    
    EMConversation *sation = [dic objectForKey:kAYGroupListCellContentKey];
//    AYGroupListCellView* cell = [dic objectForKey:kAYGroupListCellCellKey];
//    cell.current_session = t;
    
    EMMessage *last_message = sation.latestMessage;
    
    if (last_message.isRead) {
        _iconImage.hidden = YES;
    } else {
        _iconImage.hidden = NO;
    }
    
    NSString *user_id = nil;
    if (last_message.direction == 0) {
        user_id = last_message.to;
    } else {
        user_id = last_message.from;
    }
    NSLog(@"%@",user_id);
    
    id<AYFacadeBase> f_name_photo = DEFAULTFACADE(@"ScreenNameAndPhotoCache");
    AYRemoteCallCommand* cmd_name_photo = [f_name_photo.commands objectForKey:@"QueryScreenNameAndPhoto"];
    
    NSMutableDictionary* dic_owner_id = [[NSMutableDictionary alloc]init];
    [dic_owner_id setValue:user_id forKey:@"user_id"];
    
    [cmd_name_photo performWithResult:[dic_owner_id copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        _themeLabel.text = [result objectForKey:@"screen_name"];
        
        id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
        AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:[result objectForKey:@"screen_photo"] forKey:@"image"];
        [dic setValue:@"img_icon" forKey:@"expect_size"];
        [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            UIImage* img = (UIImage*)result;
            if (img != nil) {
                [_themeImg setImage:img];
            } else
                _themeImg.image = IMGRESOURCE(@"default_user");
        }];
        
    }];
    
    _chatLabel.text = ((EMTextMessageBody*)last_message.body).text;
    
    [self setContentDate:last_message.timestamp];
    
    return nil;
}

- (void)setContentDate:(NSTimeInterval)date {
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date*0.001];
    _timeLabel.text = [Tools compareCurrentTime:date2];
}

@end
