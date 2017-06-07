//
//  AYServiceTitleCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceTitleCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"

@implementation AYServiceTitleCellView {
    UILabel *titleLabel;
	
	UILabel *themeLabel;
	UILabel *ownerNameLabel;
	UIImageView *ownerPhoto;
	
	NSDictionary *service_info;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
		UIView *propView = [[UIView alloc] init];
		[self addSubview:propView];
		[propView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self);
			make.bottom.equalTo(self);
			make.center.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(0.01f, 82.f));
		}];
		
		themeLabel = [Tools creatUILabelWithText:@"Theme" andTextColor:[Tools whiteColor] andFontSize:311.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[Tools setViewBorder:themeLabel withRadius:8.f andBorderWidth:0.f andBorderColor:nil andBackground:[Tools themeColor]];
		[self addSubview: themeLabel];
        
        titleLabel = [Tools creatUILabelWithText:@"Service title is not set" andTextColor:[Tools blackColor] andFontSize:618.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		titleLabel.numberOfLines = 2.f;
        [self addSubview:titleLabel];
		
		UIView *bottom_view = [[UIView alloc] init];
		bottom_view.backgroundColor = [Tools garyBackgroundColor];
		[self addSubview:bottom_view];
		[bottom_view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.bottom.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 10));
		}];
		
		UIView *shadow_view = [[UIView alloc]init];
		shadow_view.backgroundColor = [Tools whiteColor];
		shadow_view.layer.shadowColor = [Tools garyColor].CGColor;
		shadow_view.layer.shadowOffset = CGSizeMake(0, 2.f);
		shadow_view.layer.shadowOpacity = 0.05f;
		shadow_view.layer.shadowRadius =1.f;
		[self addSubview:shadow_view];
		[shadow_view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self).offset(-10);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 10));
		}];
		
		[self sendSubviewToBack:shadow_view];
		[self sendSubviewToBack:bottom_view];
		
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
    id<AYViewBase> cell = VIEW(@"ServiceTitleCell", @"ServiceTitleCell");
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
	
	NSString *completeTheme;
	NSArray *options_title_cans;
	NSNumber *service_cat = [service_info objectForKey:kAYServiceArgsServiceCat];
	NSNumber *cans_cat = [service_info objectForKey:kAYServiceArgsCourseCat];
	
	if (service_cat.intValue == ServiceTypeNursery) {
		options_title_cans = kAY_service_options_title_nursery;
		if (cans_cat.intValue == -1 || cans_cat.integerValue >= options_title_cans.count) {
			completeTheme = @"待调整";
		} else
			completeTheme = options_title_cans[cans_cat.integerValue];
	}
	else if (service_cat.intValue == ServiceTypeCourse) {
		options_title_cans = kAY_service_options_title_course;
		if (cans_cat.intValue == -1 || cans_cat.integerValue >= options_title_cans.count) {
			completeTheme = @"待调整";
		}
		else
			completeTheme = options_title_cans[cans_cat.integerValue];
	} else {
		completeTheme = @"待调整";
	}
	
	themeLabel.text = completeTheme;
	[themeLabel sizeToFit];
	CGFloat themeLabelWidth = themeLabel.bounds.size.width + 10;
	
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self);
		make.left.equalTo(self).offset(26 + themeLabelWidth);
		make.right.equalTo(self).offset(-15);
	}];
	
	[themeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(20);
		make.top.equalTo(titleLabel).offset(5);
		make.size.mas_equalTo(CGSizeMake(themeLabelWidth, 16));
	}];
	
    NSString *titleStr = [service_info objectForKey:@"title"];
    if (titleStr) {
        titleLabel.text = titleStr;
    }
	
	
//	NSString *ownerName = [service_info objectForKey:kAYServiceArgsScreenName];
//	ownerNameLabel.text = ownerName;
//	NSString *compName = [Tools serviceCompleteNameFromSKUWith:service_info];
//	themeLabel.text = compName;
//	
//	id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
//	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
//	NSString *pre = cmd.route;
//	
//	NSNumber *pre_mode = [service_info objectForKey:@"perview_mode"];
//	if (pre_mode) {     //用户预览
//		NSDictionary *user_info;
//		CURRENPROFILE(user_info)
//		
//		ownerNameLabel.text = [user_info objectForKey:@"screen_name"];
//		NSString* photo_name = [user_info objectForKey:@"screen_photo"];
//		[ownerPhoto sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:photo_name]]
//					 placeholderImage:IMGRESOURCE(@"default_user")];
//		ownerPhoto.userInteractionEnabled = NO;
//		
//	} else {
//		
//		ownerPhoto.userInteractionEnabled = YES;
//		ownerNameLabel.text = [service_info objectForKey:@"screen_name"];
//		NSString *screen_photo = [service_info objectForKey:@"screen_photo"];
//		[ownerPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", pre, screen_photo]]
//						 placeholderImage:IMGRESOURCE(@"default_user") /*options:SDWebImageRefreshCached*/];
//	}
//	
//	if (!ownerName || [ownerName isEqualToString:@""]) {
//		ownerPhoto.userInteractionEnabled = NO;
//	}
    return nil;
}

@end
