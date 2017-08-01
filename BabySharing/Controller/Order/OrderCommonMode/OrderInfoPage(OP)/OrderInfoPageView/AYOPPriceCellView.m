//
//  AYOPPriceCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOPPriceCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYOrderPageTimeView.h"

@implementation AYOPPriceCellView {
	
	//	UIImageView *photoIcon;
//	UILabel *titleLabel;
//	UILabel *orderNoLabel;
//	UILabel *addressLabel;
	UILabel *sumPriceLabel;
	UILabel *unitPriceLabel;
	
	NSDictionary *service_info;
	
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		/*******************************/
		
		unitPriceLabel = [Tools creatUILabelWithText:@"$100 * 1 Uint" andTextColor:[Tools blackColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:unitPriceLabel];
		[unitPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-15);
			make.bottom.equalTo(self.mas_bottom).offset(-15);
		}];
		
		sumPriceLabel = [Tools creatUILabelWithText:@"$100" andTextColor:[Tools blackColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:sumPriceLabel];
		[sumPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(unitPriceLabel);
			make.bottom.equalTo(unitPriceLabel.mas_top).offset(-10);
		}];
		
		UILabel *priceTitle = [Tools creatUILabelWithText:@"价格" andTextColor:[Tools blackColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:priceTitle];
		[priceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(15);
			make.centerY.equalTo(sumPriceLabel);
		}];
		
		
		UIView *line_btm = [[UIView alloc]init];
		line_btm.backgroundColor = [Tools garyLineColor];
		[self addSubview:line_btm];
		[line_btm mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
		}];
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"OPPriceCell", @"OPPriceCell");
	
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


#pragma mark -- messages
- (id)setCellInfo:(id)args {
	
	NSDictionary *order_info = (NSDictionary*)args;
	service_info = [order_info objectForKey:@"service"];
	
	NSString *unitCat = @"UNIT";
	NSNumber *service_cat = [service_info objectForKey:kAYServiceArgsCat];
	
	CGFloat price = ((NSNumber*)[service_info objectForKey:kAYServiceArgsPrice]).floatValue;
	
	CGFloat totalFee = ((NSNumber*)[order_info objectForKey:kAYOrderArgsTotalFee]).floatValue * 0.01;
	NSString *totalFeeStr = [NSString stringWithFormat:@"¥ %.f", totalFee];
	
	NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:totalFeeStr];
	[attributedText setAttributes:@{NSFontAttributeName:kAYFontLight(13.f), NSForegroundColorAttributeName :[Tools blackColor]} range:NSMakeRange(0, 2)];
	[attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.f], NSForegroundColorAttributeName :[Tools blackColor]} range:NSMakeRange(2, totalFeeStr.length - 2)];
	sumPriceLabel.attributedText = attributedText;
	
	if (service_cat.intValue == ServiceTypeNursery) {
		unitCat = @"小时";
		unitPriceLabel.text = [NSString stringWithFormat:@"¥%.f／%@ × %.f", price, unitCat, totalFee/price];
	}
	else if (service_cat.intValue == ServiceTypeCourse) {
		unitCat = @"次";
		unitPriceLabel.text = [NSString stringWithFormat:@"¥%.f／%@ × %d", price, unitCat, (int)(totalFee/price)];
	}
	else {
		NSLog(@"---null---");
		unitPriceLabel.text = [NSString stringWithFormat:@"¥Price／Unit × Count"];
	}
	
	return nil;
}

@end
