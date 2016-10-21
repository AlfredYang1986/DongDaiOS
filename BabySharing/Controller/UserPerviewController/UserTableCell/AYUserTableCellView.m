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

#import "AYViewController.h"
#import "AYModelFacade.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"

#define HEADER_CONTAINER    80
#define PREFERRED_HEIGHT    80

#define PHOTO_PER_LINE      3

#define IMG_WIDTH       40
#define IMG_HEIGHT      IMG_WIDTH

#define MARGIN_ALL      (10+10.5+10+90)

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
    [super awakeFromNib];
    // Initialization code
    CALayer* layer = [CALayer layer];
    layer.borderColor = [UIColor colorWithWhite:0.5922 alpha:0.25].CGColor;
    layer.borderWidth = 1.f;
    layer.frame = CGRectMake(0, [AYUserTableCellView preferredHeight] - 1, [UIScreen mainScreen].bounds.size.width, 1);
    [self.layer addSublayer:layer];
    
    _headView.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25].CGColor;
    _headView.layer.borderWidth = 1.5f;
    _headView.layer.cornerRadius = IMG_WIDTH / 2;
    _headView.clipsToBounds = YES;
    
    _headView.userInteractionEnabled = YES;
    
    if (_userRoleTagBtn == nil) {
        _userRoleTagBtn = [[OBShapedButton alloc]init];
        UIImage *bg = [UIImage imageNamed:@"login_role_bg2"];
        bg = [bg resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 10, 10) resizingMode:UIImageResizingModeStretch];
        [_userRoleTagBtn setBackgroundImage:bg forState:UIControlStateNormal];
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
    
    [_headView setImage:IMGRESOURCE(@"default_user")];
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:photo_name forKey:@"image"];
    [dic setValue:@"img_icon" forKey:@"expect_size"];
    
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
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_headView.frame)+8, CGRectGetMidY(_headView.frame)-10, CGRectGetWidth(_userNameLabel.bounds), CGRectGetHeight(_userNameLabel.bounds));
}

- (void)setUserRoleTag:(NSString*)role_tag {
    _userRoleTagBtn.hidden = NO;
    UILabel* label = [_userRoleTagBtn viewWithTag:-19];
    if (label == nil) {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12.f];
        label.textColor = [UIColor whiteColor];
        label.tag = -19;
        [_userRoleTagBtn.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_userRoleTagBtn addSubview:label];
    }
    
    label.text = role_tag;
    [label sizeToFit];
    
    //michauxs:角色名＋昵称长度限制
    CGFloat image_w = CGRectGetWidth(_headView.bounds);
    CGFloat name_w = CGRectGetWidth(_userNameLabel.bounds);
    CGFloat role_w = 0;
    role_w = CGRectGetWidth(label.bounds)+14;
    
    if ((image_w + name_w + role_w + MARGIN_ALL) > self.frame.size.width) {
        _userRoleTagBtn.frame = CGRectMake(CGRectGetMaxX(_userNameLabel.frame) + 10, CGRectGetMidY(_headView.frame)-10, self.frame.size.width - image_w-name_w- MARGIN_ALL, 20);
        NSLog(@"%f",self.frame.size.width - image_w-name_w-130.5);
        
        CGFloat min_role_limit = 50;
        CGFloat role_afterLimit = self.frame.size.width - image_w-name_w-MARGIN_ALL;
        if (role_afterLimit < min_role_limit) {
            
            CGFloat overMore = min_role_limit - role_afterLimit;
            _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_headView.frame)+10, CGRectGetMidY(_headView.frame)-10, _userNameLabel.bounds.size.width - overMore, _userNameLabel.bounds.size.height);
            _userRoleTagBtn.frame = CGRectMake(CGRectGetMaxX(_userNameLabel.frame) + 10, CGRectGetMidY(_headView.frame)-10, min_role_limit, 20 );
        }
    }else
        _userRoleTagBtn.frame = CGRectMake(CGRectGetMaxX(_userNameLabel.frame) + 10, CGRectGetMidY(_headView.frame)-10, role_w, 20);
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_userRoleTagBtn);
        make.left.equalTo(_userRoleTagBtn).offset(10);
        make.right.equalTo(_userRoleTagBtn).offset(-4);
    }];
    
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
    CGFloat offset = 0;
    CGFloat index = 0;
    for (NSDictionary* tmp  in perviews) {
        NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF.type=0"];
        NSArray* filter_arr = [[tmp objectForKey:@"items"] filteredArrayUsingPredicate:p];
        NSString* photo_name = [filter_arr.firstObject objectForKey:@"name"];
       
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - 3) / 3 ;
        offset = (width + 1.5) * index;
        UIImageView* view = [[UIImageView alloc]init];
        [self setPhoto:photo_name forView:view];
        
        [marr addObject:view];
        [self addSubview:view];
        
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-8);
            make.left.equalTo(self).offset(offset);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(width);
        }];
        ++index;
    }
    perviewViews = [marr copy];
}

- (void)setPhoto:(NSString*)photo_name forView:(UIImageView*)view {
    [view setImage:IMGRESOURCE(@"default_user")];
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:photo_name forKey:@"image"];
    [dic setValue:@"img_icon" forKey:@"expect_size"];
    
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
//        btn.frame =  CGRectMake(0, 0, 69, 25);
//        btn.center = CGPointMake(51, 25);
        [_relationContainer addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headView);
            make.right.equalTo(self).offset(-10);
            make.width.mas_equalTo(69);
            make.height.mas_equalTo(25);
        }];
        
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

- (id)SamePersonBtnSelected {
    NSLog(@"push to person setting");
    
    AYModelFacade* f = LOGINMODEL;
    CurrentToken* tmp = [CurrentToken enumCurrentLoginUserInContext:f.doc.managedObjectContext];
    
    NSMutableDictionary* cur = [[NSMutableDictionary alloc]initWithCapacity:4];
    [cur setValue:tmp.who.user_id forKey:@"user_id"];
    [cur setValue:tmp.who.auth_token forKey:@"auth_token"];
    [cur setValue:tmp.who.screen_image forKey:@"screen_photo"];
    [cur setValue:tmp.who.screen_name forKey:@"screen_name"];
    [cur setValue:tmp.who.role_tag forKey:@"role_tag"];
    
    AYViewController* des = DEFAULTCONTROLLER(@"PersonalSetting");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:cur forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
    return nil;
}

@end
