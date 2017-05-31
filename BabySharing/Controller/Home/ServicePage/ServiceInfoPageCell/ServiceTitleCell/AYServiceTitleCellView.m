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
//    UIImageView *pointsImageView;
	
	UILabel *themeLabel;
	UILabel *ownerNameLabel;
	UIImageView *ownerPhoto;
	
    UILabel *filtBabyArgsLabel;
    UILabel *capacityLabel;
    
    UIImageView *servantSign;
    UILabel *servantLabel;
	
	NSDictionary *service_info;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        titleLabel = [Tools creatUILabelWithText:@"Service title is not set" andTextColor:[Tools blackColor] andFontSize:320.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(20);
            make.left.equalTo(self).offset(20);
			make.right.equalTo(self).offset(-15);
        }];
		
		themeLabel = [Tools creatUILabelWithText:@"Service Theme" andTextColor:[Tools blackColor] andFontSize:317.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview: themeLabel];
		[themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(titleLabel.mas_bottom).offset(15);
			make.right.equalTo(self).offset(-80);
		}];
		
		ownerNameLabel = [Tools creatUILabelWithText:@"Provider Name" andTextColor:[Tools blackColor] andFontSize:14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:ownerNameLabel];
		[ownerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(themeLabel.mas_bottom).offset(5);
			make.right.equalTo(self).offset(-80);
		}];
		
		ownerPhoto = [[UIImageView alloc]init];
		ownerPhoto.image = IMGRESOURCE(@"default_user");
		ownerPhoto.contentMode = UIViewContentModeScaleAspectFill;
		[Tools setViewBorder:ownerPhoto withRadius:22.5f andBorderWidth:2.f andBorderColor:[Tools borderAlphaColor] andBackground:nil];
		[self addSubview:ownerPhoto];
		[ownerPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-20);
			make.top.equalTo(titleLabel.mas_bottom).offset(10);
			make.size.mas_equalTo(CGSizeMake(45, 45));
		}];
		ownerPhoto.userInteractionEnabled = YES;
		[ownerPhoto addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didOwnerPhotoClick)]];
		
		UIView *sepLine = [[UIView alloc]init];
		sepLine.backgroundColor = [Tools garyLineColor];
		[self addSubview:sepLine];
		[sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.top.equalTo(ownerPhoto.mas_bottom).offset(25);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
		}];
		
//        capacity_icon
        UIImageView *signCapacity = [[UIImageView alloc]init];
        signCapacity.image = IMGRESOURCE(@"service_page_capacity");
        [self addSubview:signCapacity];
        [signCapacity mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(ownerPhoto.mas_bottom).offset(45);
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-45);
            make.size.mas_equalTo(CGSizeMake(27, 27));
        }];
        
        capacityLabel = [Tools creatUILabelWithText:@"0 Children" andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
        [self addSubview:capacityLabel];
        [capacityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(signCapacity);
            make.top.equalTo(signCapacity.mas_bottom).offset(10);
        }];
        
        //        age_boundary_icon
        UIImageView *signBabyAges = [[UIImageView alloc]init];
        signBabyAges.image = IMGRESOURCE(@"service_page_age_boundary");
        [self addSubview:signBabyAges];
        [signBabyAges mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(signCapacity).offset(-SCREEN_WIDTH * 0.3f);
            make.centerY.equalTo(signCapacity);
            make.size.equalTo(signCapacity);
        }];
        
        filtBabyArgsLabel = [Tools creatUILabelWithText:@"0-0 years old" andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
        [self addSubview:filtBabyArgsLabel];
        [filtBabyArgsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(signBabyAges);
            make.centerY.equalTo(capacityLabel);
        }];
        
        //        allow_leave_icon
        servantSign = [[UIImageView alloc]init];
        servantSign.image = IMGRESOURCE(@"service_page_servant");
        [self addSubview:servantSign];
        [servantSign mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(signCapacity).offset(SCREEN_WIDTH * 0.3f);
            make.centerY.equalTo(signCapacity);
            make.size.equalTo(signCapacity);
        }];
        
        servantLabel = [Tools creatUILabelWithText:@"Numb of servant" andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
        [self addSubview:servantLabel];
        [servantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(servantSign);
            make.centerY.equalTo(capacityLabel);
        }];
		
