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

#define USER_PHOTO_WIDTH                        75
#define USER_PHOTO_HEIGHT                       USER_PHOTO_HEIGHT

#define MARGIN_LEFT                 10.5
#define MARGIN_REGIT                10.5
#define MARGIN_TOP                  80
#define MARGIN_BOTTN                5
#define WHITE_AREA_HEIGHT           98

#define WHITE_AREA_ORIGIN_Y         MARGIN_TOP
#define WHITE_AREA_TO_LOCATION      10.5

@implementation AYProfileHeaderView {
    UIView* hotTagView;
    OBShapedButton* relations_btn;
    //    SearchSegView2* search_seg;
    
    UIView* white_area;
    UILabel* thumup;
    
    UIImageView *imgView;
    
    OBShapedButton* userRoleTagBtn;
    UILabel *locationLabel;
    UILabel *nameLabel;
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
    [cmd_download performWithResult:[dic_download copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        UIImage* img = (UIImage*)result;
        
        NSData * imageData = UIImageJPEGRepresentation(img, 1);
        CGFloat length = [imageData length]/1000;
        NSLog(@"img size %f", length);
        imgView.image = img;
    }];
    
    return nil;
}

- (id)setOwnerLocation:(id)args {
   
    NSString* location = (NSString*)args;
    
    locationLabel.text = location;
    [locationLabel sizeToFit];
    
    locationLabel.center = CGPointMake(SCREEN_WIDTH - locationLabel.frame.size.width / 2 - MARGIN_REGIT * 2, WHITE_AREA_ORIGIN_Y - locationLabel.frame.size.height / 2 - WHITE_AREA_TO_LOCATION);
    locationLabel.hidden = YES;
    return nil;
}

- (id)setOwnerRoleTag:(id)args {
    
    userRoleTagBtn.hidden = NO;
    UILabel* label = [userRoleTagBtn viewWithTag:-1];
    if (label == nil) {
        label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:ROLE_TAG_LABEL_FONT_SIZE];
        label.textColor = [UIColor whiteColor];
        label.tag = -1;
        [userRoleTagBtn addSubview:label];
    }
    
#define ROLE_TAG_MARGIN             2
#define ROLETAG_LEFT_MARGIN         ROLE_TAG_MARGIN
   
    NSString* role_tag = (NSString*)args;
    
    label.text = role_tag;
    [label sizeToFit];
    label.center = CGPointMake(ROLETAG_LEFT_MARGIN + label.frame.size.width / 2, ROLE_TAG_MARGIN + label.frame.size.height / 2);
    
    CGFloat width = self.frame.size.width;
    userRoleTagBtn.frame = CGRectMake(width / 2 + ROLETAG_LEFT_MARGIN, 8, label.frame.size.width + ROLE_TAG_MARGIN + ROLE_TAG_MARGIN, label.frame.size.height + 2 * ROLE_TAG_MARGIN);
    userRoleTagBtn.center = CGPointMake(nameLabel.center.x + nameLabel.frame.size.width / 2 + userRoleTagBtn.frame.size.width / 2 + 8, nameLabel.center.y);
    
    if ([@"" isEqualToString:role_tag]) {
        userRoleTagBtn.hidden = YES;
    }
    
    return nil;
}

- (id)setOwnerScreenName:(id)args {
   
    NSString* nickName = (NSString*)args;
    
    nameLabel.text = nickName;
    [nameLabel sizeToFit];
#define NAME_MARGIN_TOP         37
    nameLabel.center = CGPointMake(MARGIN_LEFT + nameLabel.frame.size.width / 2, NAME_MARGIN_TOP + nameLabel.frame.size.height / 2);
    
    return nil;
}

- (id)setRelations:(id)args {
    
    int relations = ((NSNumber*)args).intValue;
    
    switch (relations) {
        case UserPostOwnerConnectionsSamePerson:
            // my own post, do nothing
            [relations_btn setBackgroundImage:PNGRESOURCE(@"friend_relation_myself") forState:UIControlStateNormal];
            break;
        case UserPostOwnerConnectionsNone:
        case UserPostOwnerConnectionsFollowed:
            [relations_btn setBackgroundImage:PNGRESOURCE(@"friend_relation_follow") forState:UIControlStateNormal];
            
            break;
            //            return @"+关注";
        case UserPostOwnerConnectionsFollowing:
            [relations_btn setBackgroundImage:PNGRESOURCE(@"friend_relation_following") forState:UIControlStateNormal];
            break;
        case UserPostOwnerConnectionsFriends:
            [relations_btn setBackgroundImage:PNGRESOURCE(@"friend_relation_muture_follow") forState:UIControlStateNormal];
            //                return @"取消关注";
            break;
            //            return @"-取关";
        default:
            break;
    }
    relations_btn.tag = 100 - relations;

    return nil;
}

