//
//  UserSearchCell.m
//  BabySharing
//
//  Created by Alfred Yang on 9/12/2015.
//  Copyright © 2015 BM. All rights reserved.
//

#import "AYUserTableCellView.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYUserTableCellDefines.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "OBShapedButton.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

#define CELL_HEADER_HEIGHT  59
#define CELL_FOOTER_HEIGHT  10

#define HEADER_CONTAINER    80

#define PHOTO_PER_LINE      3


#define HEARDER_CELL_INDEX  0
#define CONTENT_CELL_INDEX  1
#define FOOTER_CELL_INDEX   2

#define CELL_COUNTS         3

#define IMG_WIDTH       40
#define IMG_HEIGHT      IMG_WIDTH

#define PREFERRED_HEIGHT    80

#define NAME_LEFT_MARGIN    10.5

@interface AYUserTableCellView ()
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UIView *relationContainer;
@property (weak, nonatomic) IBOutlet UIView *userInfoContainer;

@property (nonatomic, strong) OBShapedButton* userRoleTagBtn;
@property (nonatomic, strong) UILabel* userNameLabel;

@end

@implementation AYUserTableCellView {
    NSArray* perviews;
    NSArray* perviewViews;
}

@synthesize user_id = _user_id;
@synthesize screen_name = _screen_name;
@synthesize connections = _connections;

@synthesize headView = _headView;
@synthesize relationContainer = _relationContainer;
@synthesize userRoleTagBtn = _userRoleTagBtn;
@synthesize userNameLabel = _userNameLabel;
@synthesize userInfoContainer = _userInfoContainer;

- (void)awakeFromNib {
    // Initialization code
    _headView.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25].CGColor;
    _headView.layer.borderWidth = 1.5f;
    _headView.layer.cornerRadius = IMG_WIDTH / 2;
    _headView.clipsToBounds = YES;
    
    _headView.userInteractionEnabled = YES;
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectedScreenPhoto)];
//    [_headView addGestureRecognizer:tap];
    
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
   
    _connections = -1;
    
    [self setUpReuseCell];
}

- (void)setUserScreenPhoto:(NSString*)photo_name {
    
    [_headView setImage:PNGRESOURCE(@"default_user")];
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:photo_name forKey:@"image"];
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        UIImage* img = (UIImage*)result;
        if (img != nil) {
            [_headView setImage:img];
        }
    }];
}

- (void)setUserScreenName:(NSString*)name {
    _userNameLabel.text = name;
    _userNameLabel.font = [UIFont systemFontOfSize:14.0f];
    [_userNameLabel sizeToFit];
#define TAG_2_NAME_MARGIN   10
#define USER_NAME_TOP_MARGIN    8
    //    _userNameLabel.center = CGPointMake(_headView.center.x + _headView.frame.size.width / 2 + NAME_LEFT_MARGIN + _userNameLabel.frame.size.width / 2, PREFERRED_HEIGHT / 2);
    _userNameLabel.center = CGPointMake(_headView.center.x + _headView.frame.size.width / 2 + NAME_LEFT_MARGIN + _userNameLabel.frame.size.width / 2, PREFERRED_HEIGHT / 2);
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
    //    _userRoleTagBtn.center = CGPointMake(_headView.center.x + _headView.frame.size.width / 2 + NAME_LEFT_MARGIN + _userNameLabel.frame.size.width + TAG_2_NAME_MARGIN + _userRoleTagBtn.frame.size.width / 2, PREFERRED_HEIGHT / 2);
    _userRoleTagBtn.center = CGPointMake(_headView.center.x + _headView.frame.size.width / 2 + NAME_LEFT_MARGIN + _userNameLabel.frame.size.width + TAG_2_NAME_MARGIN + _userRoleTagBtn.frame.size.width / 2, PREFERRED_HEIGHT / 2);
    
    if ([@"" isEqualToString:role_tag]) {
        _userRoleTagBtn.hidden = YES;
    }
}

- (void)changePreviewImages:(NSArray*)arr {
    perviews = arr;
   
    for (UIView* iter in perviewViews) {
        [iter removeFromSuperview];
    }
   
    NSMutableArray* marr = [[NSMutableArray alloc]init];
    for (NSDictionary* tmp  in perviews) {
        NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF.type=0"];
        NSArray* filter_arr = [[tmp objectForKey:@"items"] filteredArrayUsingPredicate:p];
        NSString* photo_name = [filter_arr.firstObject objectForKey:@"name"];
       
        CGFloat width = [UIScreen mainScreen].bounds.size.width / 3;
        UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
        [self setPhoto:photo_name forView:view];
        view.center = CGPointMake(view.center.x + marr.count * width, view.center.y + PREFERRED_HEIGHT);
        [marr addObject:view];
        [self addSubview:view];
    }
    perviewViews = [marr copy];
}

- (void)setPhoto:(NSString*)photo_name forView:(UIImageView*)view {
    [view setImage:PNGRESOURCE(@"default_user")];
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:photo_name forKey:@"image"];
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        UIImage* img = (UIImage*)result;
        if (img != nil) {
            [view setImage:img];
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

- (id)queryTargetID {
    return self.user_id;
}

- (id)relationChanged:(id)args {
    NSNumber* new_relations = (NSNumber*)args;
    NSLog(@"new relations %@", new_relations);
    
    [self setRelationship:new_relations.integerValue];
    return nil;
}

+ (CGFloat)preferredHeight {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat img_height = width / PHOTO_PER_LINE;
    return HEADER_CONTAINER + img_height;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(kAYUserTableCellName, kAYUserTableCellName);
    
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
- (id)setCellInfo:(id)obj {
    
    NSDictionary* dic = (NSDictionary*)obj;
   
    AYUserTableCellView* cell = [dic objectForKey:kAYUserTableCellCellKey];
   
    for (NSString* key in dic.allKeys) {
        if ([key isEqualToString:kAYUserTableCellUserIDKey]) {
            cell.user_id = [dic objectForKey:key];
        } else if ([key isEqualToString:kAYUserTableCellScreenPhotoKey]) {
            [cell setUserScreenPhoto:[dic objectForKey:key]];
        } else if ([key isEqualToString:kAYUserTableCellScreenNameKey]) {
            [cell setUserScreenName:[dic objectForKey:key]];
        } else if ([key isEqualToString:kAYUserTableCellRoleTagKey]) {
            [cell setUserRoleTag:[dic objectForKey:key]];
        } else if ([key isEqualToString:kAYUserTableCellRelationKey]) {
            [cell setRelationship:((NSNumber*)[dic objectForKey:key]).integerValue];
        } else if ([key isEqualToString:kAYUserTableCellImgPreviewKey]) {
            [cell changePreviewImages:[dic objectForKey:key]];
        }
    }
    
    return nil;
}

- (id)queryCellHeight {
    return [NSNumber numberWithFloat:[AYUserTableCellView preferredHeight]];
}
@end
