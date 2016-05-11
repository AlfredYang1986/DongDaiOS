//
//  AYProfileHeaderView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYProfileHeaderView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "OBShapedButton.h"
#import "AYResourceManager.h"
#import "AYRemoteCallDefines.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYFactoryManager.h"
#import "AYQueryModelDefines.h"
#import "Tools.h"

//#define BASE_LINE_HEIGHT        115
#define BASE_LINE_HEIGHT        185
#define MARGIN_AFTER_BASE_LINE  8
#define BUTTON_WIDTH            90
#define BUTTON_HEIGHT           25
#define HEADER_BOTTOM_MARGIN    10
#define SPLIT_LINE_HEIGHT       2

#define ICE_HOT_ICON_WIDTH    20
#define ICE_HOT_ICON_HEIGHT   20
#define HOT_RIGHT_MARGIN       8

#define NAME_MARGIN_TOP         37
#define NAME_LABEL_FONT_SIZE                    14.f
#define ROLE_TAG_LABEL_FONT_SIZE                12.f
#define LOCATION_LABEL_FONT_SIZE                13.f

#define NAME_LABEL_2_SCREEN_PHOTO_MARGIN        50
#define ROLE_TAG_LABEL_2_SCREEN_PHOTO_MARGIN    9
#define NAME_LABEL_2_ROLE_TAG_LABEL_MARGIN      4.5
#define LOCATION_LABEL_2_SCREEN_PHOTO_MARGIN    70

#define LOCATION_ICON_WIDTH                     11
#define LOCATION_ICON_HEIGHT                    LOCATION_ICON_WIDTH

#define SCREEN_WIDTH                            [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                           [UIScreen mainScreen].bounds.size.height

#define MARGIN_LEFT                 10.5
#define MARGIN_REGIT                10.5
#define MARGIN_TOP                  80
#define MARGIN_BOTTN                5
#define WHITE_AREA_HEIGHT           98

#define THUMSUP_DES_FONT_SIZE       13.f

#define WHITE_AREA_ORIGIN_Y         MARGIN_TOP
#define WHITE_AREA_TO_LOCATION      10.5

#define RELATION_BTN_WIDTH          69
#define RELATION_BTN_HEIGHT         25

