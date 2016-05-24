//
//  MessageNotificationDetailCell.m
//  BabySharing
//
//  Created by Alfred Yang on 10/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import "AYNotificationCellView.h"
#import "TmpFileStorageModel.h"
#import "Notifications.h"
#import "Tools.h"

#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYNotificationCellDefines.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"

#import "QueryContent.h"
#import "QueryContentItem.h"

#define MARGIN  8
#define IMG_WIDTH       38
#define IMG_HEIGHT      IMG_WIDTH
#define CONTENT_WIDTH   50
#define CONTENT_HEIGHT  CONTENT_WIDTH
#define MARGIN_RIGHT    10.5

#define LINE_MARGIN     4

#define TIME_POSITION_MODIFY            3

@interface AYNotificationCellView ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *connectContentView;
@property (strong, nonatomic) UILabel *postTimeLabel;
//@property (strong, nonatomic) UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerConstraint;

@property (nonatomic, strong) NSString *receiver_id;
@end

@implementation AYNotificationCellView

@synthesize imageView = _imageView;
@synthesize connectContentView = _connectContentView;
@synthesize notification = _notification;

//@synthesize connections = _connections;
@synthesize sender_id = _sender_id;
@synthesize receiver_id = _receiver_id;

//@synthesize postTimeLabel = _postTimeLabel;
//@synthesize detailLabel = _detailLabel;

+ (CGFloat)preferedHeight {
    return 80;
}

- (void)awakeFromNib {
    // Initialization code
    _imgView.layer.borderWidth = 1.5f;
    _imgView.layer.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25f].CGColor;
    _imgView.layer.cornerRadius = 19.f;
    _imgView.clipsToBounds = YES;
    _imgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(senderImgSelected:)];
    [_imgView addGestureRecognizer:tap];
    
    CALayer* line = [CALayer layer];
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.30].CGColor;
    line.borderWidth = 1.f;
    line.frame = CGRectMake(10.5, 80 - 1, [UIScreen mainScreen].bounds.size.width - 10.5 * 2, 1);
    [self.layer addSublayer:line];
    
    _detailLabel.font = [UIFont systemFontOfSize:13.f];
    _detailLabel.numberOfLines = 0;
    _detailLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    _postTimeLabel = [[UILabel alloc]init];
    _postTimeLabel.font = [UIFont systemFontOfSize:11.f];
    _postTimeLabel.textColor = [UIColor colorWithWhite:151.f / 255.f alpha:1.f];
    [self addSubview:_postTimeLabel];
    
    [self setUpReuseCell];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat kScreenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat cellH = 80;
//    CGFloat detailW = _detailLabel.frame.size.width;
    CGFloat detailH = _detailLabel.frame.size.height;
    CGFloat timeW = _postTimeLabel.frame.size.width;
    CGFloat timeH = _postTimeLabel.frame.size.height;
    
    CGSize sz = [Tools sizeWithString:_detailLabel.text withFont:_detailLabel.font andMaxSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    CGSize sz2 = [Tools sizeWithString:_postTimeLabel.text withFont:_postTimeLabel.font andMaxSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    CGFloat max_width = kScreenW - IMG_WIDTH - CONTENT_WIDTH - 4 * MARGIN;

    if (sz.width + sz2.width < max_width) {
        _centerConstraint.constant = 0;
        _postTimeLabel.frame = CGRectMake(CGRectGetMaxX(_detailLabel.frame)+MARGIN, (cellH - timeH)/2 - 1, timeW, timeH);
    }else if(sz.width < max_width){
        _centerConstraint.constant = 0;
        _centerConstraint.constant -= detailH/2;
        _postTimeLabel.frame = CGRectMake(56, 40 + 2, timeW, timeH);
    }else if (sz.width > max_width){
        _centerConstraint.constant = 0;
        _postTimeLabel.frame = CGRectMake( 56 + sz.width - max_width + MARGIN, 40 + 4, timeW, timeH);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString*)getActtionTmplate:(NotificationActionType)type {
    
    NSString* reVal = @"not implemented";
    switch (type) {
        case NotificationActionTypeFollow:
            reVal = @"is now following you";
            break;
        case NotificationActionTypeUnFollow:
        case NotificationActionTypeLike:
        case NotificationActionTypePush:
        case NotificationActionTypeMessage:
            break;
            
        default:
            break;
    }
    return reVal;
}

- (void)setUserImage:(NSString*)photo_name {
    
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:photo_name forKey:@"image"];
    [dic setValue:@"img_icon" forKey:@"expect_size"];
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        UIImage* img = (UIImage*)result;
        if (img != nil) {
           [self.imgView setImage:img];
        }else
            [self.imgView setImage:PNGRESOURCE(@"default_user")];
    }];
}

