//
//  AYTopicContentCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 5/1/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYTopicContentCellView.h"

@implementation AYTopicContentCellView {
	
	UIImageView *coverImage;
	UILabel *themeLabel;
	UILabel *titleLabel;
	
	UIImageView *positionSignView;
	UILabel *addressLabel;
	
	UIButton *likeBtn;
	
	NSDictionary *service_info;
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

#pragma mark -- life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UIView *shadowView = [[UIView alloc] init];
		shadowView.backgroundColor = [UIColor whiteColor];
		shadowView.layer.cornerRadius = 4.f;
		shadowView.layer.shadowColor = [Tools colorWithRED:43 GREEN:65 BLUE:114 ALPHA:1].CGColor;//shadowColor阴影颜色
		shadowView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
		shadowView.layer.shadowOpacity = 0.18f;//阴影透明度，默认0
		shadowView.layer.shadowRadius = 4;//阴影半径，默认3
		[self addSubview:shadowView];
		[self sendSubviewToBack:shadowView];
		[shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, SCREEN_MARGIN_LR, 48, SCREEN_MARGIN_LR));
		}];
		
		UIView *conterView = [[UIView alloc] init];
		[conterView setRadius:4 borderWidth:0 borderColor:nil background:nil];
		[self addSubview:conterView];
		[conterView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(shadowView);
		}];
		
		coverImage = [[UIImageView alloc]init];
		coverImage.image = IMGRESOURCE(@"default_image");
		coverImage.contentMode = UIViewContentModeScaleAspectFill;
		[conterView addSubview:coverImage];
		[coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(conterView);
			make.left.equalTo(conterView);
			make.right.equalTo(conterView);
			make.height.mas_equalTo(210);
		}];
		
		
		themeLabel = [Tools creatLabelWithText:@"Theme" textColor:[UIColor tag] fontSize:618.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:themeLabel];
		[themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(coverImage.mas_bottom).offset(14);
			make.left.equalTo(conterView).offset(SCREEN_MARGIN_LR);
			make.right.equalTo(conterView).offset(-SCREEN_MARGIN_LR);
		}];
		
		titleLabel = [Tools creatLabelWithText:@"Service Belong to Servant" textColor:[UIColor black] fontSize:16 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		titleLabel.numberOfLines = 1;
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(themeLabel);
			make.right.equalTo(themeLabel);
			make.top.equalTo(themeLabel.mas_bottom).offset(2);
		}];
		
		positionSignView = [[UIImageView alloc]init];
		[self addSubview:positionSignView];
		positionSignView.image = IMGRESOURCE(@"home_icon_location");
		[positionSignView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(titleLabel.mas_bottom).offset(15);
			make.size.mas_equalTo(CGSizeMake(11, 13));
		}];
		
		addressLabel = [Tools creatLabelWithText:@"Address Info" textColor:[Tools RGB153GaryColor] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:addressLabel];
		[addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(positionSignView);
			make.left.equalTo(positionSignView.mas_right).offset(5);
		}];
		
		
		likeBtn  = [[UIButton alloc] init];
		[likeBtn setImage:IMGRESOURCE(@"home_icon_love_normal") forState:UIControlStateNormal];
		[likeBtn setImage:IMGRESOURCE(@"home_icon_love_select") forState:UIControlStateSelected];
		[self addSubview:likeBtn];
		[likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(coverImage).offset(-10);
			make.top.top.equalTo(coverImage).offset(10);
			make.size.mas_equalTo(CGSizeMake(40, 40));
		}];
		[likeBtn addTarget:self action:@selector(didLikeBtnClick) forControlEvents:UIControlEventTouchUpInside];
		
	}
	return self;
}

#pragma mark -- actions
- (void)didLikeBtnClick {
	
	NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
	[dic setValue:likeBtn forKey:@"btn"];
	[dic setValue:[service_info objectForKey:@"service_id"] forKey:@"service_id"];
	
	kAYViewSendNotify(self, @"willCollectWithRow:", &dic)
}

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)dic_args {
	service_info = dic_args;
	
	NSString* photo_name = [service_info objectForKey:kAYServiceArgsImages];
	NSString *urlStr = [NSString stringWithFormat:@"%@%@", kAYDongDaDownloadURL, photo_name];
	if (photo_name) {
		
		[coverImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:IMGRESOURCE(@"default_image") /*options:SDWebImageRefreshCached*/];
	}
	
	NSString *service_cat = [service_info objectForKey:kAYServiceArgsCat];
	NSString *service_type = [service_info objectForKey:kAYServiceArgsType];
	NSString *service_leaf = [service_info objectForKey:kAYServiceArgsLeaf];
	
	NSString *themeStr;
	if ([service_cat isEqualToString:kAYStringNursery]) {
		themeStr = service_leaf;
		
	} else if ([service_cat isEqualToString:kAYStringCourse]) {
		themeStr = [NSString stringWithFormat:@"%@·%@%@", service_type, service_leaf, kAYStringCourse];
		
	} else {
		themeStr = @"服务·主题";
	}
	
	themeLabel.text = themeStr;
	
	NSString *punchline = [service_info objectForKey:kAYServiceArgsPunchline];
	titleLabel.text = punchline;
	
	NSString *addressStr = [service_info objectForKey:kAYServiceArgsLocationInfo];
	addressStr = [addressStr substringToIndex:3];
	addressLabel.text = addressStr;
	
	
	NSNumber *iscollect = [service_info objectForKey:kAYServiceArgsIsCollect];
	likeBtn.selected = iscollect.boolValue;
	
	return nil;
}

@end
