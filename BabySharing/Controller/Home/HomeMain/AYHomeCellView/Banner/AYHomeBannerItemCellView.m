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
	self.clipsToBounds = YES;
	
	imageView = [[UIImageView alloc] init];
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	imageView.image = IMGRESOURCE(@"default_image");
	[self addSubview:imageView];
	[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self);
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