- (id)setUserInfo:(id)args {

    NSDictionary* result = (NSDictionary*)args;
    
    NSString* screen_photo = [[result objectForKey:@"screen_photo"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self setOwnerPhoto:screen_photo];
    
    NSString* screen_name = [[result objectForKey:@"screen_name"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self setOwnerScreenName:screen_name];

    NSString* role_tag = [result objectForKey:@"role_tag"];
    [self setOwnerRoleTag:role_tag];

    [self setRelations:[result objectForKey:@"relations"]];

    thumup.text = [NSString stringWithFormat:@"送出的赞 %d    收到的赞 %d", ((NSNumber*)[result objectForKey:@"been_pushed"]).intValue, ((NSNumber*)[result objectForKey:@"been_pushed"]).intValue];
    [thumup sizeToFit];
    thumup.frame = CGRectMake(MARGIN_LEFT, NAME_MARGIN_TOP + thumup.frame.size.height + 18, thumup.frame.size.width, thumup.frame.size.height);
    thumup.center = CGPointMake(thumup.center.x, relations_btn.center.y);
    
    return nil;
}


#pragma mark -- init sub views
- (void)setUpViews {
    
    /*************************************************************************************************************************/
    // location label
    //    _locationLabel = [[UILabel alloc]init];
    //    _locationLabel.textColor = [UIColor whiteColor];
    //    _locationLabel.font = [UIFont systemFontOfSize:LOCATION_LABEL_FONT_SIZE];
    //    [self addSubview:_locationLabel];
    /*************************************************************************************************************************/
    
    /*************************************************************************************************************************/
    /**
     * white area
     */
    white_area = [[UIView alloc]initWithFrame:CGRectMake(MARGIN_LEFT, MARGIN_TOP, self.frame.size.width - MARGIN_LEFT - MARGIN_REGIT, WHITE_AREA_HEIGHT)];
    white_area.backgroundColor = [UIColor whiteColor];
    white_area.layer.cornerRadius = 4.f;
    [self addSubview:white_area];
    //    [self bringSubviewToFront:white_area];
    /*************************************************************************************************************************/
    
    /*************************************************************************************************************************/
    // image view
#define USER_PHOTO_WIDTH_2          72
#define USER_PHOTO_HEIGHT_2         USER_PHOTO_WIDTH_2
#define USER_PHOTO_BG_WIDTH_2       82
#define USER_PHOTO_BG_HEIGHT_2      USER_PHOTO_BG_WIDTH_2
#define IMG_OFFSET_X                64
#define IMG_OFFSET_Y                -10
#define IMG_BORDER_WIDTH            6
    
    UIView* bg_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, USER_PHOTO_BG_WIDTH_2, USER_PHOTO_BG_HEIGHT_2)];
    bg_view.center = CGPointMake(white_area.frame.origin.x + IMG_OFFSET_X, white_area.frame.origin.y + IMG_OFFSET_Y);
    bg_view.layer.cornerRadius = USER_PHOTO_BG_WIDTH_2 / 2;
    bg_view.clipsToBounds = YES;
    bg_view.backgroundColor = [UIColor whiteColor];
    [self addSubview:bg_view];
    [self bringSubviewToFront:bg_view];
    
    imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, USER_PHOTO_WIDTH_2, USER_PHOTO_HEIGHT_2)];
    imgView.center = CGPointMake(USER_PHOTO_BG_WIDTH_2 / 2,  USER_PHOTO_BG_HEIGHT_2 / 2);
    imgView.layer.cornerRadius = USER_PHOTO_WIDTH_2 / 2;
    //    _imgView.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.3].CGColor;
    //    _imgView.layer.borderColor = [UIColor whiteColor].CGColor;
    //    _imgView.layer.borderWidth = IMG_BORDER_WIDTH;
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
    
    if (userRoleTagBtn == nil) {
        userRoleTagBtn = [[OBShapedButton alloc]init];
        [userRoleTagBtn setBackgroundImage:PNGRESOURCE(@"home_role_tag") forState:UIControlStateNormal];
        [white_area addSubview:userRoleTagBtn];
        [white_area bringSubviewToFront:userRoleTagBtn];
    }
    
    /*************************************************************************************************************************/
#define RELATION_BTN_WIDTH          69
#define RELATION_BTN_HEIGHT         25
    relations_btn = [[OBShapedButton alloc]initWithFrame:CGRectMake(white_area.frame.size.width - MARGIN_REGIT - RELATION_BTN_WIDTH, white_area.frame.size.height - MARGIN_REGIT - RELATION_BTN_HEIGHT, RELATION_BTN_WIDTH, RELATION_BTN_HEIGHT)];
//    [relations_btn addTarget:self action:@selector(didSelectRelationBtn) forControlEvents:UIControlEventTouchUpInside];
    [white_area addSubview:relations_btn];
    [white_area bringSubviewToFront:relations_btn];
    /*************************************************************************************************************************/
    
    /*************************************************************************************************************************/
#define THUMSUP_DES_FONT_SIZE       13.f
    thumup = [[UILabel alloc]init];
    thumup.textColor = [UIColor colorWithWhite:0.6078 alpha:1.f];
    thumup.font = [UIFont systemFontOfSize:THUMSUP_DES_FONT_SIZE];
    [white_area addSubview:thumup];
    [white_area bringSubviewToFront:thumup];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    white_area.frame = CGRectMake(MARGIN_LEFT, MARGIN_TOP, self.frame.size.width - MARGIN_LEFT - MARGIN_REGIT, WHITE_AREA_HEIGHT);
    relations_btn.frame = CGRectMake(white_area.frame.size.width - 3 * MARGIN_REGIT - RELATION_BTN_WIDTH, white_area.frame.size.height - MARGIN_REGIT - RELATION_BTN_HEIGHT, RELATION_BTN_WIDTH, RELATION_BTN_HEIGHT);
}
@end
