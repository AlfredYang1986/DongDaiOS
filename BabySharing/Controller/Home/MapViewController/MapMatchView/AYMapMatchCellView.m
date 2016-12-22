//
//  AYMapMatchCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 21/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYMapMatchCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"
#import "AYViewController.h"
#import "AYPServsCellView.h"

@implementation AYMapMatchCellView {
	
	UIImageView *photoIcon;
	UILabel *titleLabel;
	
	UITableView *servTableView;
	
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

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

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (instancetype)init{
	self = [super init];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void)initialize {
	
	UIImageView *bgView= [[UIImageView alloc]init];
	UIImage *bgImg = IMGRESOURCE(@"map_match_bg");
	bgImg = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(50, 100, 10, 10) resizingMode:UIImageResizingModeStretch];
	bgView.image = bgImg;
	[self addSubview:bgView];
	[bgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
	}];
	
	photoIcon = [[UIImageView alloc]init];
	photoIcon.image = IMGRESOURCE(@"theme_image");
//	photoIcon.image = IMGRESOURCE(@"default_user");
	photoIcon.layer.cornerRadius = 45 * 0.5;
	photoIcon.layer.borderColor = [Tools borderAlphaColor].CGColor;
	photoIcon.layer.borderWidth = 2.f;
	photoIcon.clipsToBounds = YES;
	photoIcon.layer.rasterizationScale = [UIScreen mainScreen].scale;
	[self addSubview:photoIcon];
	[photoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(47.5);
		make.top.equalTo(self).offset(10);
		make.size.mas_equalTo(CGSizeMake(45, 45));
	}];
	photoIcon.userInteractionEnabled = YES;
	[photoIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ownerIconTap:)]];
	
	titleLabel = [Tools creatUILabelWithText:@"服务妈妈的主题服务" andTextColor:[Tools blackColor] andFontSize:-14.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(35);
		make.top.equalTo(photoIcon.mas_bottom).offset(10);
	}];
	
	servTableView = [[UITableView alloc]init];
	servTableView.delegate = self;
	servTableView.dataSource = self;
	servTableView.showsVerticalScrollIndicator = NO;
	servTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self addSubview:servTableView];
	[servTableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self);
		make.top.equalTo(titleLabel.mas_bottom).offset(15);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 70, 160));
	}];
	
	[servTableView registerClass:NSClassFromString(@"AYPServsCellView") forCellReuseIdentifier:@"AYPServsCellView"];
	
//	[self setUpReuseCell];
}

- (void)layoutSubviews {
	[super layoutSubviews];
}

- (void)setServiceData:(NSArray *)serviceData {
	
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"MapMatchCell", @"MapMatchCell");
	
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

#pragma mark -- actions
- (void)ownerIconTap:(UITapGestureRecognizer*)tap {
	
	AYViewController* des = DEFAULTCONTROLLER(@"OneProfile");
	
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:_controller forKey:kAYControllerActionSourceControllerKey];
//	[dic_push setValue:[service_info objectForKey:@"owner_id"] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
	
}

#pragma mark -- messages
- (id)setCellInfo:(NSArray*)dic_args {
	_serviceData = dic_args;
	
	return nil;
}

#pragma mark -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//	return _serviceData.count;
	return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *indentfier = @"AYPServsCellView";
	AYPServsCellView *cell  = [tableView dequeueReusableCellWithIdentifier:indentfier];
	
	NSDictionary *tmp = [[NSDictionary alloc]init];
	cell.service_info = tmp;
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	_didTouchUpInSubCell = ^(NSDictionary* service_info){
//		
//	};
	NSDictionary *tmp;
	_didTouchUpInSubCell(tmp);
}

@end
