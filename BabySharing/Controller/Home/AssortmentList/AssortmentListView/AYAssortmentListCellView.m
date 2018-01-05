//
//  AYAssortmentListCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 21/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYAssortmentListCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"

@implementation AYAssortmentListCellView {
	UIImageView *imageView;
	UILabel *assortmentTitle;
	UILabel *skipedCount;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		
		imageView = [[UIImageView alloc]init];
//		imageView.backgroundColor = [Tools randomColor];
		[self addSubview: imageView];
		[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self);
		}];
		
		assortmentTitle = [Tools creatLabelWithText:@"# Assortment' title #" textColor:[Tools whiteColor] fontSize:618.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		[self addSubview:assortmentTitle];
		[assortmentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(imageView).offset(-5);
			make.centerX.equalTo(self);
		}];
		
		skipedCount = [Tools creatLabelWithText:@"Skiped' count" textColor:[Tools whiteColor] fontSize:11.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		[Tools setViewBorder:skipedCount withRadius:10.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools borderAlphaColor]];
		[self addSubview:skipedCount];
		[skipedCount sizeToFit];
		[skipedCount mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(assortmentTitle.mas_bottom).offset(10);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(skipedCount.bounds.size.width + 20, 20));
		}];
		skipedCount.hidden = YES;
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"AssortmentListCell", @"AssortmentListCell");
	
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
	NSDictionary *cellInfo = args;
	NSString *titleStr = [cellInfo objectForKey:@"title"];
	assortmentTitle.text = titleStr;
	
	NSString *img_name = [cellInfo objectForKey:@"assortment_img"];
	imageView.image = IMGRESOURCE(img_name);
	
	return nil;
}

@end