@implementation AYProfileHeaderView {
//    UIView* hotTagView;
//    SearchSegView2* search_seg;
    
    UIView* white_area;
    
    UIView *bg_view;
    UIImageView *imgView;
    UILabel *locationLabel;
    UILabel *nameLabel;
    UILabel *userRoleTagLabel;
    
    UILabel* thumup;
//    OBShapedButton* relations_btn;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle

#pragma mark -- commands
- (void)postPerform {
    [self setUpViews];
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

#pragma mark -- view commands
- (id)setOwnerPhoto:(id)args {
    
    NSString* screen_photo = (NSString*)args;
    
    AYFacade* f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd_download = [f.commands objectForKey:@"DownloadUserFiles"];
    NSMutableDictionary* dic_download = [[NSMutableDictionary alloc]initWithCapacity:1];
    [dic_download setValue:screen_photo forKey:@"image"];
    [dic_download setValue:@"img_thum" forKey:@"expect_size"];
    
    [cmd_download performWithResult:[dic_download copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        UIImage* img = (UIImage*)result;
        if (img != nil) {
            imgView.image = img;
        }
    }];
    
    return nil;
}

- (id)setOwnerLocation:(id)args {
   
    NSString* location = (NSString*)args;
    
    locationLabel.text = location;
    [locationLabel sizeToFit];
//    locationLabel.center = CGPointMake(SCREEN_WIDTH - locationLabel.frame.size.width / 2 - MARGIN_REGIT * 2, WHITE_AREA_ORIGIN_Y - locationLabel.frame.size.height / 2 - WHITE_AREA_TO_LOCATION);
    locationLabel.hidden = YES;
    return nil;
}

- (id)setOwnerScreenName:(id)args {
   
    NSString* nickName = (NSString*)args;
    
    nameLabel.text = nickName;
//    [nameLabel sizeToFit];
//    nameLabel.center = CGPointMake(MARGIN_LEFT + nameLabel.frame.size.width / 2, NAME_MARGIN_TOP + nameLabel.frame.size.height / 2);
    
    return nil;
}

- (id)setRelations:(id)args {
    
    int relations = ((NSNumber*)args).intValue;
   
    UIView* tmp = [white_area viewWithTag:-100];
    if (tmp) {
        [tmp removeFromSuperview];
    }
    
    id<AYCommand> cmd = COMMAND(@"Module", @"RelationshipBtnInit");
    id arg_init  = [NSNumber numberWithInteger:relations];
    [cmd performWithResult:&arg_init];
    UIView* btn = arg_init;
    
    btn.tag = -100;
    btn.frame =  CGRectMake(0, 0, 69, 25);
    btn.center = CGPointMake(51, 25);
    [white_area addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(thumup);
        make.right.equalTo(white_area.mas_right).offset(-10);
        make.width.equalTo(@(RELATION_BTN_WIDTH));
        make.height.equalTo(@(RELATION_BTN_HEIGHT));
    }];
    
    ((id<AYViewBase>)btn).controller = self.controller;
    return nil;
}

- (id)setUserInfo:(id)args {

    NSDictionary* result = (NSDictionary*)args;
    
//    NSString* screen_photo = [result objectForKey:@"screen_photo"];
    NSString* screen_photo = [[result objectForKey:@"screen_photo"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self setOwnerPhoto:screen_photo];
    
    NSString* screen_name = [[result objectForKey:@"screen_name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self setOwnerScreenName:screen_name];

    NSString* role_tag = [result objectForKey:@"role_tag"];
    
    userRoleTagLabel.text = role_tag;
    [self updateRoleLabelConstraints];
    [self setRelations:[result objectForKey:@"relations"]];

    thumup.text = [NSString stringWithFormat:@"送出的赞 %d    收到的赞 %d", ((NSNumber*)[result objectForKey:@"been_pushed"]).intValue, ((NSNumber*)[result objectForKey:@"been_pushed"]).intValue];
    [thumup sizeToFit];
//    thumup.frame = CGRectMake(MARGIN_LEFT, NAME_MARGIN_TOP + thumup.frame.size.height + 18, thumup.frame.size.width, thumup.frame.size.height);
//    thumup.center = CGPointMake(thumup.center.x, relations_btn.center.y);
    
    return nil;
}

- (id)changeRelations:(id)args {
    [self setRelations:args];
    return nil;
}

-(void)updateRoleLabelConstraints{
    [userRoleTagLabel sizeToFit];
    [userRoleTagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLabel);
        make.left.equalTo(nameLabel.mas_right).offset(10);
        make.width.equalTo(@(CGRectGetWidth(userRoleTagLabel.frame) + 4));
        make.height.equalTo(@(CGRectGetHeight(userRoleTagLabel.frame) + 2));
    }];
    [super updateConstraints];
}

#pragma mark -- init sub views
- (void)setUpViews {
    
//    white_area = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_LEFT, MARGIN_TOP, self.frame.size.width - MARGIN_LEFT - MARGIN_REGIT, WHITE_AREA_HEIGHT)];
    white_area = [[UIView alloc]init];
    white_area.backgroundColor = [UIColor whiteColor];
    white_area.layer.cornerRadius = 4.f;
    [self addSubview:white_area];
//    [self bringSubviewToFront:white_area];
    
    locationLabel = [[UILabel alloc]init];
    locationLabel.textColor = [UIColor whiteColor];
    locationLabel.font = [UIFont systemFontOfSize:LOCATION_LABEL_FONT_SIZE];
    [white_area addSubview:locationLabel];

#define USER_PHOTO_WIDTH         72
#define USER_PHOTO_HEIGHT        USER_PHOTO_WIDTH
#define USER_PHOTO_BG_WIDTH       82
#define USER_PHOTO_BG_HEIGHT      USER_PHOTO_BG_WIDTH
#define IMG_OFFSET_X                64
#define IMG_OFFSET_Y                -10
#define IMG_BORDER_WIDTH            3
    
    bg_view = [[UIView alloc]init];

    bg_view.layer.cornerRadius = USER_PHOTO_BG_WIDTH / 2;
    bg_view.clipsToBounds = YES;
    bg_view.backgroundColor = [UIColor whiteColor];
    [self addSubview:bg_view];
    [self bringSubviewToFront:bg_view];
    
    imgView = [[UIImageView alloc]init];

    imgView.layer.cornerRadius = USER_PHOTO_WIDTH / 2;
    imgView.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.25].CGColor;
    imgView.layer.borderWidth = 2;
    imgView.clipsToBounds = YES;
    [bg_view addSubview:imgView];
    [bg_view bringSubviewToFront:imgView];
    /*************************************************************************************************************************/
    
    /*************************************************************************************************************************/
    // name label
    nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = [UIColor colorWithWhite:0.2902 alpha:1.f];
    nameLabel.font = [UIFont systemFontOfSize:NAME_LABEL_FONT_SIZE];
    [white_area addSubview:nameLabel];
    [white_area bringSubviewToFront:nameLabel];
    /*************************************************************************************************************************/
    
    userRoleTagLabel = [[UILabel alloc]init];
    userRoleTagLabel.hidden = NO;
    userRoleTagLabel.text = @"";
    userRoleTagLabel.font = [UIFont systemFontOfSize:12];
    userRoleTagLabel.backgroundColor = [Tools colorWithRED:254.0 GREEN:192.0 BLUE:0.0 ALPHA:1.0];
    userRoleTagLabel.textAlignment = NSTextAlignmentCenter;
    userRoleTagLabel.layer.masksToBounds = YES;
    userRoleTagLabel.layer.cornerRadius = 3;
    userRoleTagLabel.layer.shouldRasterize = YES;
    userRoleTagLabel.layer.rasterizationScale = [UIScreen mainScreen].scale;
    userRoleTagLabel.textColor = [UIColor whiteColor];
    [white_area addSubview:userRoleTagLabel];
    
    /*************************************************************************************************************************/
    
    /*************************************************************************************************************************/

    thumup = [[UILabel alloc]init];
    thumup.textColor = [UIColor colorWithWhite:0.6078 alpha:1.f];
    thumup.font = [UIFont systemFontOfSize:THUMSUP_DES_FONT_SIZE];
    [white_area addSubview:thumup];
    [white_area bringSubviewToFront:thumup];
  
    [self setSubviewsLayout];
}

- (void)setSubviewsLayout {
    [white_area mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(79);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@(WHITE_AREA_HEIGHT));
    }];
    
    [bg_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(white_area.mas_top).offset(-60);
        make.left.equalTo(white_area.mas_left).offset(20);
        make.width.equalTo(@(USER_PHOTO_BG_WIDTH));
        make.height.equalTo(@(USER_PHOTO_BG_HEIGHT));
    }];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bg_view).insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(white_area.mas_top).offset(-20);
        make.right.equalTo(white_area.mas_right).offset(-10);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bg_view.mas_bottom).offset(MARGIN_LEFT);
        make.left.equalTo(white_area.mas_left).offset(MARGIN_LEFT);
    }];
    
    [userRoleTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameLabel);
        make.left.equalTo(nameLabel.mas_right).offset(10);
    }];
    
    [thumup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(15);
        make.left.equalTo(white_area.mas_left).offset(10);
    }];
}
@end
