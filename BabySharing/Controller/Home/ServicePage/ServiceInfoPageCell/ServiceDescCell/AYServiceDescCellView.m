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
	UILabel *descLabel;
	UIButton *showhideBtn;
	
	NSDictionary *dic_attr;
	NSDictionary *service_info;
	
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
	
	NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
	paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
	paraStyle.alignment = NSTextAlignmentLeft;
	paraStyle.lineSpacing = 8.f;
	
	dic_attr = @{ NSParagraphStyleAttributeName:paraStyle,
				  NSForegroundColorAttributeName:[UIColor gary],
				  NSFontAttributeName:[UIFont systemFontOfSize:16.f]
				  };
	
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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.clipsToBounds = YES;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		tipsTitleLabel = [UILabel creatLabelWithText:@"服务介绍" textColor:[Tools lightGaryColor] fontSize:618.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:tipsTitleLabel];
		[tipsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(SCREEN_MARGIN_LR);
			make.top.equalTo(self).offset(30);
		}];

		descLabel = [UILabel creatLabelWithText:@"" textColor:[UIColor gary] fontSize:15 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:descLabel];
		[descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(tipsTitleLabel);
			make.top.equalTo(tipsTitleLabel.mas_bottom).offset(20);
			make.bottom.equalTo(self).offset(0);
		}];
		
		showhideBtn = [UIButton creatButtonWithTitle:@"展开" titleColor:[UIColor gary] fontSize:15 backgroundColor:nil];
//		[showhideBtn setTitle:@"展开" forState:UIControlStateNormal];
		[showhideBtn setTitle:@"收起" forState:UIControlStateSelected];
		[self addSubview:showhideBtn];
		[showhideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(tipsTitleLabel);
			make.right.equalTo(self).offset(-SCREEN_MARGIN_LR+5);
			make.size.mas_equalTo(CGSizeMake(40, 40));
		}];
		[showhideBtn addTarget:self action:@selector(didShowhideBtnClick) forControlEvents:UIControlEventTouchUpInside];
		
	}
	return self;
}

#pragma mark -- commands


#pragma mark -- actions
-(CGFloat)getAttrStrHeight:(NSAttributedString*)str width:(CGFloat)width {
	
	CGSize size = [str boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
	return size.height;
}


- (void)didShowhideBtnClick {
	
	NSNumber *tmp = [NSNumber numberWithBool:showhideBtn.selected];
	[(AYViewController*)self.controller performSel:@"showHideDescDetail:" withResult:&tmp];
}

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

- (BOOL)isEmpty:(NSString *)str {
	
	if (!str || [str isEqualToString:@""]) {
		return YES;
	} else {
		//A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
//		NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//		NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_//|~＜＞$€^•'@#$%^&*()_+'/"""];
		NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@" \n	"];
		//Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
		NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
		return [trimedString length] == 0;
	}
}

#pragma mark -- notifies
- (id)setCellInfo:(id)args {
	service_info = (NSDictionary*)args;
	
	NSString *descStr = [service_info objectForKey:kAYServiceArgsDescription];
	if ([self isEmpty:descStr]) {
		descStr = @"服务者还没来得及介绍服务，你可以通过沟通向他咨询。";
	}
	NSAttributedString *descAttri = [[NSAttributedString alloc] initWithString:descStr attributes:dic_attr];
	descLabel.attributedText = descAttri;
	
//	CGFloat textHeight = [self getAttrStrHeight:descLabel.attributedText width:SCREEN_WIDTH - SCREEN_MARGIN_LR*2];
//	NSNumber *expend_args = [service_info objectForKey:@"is_expend"];
//
//	if (textHeight < 130) {
//		showhideBtn.hidden = YES;
//		[descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//			make.top.equalTo(tipsTitleLabel.mas_bottom).offset(20);
//			make.left.equalTo(self).offset(16);
//			make.right.equalTo(self).offset(-16);
//			make.bottom.equalTo(self).offset(-30);
//		}];
//	} else {
//		showhideBtn.hidden = NO;
//		if (expend_args.boolValue) {
//			showhideBtn.transform = CGAffineTransformMakeRotation(M_PI);
//			[descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//				make.top.equalTo(tipsTitleLabel.mas_bottom).offset(20);
//				make.left.equalTo(self).offset(16);
//				make.right.equalTo(self).offset(-16);
//				make.bottom.equalTo(self).offset(-60);
//			}];
//		} else {
//			[descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//				make.top.equalTo(tipsTitleLabel.mas_bottom).offset(20);
//				make.left.equalTo(self).offset(16);
//				make.right.equalTo(self).offset(-16);
//				make.bottom.equalTo(self).offset(-60);
//				make.height.mas_equalTo(130);
//			}];
//		}
//	}
	
	return nil;
}

@end
