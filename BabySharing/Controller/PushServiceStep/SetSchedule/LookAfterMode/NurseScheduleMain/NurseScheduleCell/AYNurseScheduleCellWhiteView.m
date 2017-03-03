//
//  AYNurseScheduleCellWhiterView.m
//  BabySharing
//
//  Created by Alfred Yang on 1/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYNurseScheduleCellWhiteView.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"

@implementation AYNurseScheduleCellWhiteView {
	
	UILabel *startLabel;
	UILabel *endLabel;
	UIButton *delBtn;
	
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		CGFloat selfHeight = 55.f;
		UIColor *mainColor = [Tools whiteColor];
		self.backgroundColor = [Tools themeColor];
		
		startLabel = [Tools creatUILabelWithText:@"添加时间" andTextColor:mainColor andFontSize:116.f andBackgroundColor:nil andTextAlignment:1];
		[self addSubview:startLabel];
		[startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.centerY.equalTo(self);
			make.width.mas_equalTo(80);
		}];
		
		endLabel = [Tools creatUILabelWithText:@"添加时间" andTextColor:mainColor andFontSize:116.f andBackgroundColor:nil andTextAlignment:1];
		[self addSubview:endLabel];
		[endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(startLabel.mas_right).offset(55);
			make.centerY.equalTo(self);
			make.width.mas_equalTo(80);
		}];
		
		delBtn = [[UIButton alloc] init];
		[delBtn setImage:IMGRESOURCE(@"cross_white") forState:UIControlStateNormal];
		[self addSubview:delBtn];
		[delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-20);
			make.centerY.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(30, 30));
		}];
		[delBtn addTarget:self action:@selector(didDelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
		
		[Tools creatCALayerWithFrame:CGRectMake(22, selfHeight - 0.5, 80, 0.5) andColor:mainColor inSuperView:self];
		[Tools creatCALayerWithFrame:CGRectMake(125, selfHeight * 0.5 - 1, 15, 2) andColor:mainColor inSuperView:self];
		[Tools creatCALayerWithFrame:CGRectMake(160, selfHeight - 0.5, 80, 0.5) andColor:mainColor inSuperView:self];
		
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
	id<AYViewBase> cell = VIEW(@"NurseScheduleCellTheme", @"NurseScheduleCellTheme");
	
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
- (void)didDelBtnClick:(UIButton*)btn {
	
	NSNumber *tmp = [NSNumber numberWithInteger:btn.tag];
	kAYViewSendNotify(self, @"delTimeDuration:", &tmp)
}

#pragma mark -- notifies
- (id)setCellInfo:(id)args {
	
	NSNumber *is_first = [args objectForKey:@"is_first"];
	delBtn.hidden = is_first.boolValue;
	delBtn.tag = ((NSNumber*)[args objectForKey:@"row"]).integerValue - 1;
	
	NSDictionary *dic_time = [args objectForKey:@"dic_time"];
	if (dic_time) {
		NSNumber *top = [dic_time objectForKey:kAYServiceArgsStart];
		NSNumber *btm = [dic_time objectForKey:kAYServiceArgsEnd];
		
		NSMutableString *tmp = [NSMutableString stringWithFormat:@"%.4d", top.intValue];
		[tmp insertString:@":" atIndex:2];
		startLabel.text = tmp;
		
		tmp = [NSMutableString stringWithFormat:@"%.4d", btm.intValue];
		[tmp insertString:@":" atIndex:2];
		endLabel.text = tmp;
	}
	
	return nil;
}

@end
