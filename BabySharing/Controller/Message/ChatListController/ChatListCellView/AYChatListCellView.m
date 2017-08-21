//
//  AYChatListCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 15/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYChatListCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

#import "EMConversation.h"
#import "EMMessage.h"
#import "EMTextMessageBody.h"
#import "AYGroupListCellDefines.h"

@implementation AYChatListCellView {
	
	UIImageView *themeImg;
	UILabel *themeLabel;
	UILabel *chatLabel;
	UILabel *dateLabel;
	UIView *isReadSign;
	
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
//		[Tools creatCALayerWithFrame:CGRectMake(0, 99.5, SCREEN_WIDTH, 0.5) andColor:[Tools garyLineColor] inSuperView:self];
		
		CGFloat themeImgWH = 40.f;
		themeImg = [[UIImageView alloc]init];
		themeImg.image = IMGRESOURCE(@"default_user");
		themeImg.contentMode = UIViewContentModeScaleAspectFill;
		themeImg.layer.cornerRadius = themeImgWH * 0.5;
		themeImg.layer.borderColor = [Tools borderAlphaColor].CGColor;
		themeImg.layer.borderWidth = 2.f;
		themeImg.clipsToBounds = YES;
		themeImg.layer.rasterizationScale = [UIScreen mainScreen].scale;
		[self addSubview:themeImg];
		[themeImg mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(15);
			make.top.equalTo(self).offset(10);
			make.size.mas_equalTo(CGSizeMake(themeImgWH, themeImgWH));
		}];
		//	photoIcon.userInteractionEnabled = YES;
		//	[photoIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ownerIconTap:)]];
		
		CGFloat redPWH = 12.f;
		isReadSign = [[UIView alloc] init];
		[Tools setViewBorder:isReadSign withRadius:redPWH * 0.5 andBorderWidth:0 andBorderColor:nil andBackground:[UIColor whiteColor]];
		[self addSubview:isReadSign];
		[isReadSign mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(themeImg).offset(2);
			make.top.equalTo(themeImg).offset(0);
			make.size.mas_equalTo(CGSizeMake(redPWH, redPWH));
		}];
		
		CGFloat margin = 3.f;
		UIView *redCenter = [[UIView alloc] init];
		[Tools setViewBorder:redCenter withRadius:(redPWH - margin*2) * 0.5 andBorderWidth:0 andBorderColor:nil andBackground:[UIColor redColor]];
		[isReadSign addSubview:redCenter];
		[redCenter mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(isReadSign).insets(UIEdgeInsetsMake(margin, margin, margin, margin));
		}];
		
		themeLabel = [Tools creatUILabelWithText:@"UserName" andTextColor:[Tools blackColor] andFontSize:315.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:themeLabel];
		[themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(themeImg.mas_right).offset(15);
			make.top.equalTo(themeImg);
		}];
		
		chatLabel = [Tools creatUILabelWithText:@"Message - context " andTextColor:[Tools garyColor] andFontSize:313.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		chatLabel.numberOfLines = 3.f;
		[self addSubview:chatLabel];
		[chatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(themeLabel.mas_bottom).offset(10);
			make.left.equalTo(themeLabel);
			make.right.equalTo(self).offset(-20);
			make.bottom.equalTo(self).offset(-25);
		}];
		
		dateLabel = [Tools creatUILabelWithText:@"00:00" andTextColor:[Tools blackColor] andFontSize:12.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:dateLabel];
		[dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(themeLabel);
			make.right.equalTo(self).offset(-15);
		}];
		
		[Tools addBtmLineWithMargin:15.f andAlignment:NSTextAlignmentRight andColor:[Tools garyLineColor] inSuperView:self];
		
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
	id<AYViewBase> cell = VIEW(@"ChatListCell", @"ChatListCell");
	
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
	
	NSDictionary* dic = (NSDictionary*)args;
	
	EMConversation *sation = [dic objectForKey:kAYGroupListCellContentKey];
	EMMessage *last_message = sation.latestMessage;
	
	isReadSign.hidden = last_message.isRead;
	
	NSString *user_id = nil;
	if (last_message.direction == 0) {
		user_id = last_message.to;
	} else {
		user_id = last_message.from;
	}
	NSLog(@"%@",user_id);
	
	
	NSMutableDictionary* dic_owner_id = [[NSMutableDictionary alloc] init];
	[dic_owner_id setValue:user_id forKey:@"user_id"];
	
	id<AYFacadeBase> f_name_photo = DEFAULTFACADE(@"ScreenNameAndPhotoCache");
	AYRemoteCallCommand* cmd_name_photo = [f_name_photo.commands objectForKey:@"QueryScreenNameAndPhoto"];
	[cmd_name_photo performWithResult:[dic_owner_id copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
		if (success) {
			
			themeLabel.text = [result objectForKey:kAYProfileArgsScreenName];
			
			NSString *screen_photo = [result objectForKey:kAYProfileArgsScreenPhoto];
			[themeImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kAYDongDaDownloadURL, screen_photo]] placeholderImage:IMGRESOURCE(@"default_user") options:SDWebImageRefreshCached];
			
		}
	}];
	
//	chatLabel.text = ((EMTextMessageBody*)last_message.body).text;
	// 调整行间距
	NSString *messageStr = ((EMTextMessageBody*)last_message.body).text;
	chatLabel.attributedText = [Tools transStingToAttributeString:messageStr withLineSpace:4.f];
	
	[self setContentDate:last_message.timestamp];
	
	return nil;
}

- (void)setContentDate:(NSTimeInterval)date {
	NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:date*0.001];
	dateLabel.text = [Tools compareCurrentTime:date2];
}

@end
