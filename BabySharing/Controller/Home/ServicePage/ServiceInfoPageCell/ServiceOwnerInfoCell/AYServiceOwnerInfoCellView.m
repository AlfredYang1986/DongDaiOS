//
//  AYServiceOwnerInfoCellVeiw.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceOwnerInfoCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"

@implementation AYServiceOwnerInfoCellView {
	
    UIImageView *userPhoto;
    UILabel *userName;
	
	UIImageView *realNameSign;
	UILabel *realNameLabel;
	UIImageView *phoneNoSign;
	UILabel *phoneNoLabel;
	
    NSDictionary *service_info;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
        self.clipsToBounds = YES;
        
        userPhoto = [[UIImageView alloc] init];
        userPhoto.image = IMGRESOURCE(@"default_user");
        userPhoto.contentMode = UIViewContentModeScaleAspectFill;
        userPhoto.clipsToBounds = YES;
        userPhoto.layer.cornerRadius = 32.f;
        userPhoto.layer.borderColor = [Tools borderAlphaColor].CGColor;
        userPhoto.layer.borderWidth = 2.f;
        [self addSubview:userPhoto];
        [userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self).offset(15);
			make.bottom.equalTo(self).offset(-15);
            make.size.mas_equalTo(CGSizeMake(64, 64));
        }];
        userPhoto.userInteractionEnabled = YES;
        [userPhoto addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didOwnerPhotoClick)]];
        
        userName = [Tools creatUILabelWithText:@"Name" andTextColor:[Tools blackColor] andFontSize:18.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
        [self addSubview:userName];
        [userName mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(23);
            make.left.equalTo(userPhoto.mas_right).offset(12);
			make.right.equalTo(self).offset(-40);
        }];
		
		realNameSign = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"checked_icon")];
		[self addSubview:realNameSign];
		[realNameSign mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(userName);
			make.top.equalTo(userName.mas_bottom).offset(8);
			make.size.mas_equalTo(CGSizeMake(11, 11));
		}];
        realNameLabel = [Tools creatUILabelWithText:@"RealName Info" andTextColor:[Tools garyColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
        [self addSubview:realNameLabel];
		[realNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(realNameSign.mas_right).offset(4);
			make.centerY.equalTo(realNameSign);
        }];
		
		phoneNoSign = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"checked_icon")];
		[self addSubview:phoneNoSign];
		[phoneNoSign mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(realNameLabel.mas_right).offset(16);
			make.centerY.equalTo(realNameSign);
			make.size.mas_equalTo(CGSizeMake(11, 11));
		}];
		realNameLabel = [Tools creatUILabelWithText:@"PhoneNo Info" andTextColor:[Tools garyColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:realNameLabel];
		[realNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(phoneNoSign.mas_right).offset(4);
			make.centerY.equalTo(phoneNoSign);
		}];
		
		UIImageView *arrow_right = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"details_icon_arrow_right")];
		[self addSubview:arrow_right];
		[arrow_right mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.right.equalTo(self).offset(-20);
			make.size.mas_equalTo(CGSizeMake(8, 14));
		}];
		
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"ServiceOwnerInfoCell", @"ServiceOwnerInfoCell");
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

#pragma mark -- actions
- (void)didOwnerPhotoClick {
    id<AYCommand> des = DEFAULTCONTROLLER(@"OneProfile");
    
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
    [dic_push setValue:[service_info objectForKey:@"owner_id"] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    
}

#pragma mark -- notifies
- (id)setCellInfo:(id)args {
    
    service_info = (NSDictionary*)args;
    
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSString *pre = cmd.route;
    
	NSNumber *pre_mode = [service_info objectForKey:@"perview_mode"];
	if (pre_mode) {     //用户预览
		NSDictionary *user_info;
		CURRENPROFILE(user_info)

		userName.text = [user_info objectForKey:@"screen_name"];
		NSString* photo_name = [user_info objectForKey:@"screen_photo"];
		[userPhoto sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:photo_name]]
					 placeholderImage:IMGRESOURCE(@"default_user")];
		userPhoto.userInteractionEnabled = NO;

	} else {

		userPhoto.userInteractionEnabled = YES;
		userName.text = [service_info objectForKey:@"screen_name"];
		NSString *screen_photo = [service_info objectForKey:@"screen_photo"];
		[userPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", pre, screen_photo]]
						 placeholderImage:IMGRESOURCE(@"default_user") /*options:SDWebImageRefreshCached*/];
	}
	
    return nil;
}

@end