//        CGFloat margin = 0;
//		[Tools creatCALayerWithFrame:CGRectMake(margin, 0, SCREEN_WIDTH - margin * 2, 0.5) andColor:[Tools garyColor] inSuperView:self];
		
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
    
    NSString *titleStr = [service_info objectForKey:@"title"];
    if (titleStr) {
        titleLabel.text = titleStr;
    }
	
	NSString *ownerName = [service_info objectForKey:kAYServiceArgsScreenName];
	ownerNameLabel.text = ownerName;
	
	NSString *servantCat;
	NSArray *options_title_cans;
	NSNumber *service_cat = [service_info objectForKey:kAYServiceArgsServiceCat];
	NSNumber *cans_cat = [service_info objectForKey:kAYServiceArgsCourseCat];
	
	if (service_cat.intValue == ServiceTypeNursery) {
		servantCat = @"服务者";
		options_title_cans = kAY_service_options_title_nursery;
		//服务主题分类
		if (cans_cat.intValue == -1 || cans_cat.integerValue >= options_title_cans.count) {
			themeLabel.text = @"该服务主题待调整";
		} else {
			NSString *themeStr = options_title_cans[cans_cat.integerValue];
			themeLabel.text = themeStr;
		}
		
	}
	else if (service_cat.intValue == ServiceTypeCourse) {
		servantCat = @"老师";
		NSString *servCatStr = @"课程";
		options_title_cans = kAY_service_options_title_course;
		NSNumber *cans = [service_info objectForKey:kAYServiceArgsCourseSign];
		//服务主题分类
		if (cans_cat.intValue == -1 || cans_cat.integerValue >= options_title_cans.count) {
			themeLabel.text = @"该服务主题待调整";
		}
		else {
			
			NSString *costomStr = [service_info objectForKey:kAYServiceArgsCourseCoustom];
			if (costomStr && ![costomStr isEqualToString:@""]) {
				themeLabel.text = [NSString stringWithFormat:@"%@%@", costomStr, servCatStr];
				
			} else {
				NSArray *courseTitleOfAll = kAY_service_course_title_ofall;
				NSArray *signTitleArr = [courseTitleOfAll objectAtIndex:cans_cat.integerValue];
				if (cans.integerValue < signTitleArr.count) {
					NSString *courseSignStr = [signTitleArr objectAtIndex:cans.integerValue];
					themeLabel.text = [NSString stringWithFormat:@"%@%@", courseSignStr, servCatStr];
				} else {
					themeLabel.text = @"该服务主题待调整";
				}
			}//是否自定义课程标签判断end
		}
	} else {
		servantCat = @"服务者";
		NSLog(@"---null---");
		themeLabel.text = @"该服务类型待调整";
	}
	
	id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
	NSString *pre = cmd.route;
	
	NSNumber *pre_mode = [service_info objectForKey:@"perview_mode"];
	if (pre_mode) {     //用户预览
		NSDictionary *user_info;
		CURRENPROFILE(user_info)
		
		ownerNameLabel.text = [user_info objectForKey:@"screen_name"];
		NSString* photo_name = [user_info objectForKey:@"screen_photo"];
		[ownerPhoto sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:photo_name]]
					 placeholderImage:IMGRESOURCE(@"default_user")];
		ownerPhoto.userInteractionEnabled = NO;
		
	} else {
		
		ownerPhoto.userInteractionEnabled = YES;
		ownerNameLabel.text = [service_info objectForKey:@"screen_name"];
		NSString *screen_photo = [service_info objectForKey:@"screen_photo"];
		if (screen_photo) {
			[ownerPhoto sd_setImageWithURL:[NSURL URLWithString:[pre stringByAppendingString:screen_photo]]
						 placeholderImage:IMGRESOURCE(@"default_user") /*options:SDWebImageRefreshCached*/];
		}
	}
	
    NSDictionary *age_boundary = [service_info objectForKey:@"age_boundary"];
    NSNumber *usl = ((NSNumber *)[age_boundary objectForKey:@"usl"]);
    NSNumber *lsl = ((NSNumber *)[age_boundary objectForKey:@"lsl"]);
    NSString *ages = [NSString stringWithFormat:@"%d-%d岁",lsl.intValue,usl.intValue];
    filtBabyArgsLabel.text = [NSString stringWithFormat:@"%@",ages];
    
    NSNumber *capacity = [service_info objectForKey:@"capacity"];
    capacityLabel.text = [NSString stringWithFormat:@"可接纳%d个孩子",capacity.intValue];
    
    NSNumber *servant = [service_info objectForKey:kAYServiceArgsServantNumb];
	servantLabel.text = [NSString stringWithFormat:@"%@个%@", servant, servantCat];
	
	if (!ownerName || [ownerName isEqualToString:@""]) {
		ownerPhoto.userInteractionEnabled = NO;
	}
    return nil;
}

@end
