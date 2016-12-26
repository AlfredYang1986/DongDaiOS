//
//  AYHomeDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 22/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYHomeDelegate.h"
#import "AYFactoryManager.h"
#import "AYProfileHeadCellView.h"
#import "Notifications.h"
#import "AYModelFacade.h"
#import "AYProfileOrigCellView.h"
#import "AYProfileServCellView.h"

@interface HomeTopTipCell : UITableViewCell

@end

@implementation HomeTopTipCell {
	
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		NSDate *nowDate = [NSDate date];
		NSDateFormatter *format = [Tools creatDateFormatterWithString:@"HH"];
		NSString *dateStr = [format stringFromDate:nowDate];
		
		NSString *on = nil;
		int timeSpan = dateStr.intValue;
		if (timeSpan >= 6 && timeSpan < 12) {
			on = @"上午好";
		} else if (timeSpan >= 12 && timeSpan < 18) {
			on = @"下午好";
		} else if((timeSpan >= 18 && timeSpan < 24) || (timeSpan >= 0 && timeSpan < 6)){
			on = @"晚上好";
		} else {
			on = @"获取系统时间错误";
		}
		
		UILabel *hello = [Tools creatUILabelWithText:on andTextColor:[Tools blackColor] andFontSize:-26.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:hello];
		[hello mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.top.equalTo(self).offset(30);
		}];
		
		UILabel *tipsLabel = [Tools creatUILabelWithText:@"为您的孩子找个好去处" andTextColor:[Tools blackColor] andFontSize:17.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:tipsLabel];
		[tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.right.equalTo(self).offset(-20);
			make.top.equalTo(hello.mas_bottom).offset(10);
		}];
		
		CALayer *sepLayer = [CALayer layer];
		sepLayer.frame = CGRectMake(20, 119.5, 50, 0.5);
		sepLayer.backgroundColor = [Tools garyLineColor].CGColor;
		[self.layer addSublayer:sepLayer];
	}
	return self;
}

@end

@implementation AYHomeDelegate{
    NSArray *servicesData;
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

- (id)changeQueryData:(id)args {
    servicesData = (NSArray*)args;
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return servicesData.count + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		static NSString *indentfier = @"HomeTopTipCell";
		HomeTopTipCell * cell = [tableView dequeueReusableCellWithIdentifier:indentfier];
//		if (cell == nil) {
//			cell = [[HomeTopTipCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentfier];
//		}
		return cell;
	} else {
	
		NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeServPerCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name];
		cell.controller = self.controller;
		
		id tmp = [servicesData objectAtIndex:indexPath.row - 1];
		kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
		
		((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
		return (UITableViewCell*)cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
		return 140;
    } else {
		return 335;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return;
	}
	
	NSDictionary *tmp = [servicesData objectAtIndex:indexPath.row - 1];
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"PersonalPage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    id<AYCommand> cmd = [self.notifies objectForKey:@"scrollOffsetY:"];
//    CGFloat offset = scrollView.contentOffset.y;
//    NSNumber *offset_y = [NSNumber numberWithFloat:offset];
//    [cmd performWithResult:&offset_y];
}

#pragma mark -- actions


@end
