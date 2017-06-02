//
//  AYServiceDescCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 23/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceDescCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"

@implementation AYServiceDescCellView {
	
	UILabel *tipsTitleLabel;
	
	UIImageView *olock_icon;
	UILabel *courseLengthLabel;
//	UILabel *serviceDescLabel;
	UITextView *descTextView;
	UIButton *showhideBtn;
	
	NSDictionary *dic_attr;
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
		
		NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
		paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
		paraStyle.alignment = NSTextAlignmentLeft;
		paraStyle.lineSpacing = 8.f;
		dic_attr = @{NSKernAttributeName:@1, NSParagraphStyleAttributeName:paraStyle, NSForegroundColorAttributeName:[Tools blackColor], NSFontAttributeName:[UIFont systemFontOfSize:15.f]};
		
		tipsTitleLabel = [Tools creatUILabelWithText:@"服务介绍" andTextColor:[Tools garyColor] andFontSize:618.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
		[self addSubview:tipsTitleLabel];
		[tipsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.top.equalTo(self).offset(30);
		}];
		
		courseLengthLabel = [Tools creatUILabelWithText:@"Lection Length" andTextColor:[Tools themeColor] andFontSize:615.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentRight];
		[self addSubview:courseLengthLabel];
		[courseLengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-20);
			make.centerY.equalTo(tipsTitleLabel);
		}];
		
		olock_icon = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"lessondetails_icon_time")];
		[self addSubview:olock_icon];
		[olock_icon mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(courseLengthLabel.mas_left).offset(-3);
			make.centerY.equalTo(courseLengthLabel);
			make.size.mas_equalTo(CGSizeMake(12, 12));
		}];
		
		descTextView = [[UITextView alloc] init];
		[self addSubview:descTextView];
		descTextView.textColor= [Tools blackColor];
		descTextView.font = [UIFont systemFontOfSize:15.f];
		descTextView.editable = NO;
		descTextView.scrollEnabled = NO;
		descTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
		[descTextView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(tipsTitleLabel.mas_bottom).offset(20);
			make.left.equalTo(self).offset(20);
			make.right.equalTo(self).offset(-20);
			make.bottom.equalTo(self).offset(-60);
//			make.height.mas_equalTo(60);
		}];
		
		showhideBtn = [[UIButton alloc] init];
		[showhideBtn setImage:IMGRESOURCE(@"details_icon_arrow_down") forState:UIControlStateNormal];
		[self addSubview:showhideBtn];
		[showhideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(descTextView.mas_bottom).offset(15);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(26, 26));
		}];
		
		CGFloat margin = 0;
		[Tools creatCALayerWithFrame:CGRectMake(margin, 0, SCREEN_WIDTH - margin * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:self];
		
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
	id<AYViewBase> cell = VIEW(@"ServiceDescCell", @"ServiceDescCell");
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
	
	NSString *descStr = [service_info objectForKey:kAYServiceArgsDescription];
	if (descStr) {
		
		NSAttributedString *descAttri = [[NSAttributedString alloc] initWithString:descStr attributes:dic_attr];
		descTextView.attributedText = descAttri;
	}
	
	NSNumber *service_cat = [service_info objectForKey:kAYServiceArgsServiceCat];
	switch (service_cat.intValue) {
	case ServiceTypeCourse:
	{
		
		NSNumber *course_length = [service_info objectForKey:kAYServiceArgsCourseduration];
		NSString *lengthStr = [NSString stringWithFormat:@"%@分钟", course_length];
		NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:lengthStr];
		[attributedText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.f]} range:NSMakeRange(0, lengthStr.length - 2)];
		[attributedText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f]} range:NSMakeRange(lengthStr.length - 2, 2)];
		courseLengthLabel.attributedText = attributedText;
	}
		break;
	case ServiceTypeNursery:
	{
		olock_icon.hidden = courseLengthLabel.hidden = YES;
	}
		break;
			
  default:
			break;
	}
	
	return nil;
}

@end
