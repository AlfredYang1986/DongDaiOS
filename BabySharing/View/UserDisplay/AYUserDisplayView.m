//
//  MessageFriendsCell.m
//  BabySharing
//
//  Created by Alfred Yang on 11/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "AYUserDisplayView.h"
#import "OBShapedButton.h"
#import "TmpFileStorageModel.h"

#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYUserDisplayDefines.h"
#import "AYViewController.h"
#import "Tools.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

#define IMG_WIDTH       40
#define IMG_HEIGHT      IMG_WIDTH

#define PREFERRED_HEIGHT    80

#define NAME_LEFT_MARGIN    10.5

@interface AYUserDisplayView ()
@property (weak, nonatomic) IBOutlet UIImageView *user_screen_photo;
@property (weak, nonatomic) IBOutlet UIView *relationContainer;
@property (nonatomic, strong) OBShapedButton* userRoleTagBtn;
@property (nonatomic, strong) UILabel* userNameLabel;
@end

@implementation AYUserDisplayView {
    CALayer* line;
}

@synthesize user_screen_photo = _user_screen_photo;
@synthesize relationContainer = _relationContainer;
@synthesize userRoleTagBtn = _userRoleTagBtn;
@synthesize userNameLabel = _userNameLabel;

@synthesize isHiddenLine = _isHiddenLine;
@synthesize lineMargin = _lineMargin;
@synthesize cellHeight = _cellHeight;
@synthesize isTopLine = _isTopLine;

//@synthesize delegate = _delegate;
@synthesize user_id = _user_id;
@synthesize connections = _connections;

+ (CGFloat)preferredHeight {
    return PREFERRED_HEIGHT;
}

- (void)setHiddenLine:(BOOL)isHiddenLine {
    _isHiddenLine = isHiddenLine;
    line.hidden = _isHiddenLine;
}

- (void)awakeFromNib {
    // Initialization code
    _user_screen_photo.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25].CGColor;
    _user_screen_photo.layer.borderWidth = 1.5f;
    _user_screen_photo.layer.cornerRadius = IMG_WIDTH / 2;
    _user_screen_photo.clipsToBounds = YES;
   
    _user_screen_photo.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectedScreenPhoto)];
    [_user_screen_photo addGestureRecognizer:tap];
   
    if (_userRoleTagBtn == nil) {
        _userRoleTagBtn = [[OBShapedButton alloc]init];
        [_userRoleTagBtn setBackgroundImage:PNGRESOURCE(@"home_role_tag") forState:UIControlStateNormal];
        [self addSubview:_userRoleTagBtn];
    }

    if (_userNameLabel == nil) {
        _userNameLabel = [[UILabel alloc]init];
        _userNameLabel.textColor = [UIColor colorWithWhite:0.4667 alpha:1.f];
        _userNameLabel.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:_userNameLabel];
    }
    
    line = [CALayer layer];
    line.borderWidth = 1.f;
    line.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
    line.frame = CGRectMake(_lineMargin, PREFERRED_HEIGHT - 1, self.bounds.size.width - 2 * _lineMargin, 1);
    [self.layer addSublayer:line];
    
    _cellHeight = [AYUserDisplayView preferredHeight];
    
    [self setUpReuseCell];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    if (layer == line) {
        line.frame = CGRectMake(_lineMargin, _cellHeight - 1, self.bounds.size.width - 2 * _lineMargin, 1);
    }
}

- (void)setUserScreenPhoto:(NSString*)photo_name {
   
    [_user_screen_photo setImage:PNGRESOURCE(@"default_user")];
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:photo_name forKey:@"image"];
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        UIImage* img = (UIImage*)result;
        if (img != nil) {
            [_user_screen_photo setImage:img];
        }
    }];
}

- (void)setRelationship:(UserPostOwnerConnections)connections {
    
    if (_connections != connections) {
         _connections = connections;
      
        UIView* tmp = [_relationContainer viewWithTag:-1];
        if (tmp) {
            [tmp removeFromSuperview];
        }
        
        id<AYCommand> cmd = COMMAND(@"Module", @"RelationshipBtnInit");
        id args = [NSNumber numberWithInteger:_connections];
        [cmd performWithResult:&args];
        UIView* btn = args;
        
        btn.tag = -1;
        btn.frame =  CGRectMake(0, 0, 69, 25);
        btn.center = CGPointMake(51, 25);
        [_relationContainer addSubview:btn];
        
        ((id<AYViewBase>)btn).controller = self;
    }
}

- (void)setUserScreenName:(NSString*)name {
    _userNameLabel.text = name;
    _userNameLabel.font = [UIFont systemFontOfSize:14.0f];
    [_userNameLabel sizeToFit];
#define TAG_2_NAME_MARGIN   10
#define USER_NAME_TOP_MARGIN    8
//    _userNameLabel.center = CGPointMake(_user_screen_photo.center.x + _user_screen_photo.frame.size.width / 2 + NAME_LEFT_MARGIN + _userNameLabel.frame.size.width / 2, PREFERRED_HEIGHT / 2);
    _userNameLabel.center = CGPointMake(_user_screen_photo.center.x + _user_screen_photo.frame.size.width / 2 + NAME_LEFT_MARGIN + _userNameLabel.frame.size.width / 2, _cellHeight / 2);
}

