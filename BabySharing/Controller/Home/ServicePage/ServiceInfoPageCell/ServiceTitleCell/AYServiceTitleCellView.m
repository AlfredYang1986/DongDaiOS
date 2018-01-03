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
	UILabel *tagLabel;
	
	NSDictionary *service_info;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		titleLabel = [UILabel creatLabelWithText:@"Service title is not set" textColor:[UIColor black] fontSize:618.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(28);
			make.left.equalTo(self).offset(SCREEN_MARGIN_LR);
			make.right.equalTo(self).offset(-SCREEN_MARGIN_LR);
		}];
		
		themeLabel = [UILabel creatLabelWithText:@"Theme" textColor:[UIColor black] fontSize:313.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview: themeLabel];
		[themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(titleLabel.mas_bottom).offset(20);
		}];
		
		tagLabel = [UILabel creatLabelWithText:@"TAG" textColor:[UIColor black] fontSize:612.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview: tagLabel];
		[tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(themeLabel.mas_bottom).offset(5);
		}];
		
		UIView *bottom_view = [[UIView alloc] init];
		bottom_view.backgroundColor = [UIColor garyLine];
		[self addSubview:bottom_view];
		[bottom_view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(tagLabel.mas_bottom).offset(30);
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
	
	NSDictionary *info_categ = [service_info objectForKey:kAYServiceArgsCategoryInfo];
	NSString *service_cat = [info_categ objectForKey:kAYServiceArgsCat];
	
	NSString *themeStr;
	if ([service_cat containsString:@"看"]) {
		themeStr = [info_categ objectForKey:kAYServiceArgsCatSecondary];
	} else if ([service_cat isEqualToString:kAYStringCourse]) {
		themeStr = [info_categ objectForKey:kAYServiceArgsCatThirdly];
	} else {
		NSLog(@"---null---");
	}
	
	if (themeStr && ![themeStr isEqualToString:@""]) {
		themeLabel.text = themeStr;
	}
	[themeLabel sizeToFit];
	CGFloat themeLabelWidth = themeLabel.bounds.size.width + 10;
	
	NSString *titleStr = [service_info objectForKey:kAYServiceArgsTitle];
	if (titleStr && ![titleStr isEqualToString:@""]) {
		titleLabel.text = titleStr;
	}
	[titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self).offset(-5);
		make.left.equalTo(self).offset(30 + themeLabelWidth);
		make.right.equalTo(self).offset(-15);
	}];
	
	[themeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(20);
		make.top.equalTo(titleLabel).offset(5);
		make.size.mas_equalTo(CGSizeMake(themeLabelWidth, 16));
	}];
	
	
	
//	NSString *ownerName = [service_info objectForKey:kAYProfileArgsScreenName];
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