- (void)UIImageView:(UIImageView*)imgView setPostImage:(NSString*)photo_name {
    
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:photo_name forKey:@"image"];
    [dic setValue:@"img_icon" forKey:@"expect_size"];
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        UIImage* img = (UIImage*)result;
        if (img != nil) {
            [imgView setImage:img];
        }else
//            [imgView setImage:PNGRESOURCE(@"default_user")];
            [imgView setBackgroundColor:[UIColor colorWithWhite:0.92 alpha:1.f]];
    }];
}

- (void)setDetailTarget:(NSString*)screen_name andActionType:(NotificationActionType)type andConnectContent:(NSString*)Post_id {
    if (screen_name == nil) {
        screen_name = self.notification.sender_screen_name;
    }
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:LINE_MARGIN];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    switch (type) {
        case NotificationActionTypeFollow: {
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[screen_name stringByAppendingString:@" 关注了你"]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70.f / 255.f green:219.f / 255.f blue:202.f / 255.f alpha:1.f] range:NSMakeRange(0,screen_name.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:151.f / 255.f alpha:1.f] range:NSMakeRange(screen_name.length + 1, 4)];
            
            [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
            
            _detailLabel.attributedText = str;

            
//            tmp_f.image = PNGRESOURCE(@"command_following");
            
            }
            break;
        case NotificationActionTypeUnFollow:
        case NotificationActionTypeLike: {
            
            NSString* sender_name = _notification.sender_screen_name;
            NSString* receiver_id = _notification.receiver_screen_name;
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[[[sender_name stringByAppendingString:@" 赞了 "] stringByAppendingString:receiver_id] stringByAppendingString:@" 的照片"]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70.f / 255.f green:219.f / 255.f blue:202.f / 255.f alpha:1.f] range:NSMakeRange(0,sender_name.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70.f / 255.f green:219.f / 255.f blue:202.f / 255.f alpha:1.f] range:NSMakeRange(sender_name.length + 4, receiver_id.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:151.f / 255.f alpha:1.f] range:NSMakeRange(sender_name.length, 4)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:151.f / 255.f alpha:1.f] range:NSMakeRange(sender_name.length + 4 + receiver_id.length, 4)];
            
            [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
            
            _detailLabel.attributedText = str;
            
            UIImageView* tmp = [_connectContentView viewWithTag:-88];
            tmp.image = nil;
            if (tmp == nil) {
                tmp = [[UIImageView alloc]init];
                [_connectContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [_connectContentView addSubview:tmp];
                tmp.tag = -88;
                
                tmp.frame = CGRectMake(0, 0, 45, 45);
                tmp.center = CGPointMake(25, 25);
                tmp.layer.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.3].CGColor;
                tmp.layer.borderWidth = 1.f;
                tmp.layer.cornerRadius = 5.f;
                tmp.clipsToBounds = YES;
                
                tmp.userInteractionEnabled = YES;
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(postContentClicked:)];
                [tmp addGestureRecognizer:tap];
            }
            
            [self UIImageView:tmp setPostImage:_notification.action_post_item];

            }
            break;
        case NotificationActionTypePush: {
            NSString* sender_name = _notification.sender_screen_name;
            NSString* receiver_id = _notification.receiver_screen_name;
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[[[sender_name stringByAppendingString:@" 咚了 "] stringByAppendingString:receiver_id] stringByAppendingString:@" 的照片"]];
            [str addAttribute:NSForegroundColorAttributeName value:[Tools colorWithRED:70.f GREEN:219.f BLUE:202.f ALPHA:1.f] range:NSMakeRange(0,sender_name.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[Tools colorWithRED:70.f GREEN:219.f BLUE:202.f ALPHA:1.f] range:NSMakeRange(sender_name.length + 4, receiver_id.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:151.f / 255.f alpha:1.f] range:NSMakeRange(sender_name.length, 4)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:151.f / 255.f alpha:1.f] range:NSMakeRange(sender_name.length + 4 + receiver_id.length, 4)];
            
            [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
            
            _detailLabel.attributedText = str;
            
            UIImageView* tmp = [_connectContentView viewWithTag:-88];
            tmp.image = nil;
            if (tmp == nil) {
                tmp = [[UIImageView alloc]init];
                [_connectContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [_connectContentView addSubview:tmp];
                tmp.tag = -88;
                
                tmp.frame = CGRectMake(0, 0, 45, 45);
                tmp.center = CGPointMake(25, 25);
                tmp.layer.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.3].CGColor;
                tmp.layer.borderWidth = 1.f;
                tmp.layer.cornerRadius = 5.f;
                tmp.clipsToBounds = YES;
                
                tmp.userInteractionEnabled = YES;
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(postContentClicked:)];
                [tmp addGestureRecognizer:tap];
            }
            [self UIImageView:tmp setPostImage:_notification.action_post_item];
            
            }
            break;
        case NotificationActionTypeUnlike: {
            NSString* sender_name = _notification.sender_screen_name;
            NSString* receiver_id = _notification.receiver_screen_name;
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[[[sender_name stringByAppendingString:@" 收回了赞 "] stringByAppendingString:receiver_id] stringByAppendingString:@" 的照片"]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70.f / 255.f green:219.f / 255.f blue:202.f / 255.f alpha:1.f] range:NSMakeRange(0,sender_name.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:70.f / 255.f green:219.f / 255.f blue:202.f / 255.f alpha:1.f] range:NSMakeRange(sender_name.length + 6, receiver_id.length)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:151.f / 255.f alpha:1.f] range:NSMakeRange(sender_name.length, 6)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:151.f / 255.f alpha:1.f] range:NSMakeRange(sender_name.length + 6 + receiver_id.length, 4)];
            
            [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
            
            _detailLabel.attributedText = str;
            
            UIImageView* tmp = [_connectContentView viewWithTag:-88];
            tmp.image = nil;
            if (tmp == nil) {
                tmp = [[UIImageView alloc]init];
                [_connectContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [_connectContentView addSubview:tmp];
                tmp.tag = -88;
                
                tmp.frame = CGRectMake(0, 0, 45, 45);
                tmp.center = CGPointMake(25, 25);
                tmp.layer.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.3].CGColor;
                tmp.layer.borderWidth = 1.f;
                tmp.layer.cornerRadius = 5.f;
                tmp.clipsToBounds = YES;
                
                tmp.userInteractionEnabled = YES;
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(postContentClicked:)];
                [tmp addGestureRecognizer:tap];
            }
            [self UIImageView:tmp setPostImage:_notification.action_post_item];
            
            }
            break;
        case NotificationActionTypeUnpush:
            break;
            
        default:
            break;
    }
    [_detailLabel sizeToFit];
}

