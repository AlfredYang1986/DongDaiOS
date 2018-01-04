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

#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"
#import "AYViewController.h"

static NSString* const isGettingCertData = @"正在获取信息";

static NSString* const VerifiedRealName = @"实名认证";
static NSString* const hasNoRealName = @"实名待认证";

static NSString* const VerifiedPhoneNo = @"手机号码验证";
static NSString* const hasNoPhoneNo = @"手机号码待验证";

@implementation AYServiceOwnerInfoCellView {
	
    UIImageView *userPhoto;
    UILabel *userName;
	UILabel *userJob;
	
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
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		CGFloat photoWidth = 55;
        userPhoto = [[UIImageView alloc] init];
        userPhoto.image = IMGRESOURCE(@"default_user");
        userPhoto.contentMode = UIViewContentModeScaleAspectFill;
        userPhoto.clipsToBounds = YES;
        userPhoto.layer.cornerRadius = photoWidth*0.5;
//        userPhoto.layer.borderColor = [Tools borderAlphaColor].CGColor;
//        userPhoto.layer.borderWidth = 2.f;
        [self addSubview:userPhoto];
        [userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-SCREEN_MARGIN_LR);
            make.top.equalTo(self).offset(30);
			make.bottom.equalTo(self).offset(-30);
            make.size.mas_equalTo(CGSizeMake(photoWidth, photoWidth));
        }];
		
		userName = [UILabel creatLabelWithText:@"UserName" textColor:[UIColor black] fontSize:614.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		userName.numberOfLines = 1;
		[self addSubview:userName];
		[userName mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(userPhoto).offset(0);
			make.left.equalTo(self).offset(SCREEN_MARGIN_LR);
			make.right.equalTo(userPhoto.mas_left).offset(-20);
		}];
		userJob = [UILabel creatLabelWithText:@"UserJob" textColor:[UIColor gary] fontSize:314.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		userJob.numberOfLines = 1;
		[self addSubview:userJob];
		[userJob mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(userPhoto);
			make.left.equalTo(userName);
			make.right.equalTo(userName);
		}];
		
		
		UIView *bottom_view = [[UIView alloc] init];
		bottom_view.backgroundColor = [UIColor garyLine];
		[self addSubview:bottom_view];
		[bottom_view mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.top.equalTo(userPhoto.mas_bottom).offset(30);
			make.left.equalTo(self).offset(SCREEN_MARGIN_LR);
			make.right.equalTo(self).offset(-SCREEN_MARGIN_LR);
			make.bottom.equalTo(self);
			make.height.mas_equalTo(0.5);
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
		if (photo_name && ![photo_name isEqualToString:@""]) {
			[userPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",pre, photo_name]]
						 placeholderImage:IMGRESOURCE(@"default_user")];
		}
		userPhoto.userInteractionEnabled = NO;

	} else {
		
		NSDictionary *info_owner = [service_info objectForKey:@"owner"];
		userPhoto.userInteractionEnabled = YES;
		NSString *userNameStr = [info_owner objectForKey:@"screen_name"];
		if (userNameStr && ![userNameStr isEqualToString:@""]) {
			userName.text = userNameStr;
		}
		NSString *screen_photo = [info_owner objectForKey:kAYProfileArgsScreenPhoto];
		if (screen_photo && ![screen_photo isEqualToString:@""]) {
			[userPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", pre, screen_photo]]
						 placeholderImage:IMGRESOURCE(@"default_user") /*options:SDWebImageRefreshCached*/];
		}
		
		
	}
	
    return nil;
}

@end