- (void)setUserRoleTag:(NSString*)role_tag {
    _userRoleTagBtn.hidden = NO;
    UILabel* label = [_userRoleTagBtn viewWithTag:-19];
    if (label == nil) {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12.f];
        label.textColor = [UIColor whiteColor];
        label.tag = -19;
        [_userRoleTagBtn addSubview:label];
    }
    
#define ROLE_TAG_MARGIN 2
    
    label.text = role_tag;
    [label sizeToFit];
    label.center = CGPointMake(5 + label.frame.size.width / 2, ROLE_TAG_MARGIN + label.frame.size.height / 2);
    
    _userRoleTagBtn.frame = CGRectMake(0, 0, label.frame.size.width + 10 + ROLE_TAG_MARGIN, label.frame.size.height + 2 * ROLE_TAG_MARGIN);
//    _userRoleTagBtn.center = CGPointMake(_user_screen_photo.center.x + _user_screen_photo.frame.size.width / 2 + NAME_LEFT_MARGIN + _userNameLabel.frame.size.width + TAG_2_NAME_MARGIN + _userRoleTagBtn.frame.size.width / 2, PREFERRED_HEIGHT / 2);
    _userRoleTagBtn.center = CGPointMake(_user_screen_photo.center.x + _user_screen_photo.frame.size.width / 2 + NAME_LEFT_MARGIN + _userNameLabel.frame.size.width + TAG_2_NAME_MARGIN + _userRoleTagBtn.frame.size.width / 2, _cellHeight / 2);
    
    if ([@"" isEqualToString:role_tag]) {
        _userRoleTagBtn.hidden = YES;
    }
}

- (void)setCellHeight:(CGFloat)cellHeight {
    _cellHeight = cellHeight;
    
    line.frame = CGRectMake(_lineMargin, _cellHeight - 1, self.bounds.size.width - 2 * _lineMargin, 1);
}

- (void)setLineMargin:(CGFloat)lineMargin {
    _lineMargin = lineMargin;
   
    if (_isTopLine) {
        line.frame = CGRectMake(_lineMargin, 0, self.bounds.size.width -  2 * _lineMargin, 1);
    } else {
        line.frame = CGRectMake(_lineMargin, _cellHeight - 1, self.bounds.size.width -  2 * _lineMargin, 1);
    }
}

#pragma mark -- action
- (void)didSelectedScreenPhoto {
   
    AYViewController* des = DEFAULTCONTROLLER(@"Profile");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:_user_id forKey:kAYControllerChangeArgsKey];
    
    [_controller performWithResult:&dic_push];
}

- (id)queryTargetID {
    id result = self.user_id;
    return result;
}

- (id)relationChanged:(id)args {
    NSNumber* new_relations = (NSNumber*)args;
    NSLog(@"new relations %@", new_relations);
    
    [self setRelationship:new_relations.integerValue];
    return nil;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"init reuse identifier");
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(kAYUserDisplayTableCellName, kAYUserDisplayTableCellName);
    
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
- (id)setCellInfo:(id)args {
    
    NSDictionary* dic = (NSDictionary*)args;
    
    AYUserDisplayView* cell = [dic objectForKey:kAYUserDisplayTableCellKey];
    for (NSString* key in dic.allKeys) {
        if ([key isEqualToString:kAYUserDisplayTableCellHiddenLineKey]) {
            cell.isHiddenLine = ((NSNumber*)[dic objectForKey:key]).boolValue;
        } else if ([key isEqualToString:kAYUserDisplayTableCellLineMarginKey]) {
            cell.lineMargin = ((NSNumber*)[dic objectForKey:key]).floatValue;
        } else if ([key isEqualToString:kAYUserDisplayTableCellCellHeightKey]) {
            cell.cellHeight = ((NSNumber*)[dic objectForKey:key]).floatValue;
        } else if ([key isEqualToString:kAYUserDisplayTableCellShowTopLineKey]) {
            cell.isTopLine = ((NSNumber*)[dic objectForKey:key]).boolValue;
        }
    }
    
    return nil;
}

- (id)setDisplayUserInfo:(id)args {
    
    NSDictionary* dic = (NSDictionary*)args;
   
    AYUserDisplayView* cell = [dic objectForKey:kAYUserDisplayTableCellKey];
    for (NSString* key in dic.allKeys) {
        if ([key isEqualToString:kAYUserDisplayTableCellSetUserIDKey]) {
            cell.user_id = [dic objectForKey:key];
        } else if ([key isEqualToString:kAYUserDisplayTableCellSetUserScreenNameKey]) {
            [cell setUserScreenName:[dic objectForKey:key]];
        } else if ([key isEqualToString:kAYUserDisplayTableCellSetUserScreenPhotoKey]) {
            [cell setUserScreenPhoto:[dic objectForKey:key]];
        } else if ([key isEqualToString:kAYUserDisplayTableCellSetUserRoleTagKey]) {
            [cell setUserRoleTag:[dic objectForKey:key]];
        } else if ([key isEqualToString:kAYUserDisplayTableCellSetUserRelationsKey]) {
            [cell setRelationship:((NSNumber*)[dic objectForKey:key]).intValue];
        }
    }
    
    return nil;
}

- (id)queryCellHeight {
    CGFloat result = self.cellHeight == 0 ? [AYUserDisplayView preferredHeight] : self.cellHeight;
    return [NSNumber numberWithFloat:result];
}
@end
