//
//  AYHomeBannerItemCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeBannerItemCellView.h"
#import "AYCommandDefines.h"

@implementation AYHomeBannerItemCellView{
	UIImageView *imageView;
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
	
	self.backgroundColor = [UIColor clearColor];
	
	imageView = [[UIImageView alloc] init];
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	imageView.clipsToBounds = YES;
	imageView.image = IMGRESOURCE(@"default_image");
	[self addSubview:imageView];
	[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self).insets(UIEdgeInsetsMake(22, 27, 22, 27));
	}];
	
	UIView *borderView = [[UIView alloc] init];
	[Tools setViewBorder:borderView withRadius:0 andBorderWidth:1.f andBorderColor:[Tools themeColor] andBackground:[UIColor clearColor]];
	[self addSubview:borderView];
	[borderView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self).insets(UIEdgeInsetsMake(15, 20, 15, 20));
	}];
	
}

- (void)setItemImageWithImageUrl:(NSString *)imageUrl {
	[imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:IMGRESOURCE(@"default_image") options:SDWebImageHighPriority];
}

- (void)setItemImageWithImage:(UIImage *)image {
	imageView.image = image;
}

- (void)setItemImageWithImageName:(NSString*)imageName {
	imageView.image = [UIImage imageNamed:imageName];
}

@end
