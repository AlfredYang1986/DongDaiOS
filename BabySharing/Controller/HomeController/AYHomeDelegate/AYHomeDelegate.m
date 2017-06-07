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
		
		UILabel *hello = [Tools creatUILabelWithText:on andTextColor:[Tools garyColor] andFontSize:330.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:hello];
		[hello mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.top.equalTo(self).offset(30 + 28);
		}];
		
		UILabel *tipsLabel = [Tools creatUILabelWithText:@"为您的孩子找个好去处" andTextColor:[Tools garyColor] andFontSize:18.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:tipsLabel];
		[tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.right.equalTo(self).offset(-20);
			make.top.equalTo(hello.mas_bottom).offset(24);
		}];
		
		[Tools creatCALayerWithFrame:CGRectMake(20, 28, 22, 2) andColor:[Tools garyLineColor] inSuperView:self];
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
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
		return 140 + 28;
    } else {
		return 331;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return;
	}
	
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		
		NSDictionary *service_info = [servicesData objectAtIndex:indexPath.row - 1];
//
//		id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
//		NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
//		[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
//		[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
//		[dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
//		[dic setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
//		
//		id<AYCommand> cmd_show_module = PUSH;
//		[cmd_show_module performWithResult:&dic];
		
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
		[tmp setValue:cell forKey:@"cell"];
		[tmp setValue:service_info forKey:@"service_info"];
		kAYDelegateSendNotify(self, @"didSelectedRow:", &tmp)
		
	});
	
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	static CGFloat offset_origin_y = 0;
	CGFloat offset_now_y = scrollView.contentOffset.y;
	CGFloat offset_t = offset_origin_y - offset_now_y;
	NSLog(@"%f", offset_t);
	
	if (offset_t  > 0.1) {		//下滑往上滚
		kAYDelegateSendNotify(self, @"scrollToShowTop", nil)
	}
	else if(offset_t < - 0.1) {		//上滑往下滚
		kAYDelegateSendNotify(self, @"scrollToHideTop", nil)
	}
	offset_origin_y = offset_now_y;
}

#pragma mark -- actions


@end
