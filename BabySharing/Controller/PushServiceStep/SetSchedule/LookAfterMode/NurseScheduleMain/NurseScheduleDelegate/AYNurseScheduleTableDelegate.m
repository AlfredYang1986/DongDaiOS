//
//  AYNurseScheduleTableDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 1/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYNurseScheduleTableDelegate.h"
#import "AYFactoryManager.h"

@interface AYNurseScheduleTableDelegate ()

@end

@implementation AYNurseScheduleTableDelegate {
	NSArray *querydata;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	
}

- (void)performWithResult:(NSObject**)obj {
	
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCommandTypeModule;
}

- (NSString*)getViewType {
	return kAYFactoryManagerCatigoryDelegate;
}

- (NSString*)getViewName {
	return [NSString stringWithUTF8String:object_getClassName([self class])];
}

-(id)queryData:(NSDictionary*)args {
	
	return nil;
}

#pragma mark -- table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
//		return querydata.count;
		return 2;
	} else {
		return 0;
	}
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"NurseScheduleCellTheme"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
	cell.controller = _controller;
	
	NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
	[dic setValue:[querydata objectAtIndex:indexPath.row] forKey:@"title"];
	[dic setValue:[NSNumber numberWithFloat:indexPath.row] forKey:@"index"];
	
	id<AYCommand> set_cmd = [cell.commands objectForKey:@"setCellInfo:"];
	[set_cmd performWithResult:&dic];
	
	((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
	return (UITableViewCell*)cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headView = [[UIView alloc]init];
	headView.backgroundColor = [Tools whiteColor];
	
	UILabel *titleLabel = [Tools creatUILabelWithText:@"1.每天可以服务的时间" andTextColor:[Tools themeColor] andFontSize:120.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[headView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(headView).offset(20);
		make.centerY.equalTo(headView).offset(15);
	}];
	
	if (section == 0) {
		UIButton *addSignBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
		addSignBtn.tintColor = [Tools themeColor];
		addSignBtn.userInteractionEnabled = NO;
		[headView addSubview:addSignBtn];
		[addSignBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(headView).offset(-20);
			make.centerY.equalTo(titleLabel);
			make.size.mas_equalTo(CGSizeMake(50, 50));
		}];
	} else {
		titleLabel.text = @"2.您的休息日";
		UIImageView *signView = [[UIImageView alloc] init];
		signView.image = IMGRESOURCE(@"plan_time_icon");
		[signView sizeToFit];
		[headView addSubview:signView];
		[signView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(headView).offset(-20);
			make.centerY.equalTo(titleLabel);
			make.size.mas_equalTo(signView.image.size);
		}];
	}
	
	return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	
	return 70;
}
@end