- (void)setTimeLabel:(NSDate*)time_label {
    _postTimeLabel.text = [Tools compareCurrentTime:time_label];
    [_postTimeLabel sizeToFit];
}

- (void)setRelationShip:(UserPostOwnerConnections)connections {
    _connections = connections;
    
    UIImageView* tmp_f = [_connectContentView viewWithTag:-87];
    tmp_f.image = nil;
    if (tmp_f == nil) {
        [_connectContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        id<AYCommand> cmd = COMMAND(@"Module", @"NotifyFollowBtnInit");
        id args = [NSNumber numberWithInteger:_connections];
        [cmd performWithResult:&args];
        
        UIView* tmp_f = args;
        [_connectContentView addSubview:tmp_f];
        tmp_f.tag = -87;
        tmp_f.frame = CGRectMake(0, 0, 45, 20.5);
        tmp_f.center = CGPointMake(25 - 2, 25);
        
        ((id<AYViewBase>)tmp_f).controller = self;
    }

}
- (id)queryTargetID {
    id result = self.sender_id;
    return result;
}

- (id)relationChanged:(id)args {
    NSNumber* new_relations = (NSNumber*)args;
    NSLog(@"new relations %@", new_relations);
    _connections = new_relations.integerValue;
    
    UIImageView* tmp_f = [_connectContentView viewWithTag:-86];
    if (tmp_f == nil) {
        [_connectContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        id<AYCommand> cmd = COMMAND(@"Module", @"NotifyFollowBtnInit");
        id args = [NSNumber numberWithInteger:_connections];
        [cmd performWithResult:&args];
        
        UIView* tmp_f = args;
        [_connectContentView addSubview:tmp_f];
        tmp_f.tag = -86;
        tmp_f.frame = CGRectMake(0, 0, 45, 20.5);
        tmp_f.center = CGPointMake(25 - 2, 25);
        
        ((id<AYViewBase>)tmp_f).controller = self;
    }else
        [_connectContentView addSubview:tmp_f];
    return nil;
    
    //    [self setRelationship:new_relations.integerValue];
}

- (void)senderImgSelected:(UITapGestureRecognizer*)geture {
    UIViewController* des = DEFAULTCONTROLLER(@"Profile");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:_notification.sender_id forKey:kAYControllerChangeArgsKey];
    
    [_controller performWithResult:&dic_push];
}

- (void)postContentClicked:(UITapGestureRecognizer*)geture {
    
    UIImageView *tapView = (UIImageView*)geture.view;
    NSLog(@"sunfei -- %@",tapView.image);
    NSLog(@"sunfei -- %@",self.notification.action_post_item);
    
    //home content
    id<AYFacadeBase> f_owner_query = HOMECONTENTMODEL;
    id<AYCommand> cmd_owner_query = [f_owner_query.commands objectForKey:@"EnumHomeQueryData"];
    NSArray* arr_h = nil;
    [cmd_owner_query performWithResult:&arr_h];
    NSArray* contentArr = nil;
    for (QueryContent* content  in arr_h) {
        for (QueryContentItem* item in content.items) {
            if ([item.item_name isEqualToString:self.notification.action_post_item]) {
                contentArr = @[content];
                NSLog(@"sunfei item -- %@",item.item_name);
            }
        }
    }
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [args setValue:@"点赞详情" forKey:@"home_title"];
    [args setValue:[NSNumber numberWithInteger:0] forKey:@"start_index"];
    [args setValue:contentArr forKey:@"content"];
    
    UIViewController* des = DEFAULTCONTROLLER(@"Home");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[args copy] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(kAYNotificationCellName, kAYNotificationCellName);
    
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
    return [NSNumber numberWithFloat:[AYNotificationCellView preferedHeight]];
}

- (id)setCellInfo:(id)args {
    
    NSDictionary* dic = (NSDictionary*)args;
    
    id content = [dic objectForKey:kAYNotificationCellContentKey];
    AYNotificationCellView* cell = [dic objectForKey:kAYNotificationCellCellKey];
    
    cell.notification = content;
    
    return nil;
}

- (void)setCurrentContent:(Notifications*)tmp {
    _notification = tmp;
    
    [self setUserImage:tmp.sender_screen_photo];
    [self setDetailTarget:tmp.sender_screen_name andActionType:tmp.type.integerValue andConnectContent:nil];
    [self setTimeLabel:tmp.date];
    [self setSender_id:tmp.sender_id];
    [self setReceiver_id:tmp.receiver_id];
    
    if (tmp.type.integerValue == 0) {
        
        id<AYFacadeBase> f = DEFAULTFACADE(@"RelationshipRemote");
        AYRemoteCallCommand* cmd_query_relations = [f.commands objectForKey:@"QueryFollowing"];
        NSDictionary* user = nil;
        CURRENUSER(user)
        
        NSMutableDictionary* dic = [user mutableCopy];
        [dic setValue:[user objectForKey:@"user_id"] forKey:@"owner_id"];
        [dic setValue:_sender_id forKey:@"follow_user_id"];
        
        [cmd_query_relations performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
                NSArray *reArray = [result objectForKey:@"following"];
                for (NSDictionary *tmp in reArray) {
                    if ([[tmp objectForKey:@"user_id"] isEqualToString:_sender_id]) {
                        [self setRelationship:2];
                        _connections = 2;
                        break ;
                    }
                }
//                [self setRelationship:0];
                _connections = 0;
                UIImageView* tmp_f = [_connectContentView viewWithTag:-87];
                if (tmp_f == nil) {
                    
                    [_connectContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    id<AYCommand> cmd = COMMAND(@"Module", @"NotifyFollowBtnInit");
                    id args = [NSNumber numberWithInteger:_connections];
                    [cmd performWithResult:&args];
                    
                    UIView* tmp_f = args;
                    [_connectContentView addSubview:tmp_f];
                    tmp_f.tag = -87;
                    
                    tmp_f.frame = CGRectMake(0, 0, 45, 20.5);
                    tmp_f.center = CGPointMake(25 - 2, 25);
                    
                    ((id<AYViewBase>)tmp_f).controller = self;
                }else
                [_connectContentView addSubview:tmp_f];
            }
        }];
    }
}
@end
